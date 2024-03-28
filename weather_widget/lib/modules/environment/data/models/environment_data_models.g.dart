// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_data_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnvironmentDataModels _$EnvironmentDataModelsFromJson(
        Map<String, dynamic> json) =>
    EnvironmentDataModels(
      uuid: json['uuid'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      tempInt: (json['tempInt'] as num?)?.toDouble(),
      humidityInt: (json['humidityInt'] as num?)?.toDouble(),
      tempExt: (json['tempExt'] as num?)?.toDouble(),
      humidityExt: (json['humidityExt'] as num?)?.toDouble(),
      pressure: (json['pressure'] as num?)?.toDouble(),
      id: json['id'] as int?,
    );

Map<String, dynamic> _$EnvironmentDataModelsToJson(
        EnvironmentDataModels instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'dateTime': instance.dateTime.toIso8601String(),
      'tempInt': instance.tempInt,
      'humidityInt': instance.humidityInt,
      'tempExt': instance.tempExt,
      'humidityExt': instance.humidityExt,
      'pressure': instance.pressure,
    };
