
import 'package:filter_box_image_management/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/common_if_model.dart';
import '../../../../core/providers/common_provider.dart';
import '../../../../core/repository/common_repository.dart';

initProvider(WidgetRef ref, {bool isRegistered = false}) {

}


final employeeProvider = StateNotifierProvider<EmployeeNotifier, CommonIfModelBase>((ref) {
  final repository = ref.watch(commonRepositoryProvider);
  return EmployeeNotifier(repository);
});

class EmployeeNotifier extends StateNotifier<CommonIfModelBase> {
  final CommonRepository repository;

  EmployeeNotifier(this.repository) : super(CommonIfModelEmpty());

  changeState(){
    state = CommonIfModelLoading();
  }

  get({required String name_1st, String name_2nd = "", String name_3rd = ""}) async {

    if (name_1st.isEmpty) {
      state = CommonIfModelEmpty();
      return;
    }

    try {

      final item = await repository.getEmp(
            name_1st: name_1st,
            name_2nd: name_2nd,
            name_3rd: name_3rd,
          );

      state = CommonIFModel<EmployeeInfo, Null>(item: item);

    } catch (e) {
      state = CommonIfModelError(message: e.toString());
      debugPrint("get order error : ${e.toString()}");
    }
  }

  Future<List<EmployeeModel>> getForSearching({required String name_1st, String name_2nd = "", String name_3rd = ""}) async {

    try {

      // final item = await repository.getEmp(
      //   name_1st: name_1st,
      //   name_2nd: name_2nd,
      //   name_3rd: name_3rd,
      // );
      //
      // return item.return_data;
      return [
        EmployeeModel(emp_cd: '12345', emp_nm: "박진덕"),
        EmployeeModel(emp_cd: '12345', emp_nm: "홍길동"),
        EmployeeModel(emp_cd: '12345', emp_nm: "박시우"),
        EmployeeModel(emp_cd: '12345', emp_nm: "드래곤")
      ];

      //state = CommonIFModel<EmployeeInfo, Null>(item: item);

    } catch (e) {
      //state = CommonIfModelError(message: e.toString());
      debugPrint("getWithSync error : ${e.toString()}");
      return [];
      debugPrint("get order error : ${e.toString()}");
    }
  }

}
