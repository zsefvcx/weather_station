import 'package:json_annotation/json_annotation.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

part 'environment_data_models.g.dart';

@JsonSerializable()
class EnvironmentDataModels extends EnvironmentDataEntity {
  const EnvironmentDataModels({
    required super.uuid,
    required super.dateTime,
    required super.tempInt,
    required super.humidityInt,
    required super.tempExt,
    required super.humidityExt,
    required super.pressure,
    super.id,
  });

  /// Connect the generated [ _$EnvironmentDataModelsFromJson ] function to the `fromJson`
  /// factory.
  factory EnvironmentDataModels.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentDataModelsFromJson(json);

  /// Connect the generated [ _$EnvironmentDataModelsToJson ] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EnvironmentDataModelsToJson(this);
}
