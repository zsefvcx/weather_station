import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class EnvironmentRepositoryImpl extends EnvironmentRepository {
  final FeatureRemoteDataSource featureRemoteDataSource;
  final FeatureLocalDataSource featureLocalDataSource;
  final NetworkInfo networkInfo;

  ///Кеш в оперативной памяти
  EnvironmentDataEntity? _data;

  EnvironmentRepositoryImpl({
    required this.featureLocalDataSource,
    required this.networkInfo,
    required this.featureRemoteDataSource,
  });

  @override
  Stream<(Failure?, TypeData, EnvironmentDataEntity?)> receiveData() {
    final stream = featureRemoteDataSource.receiveData();
    return stream.asyncMap<(Failure?, TypeData, EnvironmentDataEntity?)>((value) async {
      try {
        Failure? failure;
        Failure? cacheFailure;
        EnvironmentDataEntity? data;

        var type = TypeData.internal;
        if (value == null) {
          failure = const ServerFailure(errorMessage: serverFailureMessage);
        } else {
          if (value.$1 != null) {
            failure = value.$1;
          } else {
            data = value.$2;
            if (data == null) {
              failure = const ServerFailure(errorMessage: serverFailureMessage);
            } else {
              _data = data;
            }
          }
        }
        try {
          if (data == null && _data == null) {
            ///Если кеш чистый то читаем данные из памяти
            type = TypeData.external;
            final dataCache = await featureLocalDataSource.getLastDataFromCache();
            _data = dataCache;
          } else if (data != null) {
            ///Пишем данные в кеш, если разница между последней записью и текущими данными больше часа
            EnvironmentDataModels? dataCache;
            try {
              dataCache = await featureLocalDataSource.getLastDataFromCache();
            } on Exception catch (e) {
              Logger.print(e.toString(), error: true, level: 1);
              cacheFailure =
              const CacheFailure(errorMessage: cacheFailureMessage);
            }
            final localData = _data;
            if (dataCache != null && localData != null
                && dataCache.dateTime
                    .difference(localData.dateTime)
                    .inSeconds
                    .abs() > 100) {
              await featureLocalDataSource.dataToCache(localData);

            } else {
              if (localData != null) {
                await featureLocalDataSource.dataToCache(localData);
              }
            }
          }
        } on Exception catch(e){
          Logger.print(e.toString(), error: true, level: 1);
          cacheFailure = const CacheFailure(errorMessage: cacheFailureMessage);
        }
        final deltaTimeInSecond = _data?.dateTime.difference(DateTime.now()).inSeconds.abs()??0;
        Logger.print('deltaTimeInHours:$deltaTimeInSecond', error: true, level: 1);
        Logger.print('type:$type', error: true, level: 1);
        if(type == TypeData.external) {
          return (
          (deltaTimeInSecond >= 450 || _data == null) ? failure : cacheFailure,
          type,
          _data,
          );
        } else {
          return (
          (deltaTimeInSecond >= 450) ? failure : cacheFailure,
          type,
          _data,
          );
        }
      } on Exception catch (e) {
        Logger.print(e.toString(), error: true, level: 1);
        return (const ServerFailure(errorMessage: serverFailureMessage), TypeData.another, _data);
      }
    });
  }

  @override
  Failure? startGet() {
    try {
      featureRemoteDataSource.startGet();
    } on Exception catch(e){
      Logger.print(e.toString(), error: true);
      return const ServerFailure(errorMessage: serverFailureMessage);
    }
    return null;
  }

  @override
  Failure? stopGet() {
    try {
      featureRemoteDataSource.stopGet();
    } on Exception catch(e){
      Logger.print(e.toString(), error: true);
      return const ServerFailure(errorMessage: serverFailureMessage);
    }
    return null;
  }
}
