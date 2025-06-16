
import 'package:filter_box_image_management/core/models/search_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'line_model.g.dart';

@JsonSerializable()
class LineInfo {
  final String return_code;
  final String return_msg;
  final List<LineModel> return_data;

  LineInfo({
    required this.return_code,
    required this.return_msg,
    required this.return_data,
  });

  factory LineInfo.fromJson(Map<String, dynamic> json)
  => _$LineInfoFromJson(json);

  List<SearchModel> toSearchItems() {
    return return_data.map((item) => SearchModel(code: item.line_no, name: item.line_nm)).toList();
  }
}

@JsonSerializable()
class LineModel  {
  final String line_no;
  final String line_nm;

  LineModel({
    required this.line_no,
    required this.line_nm,
  });

  factory LineModel.withEmpty()
  => LineModel(line_no: "", line_nm: "");

  factory LineModel.fromJson(Map<String, dynamic> json)
  => _$LineModelFromJson(json);

  Map<String, dynamic> toJson() => _$LineModelToJson(this);

  bool isEqual(LineModel model) {
    return model.line_no == line_no;
  }

  bool isEmpty(){
    return line_no.isEmpty;
  }

  @override
  String toString() {
    return 'LineModel{line_no: $line_no, line_nm: $line_nm}';
  }
}
