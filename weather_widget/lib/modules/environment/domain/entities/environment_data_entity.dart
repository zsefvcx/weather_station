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
  final double tempInt;
  final double humidityInt;
  final double tempExt;
  final double humidityExt;
  final double pressure;

  const EnvironmentDataEntity({
    required this.uuid,
    required this.dateTime,
    required this.tempInt,
    required this.humidityInt,
    required this.tempExt,
    required this.humidityExt,
    required this.pressure,
    this.id,
  });

  @override
  List<Object?> get props => [id, uuid, dateTime, tempInt, humidityInt, tempExt, humidityExt, pressure];

  @override
  String toString() {
    return 'MainDataEntity{ id: $id,'
                        ' uuid: $uuid,'
                    ' dateTime: $dateTime,'
                     ' tempInt: $tempInt,'
                 ' humidityInt: $humidityInt,'
                     ' tempExt: $tempExt,'
                 ' humidityExt: $humidityExt,'
                    ' pressure: $pressure,}';
  }
}
