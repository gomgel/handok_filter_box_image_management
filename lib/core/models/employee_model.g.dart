// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeInfo _$EmployeeInfoFromJson(Map<String, dynamic> json) => EmployeeInfo(
      return_code: json['return_code'] as String,
      return_msg: json['return_msg'] as String,
      return_data: (json['return_data'] as List<dynamic>)
          .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmployeeInfoToJson(EmployeeInfo instance) =>
    <String, dynamic>{
      'return_code': instance.return_code,
      'return_msg': instance.return_msg,
      'return_data': instance.return_data,
    };

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      emp_cd: json['emp_cd'] as String,
      emp_nm: json['emp_nm'] as String,
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'emp_cd': instance.emp_cd,
      'emp_nm': instance.emp_nm,
    };
