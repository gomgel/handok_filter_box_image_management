// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountInfo _$CountInfoFromJson(Map<String, dynamic> json) => CountInfo(
      return_code: json['return_code'] as String,
      return_msg: json['return_msg'] as String,
      return_data: (json['return_data'] as num).toInt(),
    );

Map<String, dynamic> _$CountInfoToJson(CountInfo instance) => <String, dynamic>{
      'return_code': instance.return_code,
      'return_msg': instance.return_msg,
      'return_data': instance.return_data,
    };
