import 'dart:ui' as ui;

import 'dart:typed_data';

import 'package:intl/intl.dart'; // For formatting dates

import 'package:filter_box_image_management/core/providers/global_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';

import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import '../../../../core/models/search_model.dart';
import '../../../../core/widgets/base_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: '',
      body: const Column(
        children: [
          Expanded(
            child: UploadCameraPhotoScreen(),
          ),
        ],
      ),
    );
  }
}

class UploadCameraPhotoScreen extends ConsumerStatefulWidget {
  const UploadCameraPhotoScreen({super.key});

  @override
  ConsumerState<UploadCameraPhotoScreen> createState() => _UploadCameraPhotoScreenState();
}

class _UploadCameraPhotoScreenState extends ConsumerState<UploadCameraPhotoScreen> {
  File? _imageFile;
  String _uploadStatus = "";
  int _status = 0;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  final List<bool> _selectedLine = <bool>[true, false];

  // _displayImageBytes holds the bytes for display
  Uint8List? _displayImageBytes;
  // _imageBytesToUpload holds the bytes that will be sent to the server
  Uint8List? _imageBytesToUpload;

  Future<void> _captureAndUploadPhoto() async {
    if (_isUploading) {
      return;
    }

    setState(() {
      _uploadStatus = "Opening camera...";
      _status = 0;
      _isUploading = true;
    });

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 768,
        imageQuality: 80,
      );

      //test
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes(); // Original bytes from picker
        final ui.Image originalImage = await decodeImageFromList(bytes);

        final ui.PictureRecorder recorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(recorder);
        final Paint paint = Paint();

        // Draw the original image
        canvas.drawImage(originalImage, Offset.zero, paint);

        // Get current date
        final now = DateTime.now();
        // Format the date based on current locale and time zone (Seoul, South Korea)
        final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').format(now.toLocal());

