
//base
abstract class CommonIfModelBase{}

class CommonIfModelInit extends CommonIfModelBase{}

//error
class CommonIfModelError extends CommonIfModelBase{
  final String message;
  CommonIfModelError({required this.message});
}
//loading
class CommonIfModelLoading extends CommonIfModelBase{}

//empty
class CommonIfModelEmpty extends CommonIfModelBase{}

//data
class CommonIFModel<T, F> extends CommonIfModelBase{
  final T item;
  final F? obj;
  CommonIFModel({required this.item, this.obj});
}



