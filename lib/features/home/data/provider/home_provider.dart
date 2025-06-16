
import 'package:filter_box_image_management/core/models/employee_model.dart';
import 'package:filter_box_image_management/core/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/common_if_model.dart';
import '../../../../core/models/line_model.dart';
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

  Future<List<SearchModel>> getForSearching({required String name_1st, String name_2nd = "", String name_3rd = ""}) async {

    try {

      // final item = await repository.getEmp(
      //   name_1st: name_1st,
      //   name_2nd: name_2nd,
      //   name_3rd: name_3rd,
      // );
      //
      // return item.toSearchItems();
      return [
        SearchModel(code: '12345', name: "박진덕"),
        SearchModel(code: '22222', name: "홍길동"),
        SearchModel(code: '33333', name: "김철수"),
        SearchModel(code: '44444', name: "김냄비"),
        SearchModel(code: '55555', name: "노트북"),
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


final lineProvider = StateNotifierProvider<LineNotifier, CommonIfModelBase>((ref) {
  final repository = ref.watch(commonRepositoryProvider);
  return LineNotifier(repository);
});

class LineNotifier extends StateNotifier<CommonIfModelBase> {
  final CommonRepository repository;

  LineNotifier(this.repository) : super(CommonIfModelEmpty());

  changeState(){
    state = CommonIfModelLoading();
  }

  get({required String name_1st, String name_2nd = "", String name_3rd = ""}) async {

    if (name_1st.isEmpty) {
      state = CommonIfModelEmpty();
      return;
    }

    try {

      final item = await repository.getLine(
        name_1st: name_1st,
        name_2nd: name_2nd,
        name_3rd: name_3rd,
      );

      state = CommonIFModel<LineInfo, Null>(item: item);

    } catch (e) {
      state = CommonIfModelError(message: e.toString());
      debugPrint("get order error : ${e.toString()}");
    }
  }

  Future<List<SearchModel>> getForSearching({required String name_1st, String name_2nd = "", String name_3rd = ""}) async {

    try {

      // final item = await repository.getLine(
      //   name_1st: name_1st,
      //   name_2nd: name_2nd,
      //   name_3rd: name_3rd,
      // );
      //
      // return item.toSearchItems();
      return [
        SearchModel(code: '12345', name: "1라인"),
        SearchModel(code: '22222', name: "2라인"),
        SearchModel(code: '33333', name: "3라인"),
        SearchModel(code: '44444', name: "4라인"),
        SearchModel(code: '55555', name: "5라인"),
      ];

    } catch (e) {
      //state = CommonIfModelError(message: e.toString());
      debugPrint("getWithSync error : ${e.toString()}");
      return [];
      debugPrint("get order error : ${e.toString()}");
    }
  }

}

