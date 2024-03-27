import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class EnvironmentRepositoryImpl extends EnvironmentRepository {
  final FeatureRemoteDataSource featureRemoteDataSource;
  final FeatureLocalDataSource featureLocalDataSource;
  final NetworkInfo networkInfo;

  ///Кеш в оперативной памяти
  EnvironmentDataEntity? _data;
  DateTime dateTime = DateTime.now();

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
              dateTime = data.dateTime;
            }
          }
        }
        try {
          if (data == null && _data == null) {
            ///Если кеш чистый то читаем данные из памяти
            type = TypeData.external;
            final data = await featureLocalDataSource.getLastDataFromCache();
            dateTime = data.dateTime;
            _data = data;
          } else if (data != null){
            ///Пишем данные в кеш, если разница между последней записью и текущими данными больше часа
            final data = await featureLocalDataSource.getLastDataFromCache();
            if(data.dateTime.difference(DateTime.now()).inSeconds.abs()>=100){
              await featureLocalDataSource.dataToCache(data);
            }
          }
        } on Exception catch(e){
          Logger.print(e.toString(), error: true, level: 1);
          cacheFailure = const CacheFailure(errorMessage: cacheFailureMessage);
        }
        final deltaTimeInSecond = dateTime.difference(DateTime.now()).inSeconds.abs();
        Logger.print('deltaTimeInHours:$deltaTimeInSecond', error: true, level: 1);
        if(type == TypeData.external) {
          return (
          deltaTimeInSecond > 100 ? failure : cacheFailure,
          type,
          _data,
          );
        }
        if(_data == null || (type == TypeData.internal && _data != null)){
          return (
            failure,
            type,
            _data,
          );
        }
        return (
          failure,
          type,
          _data,
        );
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
