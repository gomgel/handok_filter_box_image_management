import 'package:filter_box_image_management/core/providers/global_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

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
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _captureAndUploadPhoto() async {
    setState(() {
      _uploadStatus = "Opening camera...";
    });

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024, // Set max width, e.g., 1024 pixels
        maxHeight: 768, // Set max height, e.g., 768 pixels
        imageQuality: 80, // Set image quality (0-100, 100 is highest)
      );

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path); // pickedFile.path will point to the scaled/compressed image
        setState(() {
          _uploadStatus = "Photo captured. Ready to upload.";
        });
        _uploadImage();
      } else {
        setState(() {
          _uploadStatus = "User cancelled camera.";
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = "Error capturing photo: $e";
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      setState(() {
        _uploadStatus = "No image selected to upload.";
        _isUploading = false; // Reset if no image
      });
      return;
    }

    setState(() {
      _isUploading = true; // Ensure this is true throughout upload
      _uploadProgress = 0.0;
      _uploadStatus = "Uploading photo (0%)...";
    });

    try {
      final url = Uri.parse('${ref.read(configProvider).host}/upload');
      final request = http.MultipartRequest('POST', url);
      request.fields["emp_0001"]  = ref.read(loginUserProvider).isNotEmpty ? ref.read(loginUserProvider)[0].code : "99999999";
      request.fields["emp_0002"]  = ref.read(loginUserProvider).length > 1 ? ref.read(loginUserProvider)[1].code : "99999999";
      request.fields["emp_0003"]  = ref.read(loginUserProvider).length > 2 ? ref.read(loginUserProvider)[2].code : "99999999" ;
      request.fields["line_code"] = ref.read(loginLineProvider).code.isEmpty ? "9999" : ref.read(loginLineProvider).code;
      request.fields["line_name"] = ref.read(loginLineProvider).name.isEmpty ? "NULL" : ref.read(loginLineProvider).name;
      request.files.add(
        await http.MultipartFile.fromPath(
          'screenshot',
          _imageFile!.path,
          filename: 'camera_photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );

      final streamedResponse = await request.send();
      final totalBytes = streamedResponse.contentLength;
      int bytesUploaded = 0;

      List<int> responseBytes = [];

      // Create a Completer to signal when the stream processing is done
      // This helps ensure the async function truly waits for the stream.
      final uploadCompleter = Completer<String>();

      streamedResponse.stream.listen(
        (List<int> chunk) {
          // Accumulate the response chunks
          responseBytes.addAll(chunk);

          bytesUploaded += chunk.length;
          if (totalBytes != null && totalBytes > 0) {
            setState(() {
              _uploadProgress = bytesUploaded / totalBytes;
              _uploadStatus = "Uploading photo (${(_uploadProgress * 100).toStringAsFixed(0)}%)...";
            });
          }
        },
        onDone: () async {
          //final responseBody = await streamedResponse.stream.bytesToString(); // This line might have been the issue if stream was already read
          final responseBody = utf8.decode(responseBytes);
          if (streamedResponse.statusCode == 200) {
            uploadCompleter.complete("Success");
            setState(() {
              _uploadStatus = "Photo uploaded successfully!\nResponse: $responseBody";
              _uploadProgress = 1.0;
              // Optional: Clear _imageFile here if you want to allow picking a new one
              // _imageFile = null;
            });
          } else {
            uploadCompleter.completeError("Failed: ${streamedResponse.statusCode}");
            setState(() {
              _uploadStatus = "Failed to upload photo. Status: ${streamedResponse.statusCode}\nResponse: $responseBody";
              _uploadProgress = 0.0;
            });
          }
          setState(() {
            _isUploading = false; // Reset after stream is fully processed
          });
        },
        onError: (error) {
          uploadCompleter.completeError(error);
          setState(() {
            _uploadStatus = "Error during upload: $error";
            _uploadProgress = 0.0;
            _isUploading = false; // Reset on error
          });
        },
      );

      // Wait for the stream processing to complete
      await uploadCompleter.future;
    } catch (e) {
      setState(() {
        _isUploading = false; // Reset on outer catch error
        _uploadStatus = "Error during upload: $e";
        _uploadProgress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _imageFile == null
              ? const Text('')
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _captureAndUploadPhoto,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
            child: const Text(
              '사진 찍기 및 업로드',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
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
            ),
        ],
      ),
    );
  }
}
