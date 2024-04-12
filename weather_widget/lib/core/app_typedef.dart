
import 'package:weather_widget/core/core.dart';

//Ответ для блока
typedef TypeOfResponse<T> = ({Failure? failure, TypeData type, T? data});
//Ответ из ресивера
typedef TypeOfReceiver<T> = ({Failure? failure, T? data});
