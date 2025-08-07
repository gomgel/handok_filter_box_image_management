
import 'package:filter_box_image_management/core/models/search_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'count_model.g.dart';

@JsonSerializable()
class CountInfo {
  final String return_code;
  final String return_msg;
  final int return_data;

  CountInfo({
    required this.return_code,
    required this.return_msg,
    required this.return_data,
  });

  factory CountInfo.fromJson(Map<String, dynamic> json)
  => _$CountInfoFromJson(json);

}

