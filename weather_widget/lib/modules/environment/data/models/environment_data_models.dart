import 'package:json_annotation/json_annotation.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

part 'environment_data_models.g.dart';

@JsonSerializable()
class EnvironmentDataModels extends EnvironmentDataEntity {

  factory EnvironmentDataModels.fromEntity({required EnvironmentDataEntity data}) =>
      EnvironmentDataModels(
        id: data.id,
        uuid: data.uuid,
        dateTime: data.dateTime,
        errorInt: data.errorInt,
        tempInt: data.tempInt,
        humidityInt: data.humidityInt,
        errorExt: data.errorExt,
        tempExt: data.tempExt,
        humidityExt: data.humidityExt,
        pressure: data.pressure,
      );

  const EnvironmentDataModels({
    required super.uuid,
    required super.dateTime,
    required super.errorInt,
    required super.errorExt,
    super.tempInt,
    super.humidityInt,
    super.tempExt,
    super.humidityExt,
    super.pressure,
    super.id,
  });

  /// Connect the generated [ _$EnvironmentDataModelsFromJson ] function to the `fromJson`
  /// factory.
  factory EnvironmentDataModels.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentDataModelsFromJson(json);

  /// Connect the generated [ _$EnvironmentDataModelsToJson ] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EnvironmentDataModelsToJson(this);
}
