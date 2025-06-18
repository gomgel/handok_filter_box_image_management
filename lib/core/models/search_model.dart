class SearchModel {
  String code = "";
  String name = "";

  SearchModel({required this.code, required this.name});

  factory SearchModel.withEmpty()
  => SearchModel(code: "", name: "");

  bool isEqual(SearchModel model) {
    return model.code == code;
  }

  bool isEmpty(){
    return code.isEmpty;
  }

  @override
  String toString() {
    return "code : $code, name : $name";
  }
}