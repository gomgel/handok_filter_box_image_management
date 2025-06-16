// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineInfo _$LineInfoFromJson(Map<String, dynamic> json) => LineInfo(
      return_code: json['return_code'] as String,
      return_msg: json['return_msg'] as String,
      return_data: (json['return_data'] as List<dynamic>)
          .map((e) => LineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LineInfoToJson(LineInfo instance) => <String, dynamic>{
      'return_code': instance.return_code,
      'return_msg': instance.return_msg,
      'return_data': instance.return_data,
    };

LineModel _$LineModelFromJson(Map<String, dynamic> json) => LineModel(
      line_no: json['line_no'] as String,
      line_nm: json['line_nm'] as String,
    );

Map<String, dynamic> _$LineModelToJson(LineModel instance) => <String, dynamic>{
      'line_no': instance.line_no,
      'line_nm': instance.line_nm,
    };
