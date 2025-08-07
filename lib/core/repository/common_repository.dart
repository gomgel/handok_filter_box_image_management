
import 'package:dio/dio.dart' hide Headers;
import 'package:filter_box_image_management/core/models/version_model.dart';
import 'package:retrofit/retrofit.dart';

import '../models/count_model.dart';
import '../models/employee_model.dart';
import '../models/line_model.dart';

part 'common_repository.g.dart';



@RestApi()
abstract class CommonRepository {

  factory CommonRepository(Dio dio, {String baseUrl}) = _CommonRepository;

  @GET('/emp')
  Future<EmployeeInfo> getEmp({
    @Query('name_1st') required String name_1st,
    @Query('name_2nd') required String name_2nd,
    @Query('name_3rd') required String name_3rd,
  });

  @GET('/line')
  Future<LineInfo> getLine({
    @Query('name_1st') required String name_1st,
    @Query('name_2nd') required String name_2nd,
    @Query('name_3rd') required String name_3rd,
  });

  @GET('/info/count')
  Future<CountInfo> getCount({
    @Query('from') required String from,
    @Query('to') required String to,
    @Query('line') required String line,
  });

  @GET('/version')
  Future<VersionInfo> getVersion();

}
