
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../models/user_model.dart';

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

}
