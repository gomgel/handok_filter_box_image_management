
import 'package:filter_box_image_management/core/models/search_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeInfo {
  final String return_code;
  final String return_msg;
  final List<EmployeeModel> return_data;

  EmployeeInfo({
    required this.return_code,
    required this.return_msg,
    required this.return_data,
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json)
  => _$EmployeeInfoFromJson(json);

  List<SearchModel> toSearchItems() {
    return return_data.map((item) => SearchModel(code: item.emp_cd, name: item.emp_nm)).toList();
  }
}

@JsonSerializable()
class EmployeeModel  {
  final String emp_cd;
  final String emp_nm;

  EmployeeModel({
    required this.emp_cd,
    required this.emp_nm,
  });

  factory EmployeeModel.withEmpty()
  => EmployeeModel(emp_cd: "", emp_nm: "");

  factory EmployeeModel.fromJson(Map<String, dynamic> json)
  => _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  bool isEqual(EmployeeModel employee) {
    return employee.emp_cd == emp_cd;
  }

  bool isEmpty(){
    return emp_cd.isEmpty;
  }

  @override
  String toString() {
    return 'EmployeeModel{emp_cd: $emp_cd, emp_nm: $emp_nm}';
  }
}
