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
      errorInt: json['errorInt'] as bool,
      errorExt: json['errorExt'] as bool,
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
      'errorInt': instance.errorInt,
      'tempInt': instance.tempInt,
      'humidityInt': instance.humidityInt,
      'errorExt': instance.errorExt,
      'tempExt': instance.tempExt,
      'humidityExt': instance.humidityExt,
      'pressure': instance.pressure,
    };
