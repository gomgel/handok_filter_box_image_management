
import 'package:filter_box_image_management/core/models/search_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version_model.g.dart';

@JsonSerializable()
class VersionInfo {
  final String return_code;
  final String return_msg;
  final VersionModel return_data;

  VersionInfo({
    required this.return_code,
    required this.return_msg,
    required this.return_data,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json)
  => _$VersionInfoFromJson(json);

}

@JsonSerializable()
class VersionModel  {
  final String version;
  final String number;

  VersionModel({
    required this.version,
    required this.number,
  });

  factory VersionModel.withEmpty()
  => VersionModel(version: "", number: "");

  factory VersionModel.fromJson(Map<String, dynamic> json)
  => _$VersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$VersionModelToJson(this);

  bool isEqual(VersionModel model) {
    return model.version == version;
  }

  bool isEmpty(){
    return version.isEmpty;
  }

  @override
  String toString() {
    return 'VersionModel{version: $version, number: $number}';
  }
}