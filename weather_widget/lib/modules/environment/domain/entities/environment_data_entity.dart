import 'package:equatable/equatable.dart';

///Класс состояния окружающей среды
abstract class EnvironmentDataEntity extends Equatable{
  /// id в базе данных
  final int? id;
  ///Уникальный идентификатор
  /// Generate a v1 (time-based) id
  final String uuid;
  ///Дата и время получения крайних данных или тех данных которые показываются
  final DateTime dateTime;
  ///Сами данные
  final bool errorInt;
  final double? tempInt;
  final double? humidityInt;

  final bool errorExt;
  final double? tempExt;
  final double? humidityExt;

  final double? pressure;

  const EnvironmentDataEntity({
    required this.uuid,
    required this.dateTime,
    required this.errorInt,
    required this.errorExt,
    this.tempInt,
    this.humidityInt,
    this.tempExt,
    this.humidityExt,
    this.pressure,
    this.id,
  });

  @override
  List<Object?> get props => [id, uuid, errorInt, dateTime, tempInt, humidityInt, errorExt, tempExt, humidityExt, pressure];

  @override
  String toString() {
    return 'MainDataEntity{ id: $id,'
                        ' uuid: $uuid,'
                    ' dateTime: $dateTime,'
                     ' errorInt: $errorInt'
                     ' tempInt: $tempInt,'
                 ' humidityInt: $humidityInt,'
                     ' errorExt: $errorExt'
                     ' tempExt: $tempExt,'
                 ' humidityExt: $humidityExt,'
                    ' pressure: $pressure,}';
  }
}
