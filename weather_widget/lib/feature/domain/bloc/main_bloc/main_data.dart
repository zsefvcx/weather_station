part of 'main_bloc.dart';

//@injectable
class MainBlocModelData {

  final bool timeOut;
  final MainDataEntity? data;
  final bool error;
  final String e;

  bool get isLoaded {
  final localData = data;
  return localData!=null&&localData.contents.isNotEmpty;
 }
  bool get isTimeOut => timeOut;
  bool get isError => error;

  const MainBlocModelData({
    required this.data,
    required this.e,
    required this.timeOut,
    required this.error,
  });

  MainBlocModelData copyWithData({
   required MainDataEntity? data,
    String? e,
    bool? timeOut,
   bool? error,
  }){
    return MainBlocModelData(
      data: data,
      e: e ?? this.e,
      timeOut: timeOut ?? this.timeOut,
      error: error ?? this.error,
    );
  }
}
