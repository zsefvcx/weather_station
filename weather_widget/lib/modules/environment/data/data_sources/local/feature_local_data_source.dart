import 'package:weather_widget/modules/environment/data/data.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

abstract class FeatureLocalDataSource {

  Future<EnvironmentDataModels> getLastDataFromCache();

  Future<void> dataToCache(EnvironmentDataEntity value);
}
