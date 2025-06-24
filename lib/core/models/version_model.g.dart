// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionInfo _$VersionInfoFromJson(Map<String, dynamic> json) => VersionInfo(
      return_code: json['return_code'] as String,
      return_msg: json['return_msg'] as String,
      return_data:
          VersionModel.fromJson(json['return_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VersionInfoToJson(VersionInfo instance) =>
    <String, dynamic>{
      'return_code': instance.return_code,
      'return_msg': instance.return_msg,
      'return_data': instance.return_data,
    };

VersionModel _$VersionModelFromJson(Map<String, dynamic> json) => VersionModel(
      version: json['version'] as String,
      number: json['number'] as String,
    );

Map<String, dynamic> _$VersionModelToJson(VersionModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'number': instance.number,
    };
