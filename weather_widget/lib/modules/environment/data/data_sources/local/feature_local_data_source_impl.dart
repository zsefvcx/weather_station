import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data_sources/local/feature_local_data_source.dart';
import 'package:weather_widget/modules/environment/data/models/environment_data_models.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class FeatureLocalDataSourceImpl extends FeatureLocalDataSource {

  final cachedData = 'CACHED_DATA';

  Future<SharedPreferences> prefs;

  FeatureLocalDataSourceImpl({
    required this.prefs,
  });

  @override
  Future<EnvironmentDataModels> getLastDataFromCache() async {
    final prefs = await this.prefs;
    final dataString= prefs.getString(cachedData);
    if (dataString != null) {
      Logger.print('Data read from Cache: $dataString',);
      final jsonData = json.decode(dataString) as Map<String, dynamic>;
      return EnvironmentDataModels.fromJson( jsonData );
    } else {
      throw CacheException(errorMessage: Constants.cacheFailureMessageRead);
    }
  }

  @override
  Future<void> dataToCache(EnvironmentDataEntity value) async {
    final jsonData = json.encode(
        EnvironmentDataModels.fromEntity(data: value).toJson(),
    );
    final prefs = await this.prefs;
    final done =
        await prefs.setString(cachedData, jsonData);
    if (done) {
      Logger.print('Data to write Cache: $jsonData',);
    } else {
      throw CacheException(errorMessage: Constants.cacheFailureMessageWrite);
    }
  }


}