        final textPainter = TextPainter(
          text: TextSpan(
            text: formattedDate,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.black,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          textDirection: ui.TextDirection.ltr,
        );
        textPainter.layout();

        // Position the text (e.g., bottom-left)
        final textX = 20.0;
        final textY = originalImage.height.toDouble() - textPainter.height - 20.0;

        // Optional: Add a background for better text visibility
        canvas.drawRect(
          Rect.fromLTWH(textX - 5, textY - 5, textPainter.width + 10, textPainter.height + 10),
          Paint()..color = Colors.black.withOpacity(0.5),
        );

        textPainter.paint(canvas, Offset(textX, textY));

        final ui.Picture picture = recorder.endRecording();
        final ui.Image modifiedImage = await picture.toImage(originalImage.width, originalImage.height);
        final ByteData? byteData = await modifiedImage.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          // --- CRITICAL FIX: Assign modified bytes directly to _imageBytesToUpload and _displayImageBytes ---
          _imageBytesToUpload = byteData.buffer.asUint8List();
          _displayImageBytes = _imageBytesToUpload; // Use the same bytes for display

          setState(() {
            _uploadStatus = "Photo with date captured. Ready to upload.";
            _status = 0;
          });
          await _uploadImage();
        } else {
          setState(() {
            _uploadStatus = "Error encoding modified image.";
            _status = -1;
            _isUploading = false;
          });
        }
      } else {
        setState(() {
          _uploadStatus = "User cancelled camera.";
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = "Error capturing photo: $e";
        _status = -1;
        _isUploading = false;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageBytesToUpload == null) {
      setState(() {
        _uploadStatus = "No image bytes to upload.";
        _status = -1;
        _isUploading = false;
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadStatus = "Uploading photo (0%)..";
      _status = 0;
    });

    try {
      final url = Uri.parse('${ref.read(configProvider).host}/upload');
      final request = http.MultipartRequest('POST', url);

      int _index = 0;
      for(var isSelected in _selectedLine.indexed) {
        if (isSelected.$2) {
          _index = isSelected.$1;
        }
      }

      request.fields["emp_0001"] = ref.read(loginUserProvider).isNotEmpty ? ref.read(loginUserProvider)[0].code : "99999999";
      request.fields["emp_0002"] = ref.read(loginUserProvider).length > 1 ? ref.read(loginUserProvider)[1].code : "99999999";
      request.fields["emp_0003"] = ref.read(loginUserProvider).length > 2 ? ref.read(loginUserProvider)[2].code : "99999999";
      request.fields["line_code"] = ref.read(loginLineProvider)[_index].code;
      request.fields["line_name"] = ref.read(loginLineProvider)[_index].name;

      request.files.add(
        http.MultipartFile.fromBytes(
          'screenshot',
          _imageBytesToUpload!,
          filename: 'camera_photo_${DateTime.now().millisecondsSinceEpoch}.png', // Ensure .png for clarity
        ),
      );

      final streamedResponse = await request.send();
      final totalBytes = streamedResponse.contentLength;
      int bytesUploaded = 0;

      List<int> responseBytes = [];
      final uploadCompleter = Completer<String>();

      streamedResponse.stream.listen(
        (List<int> chunk) {
          responseBytes.addAll(chunk);

          bytesUploaded += chunk.length;
          if (totalBytes != null && totalBytes > 0) {
            setState(() {
              _uploadProgress = bytesUploaded / totalBytes;
              _uploadStatus = "Uploading photo (${(_uploadProgress * 100).toStringAsFixed(0)}%)...";
              _status = 0;
            });
          }
        },
        onDone: () async {
          final responseBody = utf8.decode(responseBytes);

          if (streamedResponse.statusCode == 200) {
            uploadCompleter.complete("Success");
            setState(() {
              //_uploadStatus = "Photo uploaded successfully!\nResponse: $responseBody";
              _uploadStatus = "Photo uploaded successfully!";
              _status = 0;
              _uploadProgress = 1.0;
              _imageBytesToUpload = null;
              //_displayImageBytes = null; // Clear display bytes as well
            });
          } else {
            uploadCompleter.completeError("Failed: ${streamedResponse.statusCode}");
            setState(() {
              //_uploadStatus = "Failed to upload photo. Status: ${streamedResponse.statusCode}\nResponse: $responseBody";
              _uploadStatus = "Failed to upload photo. Status: ${streamedResponse.statusCode}\nResponse: $responseBody";
              _status = -1;
              _uploadProgress = 0.0;
            });
          }
          setState(() {
            _isUploading = false;
          });
        },
        onError: (error) {
          uploadCompleter.completeError(error);
          setState(() {
            _uploadStatus = "Error during upload: $error";
            _status = -1;
            _uploadProgress = 0.0;
            _isUploading = false;
          });
        },
      );

      await uploadCompleter.future;
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadStatus = "Error during upload: $e";
        _status = -1;
        _uploadProgress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          direction: Axis.horizontal,
          onPressed: (int index) {
            setState(
              () {
                //1개 이상의 라인은 무조건 선택 되어서 넘어옴.
                //1개 일 때는 그냥 첫번째꺼만 True 유지..
                if (ref.read(loginLineProvider).length != 1) {
                  for (int i = 0; i < _selectedLine.length; i++) {
                    _selectedLine[i] = i == index;
                  }
                }
              },
            );
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.lightBlueAccent[700],
          selectedColor: Colors.white,
          fillColor: Colors.lightBlueAccent[200],
          color: Colors.lightBlueAccent[400],
          constraints: const BoxConstraints(minHeight: 40.0, minWidth: 160.0),
          isSelected: _selectedLine,
          children: [
            Text(
              ref.read(loginLineProvider)[0].name,
              overflow: TextOverflow.fade,
            ),
            ref.read(loginLineProvider).length != 1
                ? Text(
                    ref.read(loginLineProvider)[1].name,
                    overflow: TextOverflow.fade,
                  )
                : Text(""),
          ],
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _displayImageBytes == null
                    ? Text("")
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 200,
                          child: Image.memory(_displayImageBytes!, fit: BoxFit.cover),
                        ),
                      ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isUploading ? null : _captureAndUploadPhoto,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                  child: const Text(
                    '사진 찍기 및 업로드',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                if (_isUploading)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: _uploadProgress,
                        ),
                        SizedBox(height: 8.0),
                        Text(_uploadStatus),
                      ],
                    ),
                  )
                else
                  Text(
                    _uploadStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _status == -1 ? Colors.red : Colors.white,
                      fontWeight: _status == -1 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
