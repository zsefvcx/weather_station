import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class EnvironmentRepositoryImpl extends EnvironmentRepository {
  final FeatureRemoteDataSource featureRemoteDataSource;
  final FeatureLocalDataSource featureLocalDataSource;
  final NetworkInfo networkInfo;

  ///Кеш в оперативной памяти
  EnvironmentDataEntity _data = EnvironmentDataModels(
    uuid: Constants.nullUuid,
    dateTime: DateTime.now(),
    errorInt: false,
    errorExt: true,
  );
  ///Кеш прочитанный из памяти
  EnvironmentDataEntity? _localDataCache;

  ///Тип сообщений
  TypeData _type = TypeData.another;

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

        if (value == null) {
          failure = const ServerFailure(errorMessage: Constants.serverFailureMessage);
        } else {
          if (value.$1 != null) {
            failure = value.$1;
          } else {
            final data = value.$2;
            if (data == null) {
              failure = const ServerFailure(errorMessage: Constants.serverFailureMessage);
            } else {
              _data = data;
              _type = TypeData.internal;
            }
          }
        }


        try {
          if (_data.uuid == Constants.nullUuid && _type == TypeData.another) {
            ///Если кеш чистый то читаем данные из памяти
            _type = TypeData.external;
            _localDataCache = await featureLocalDataSource.getLastDataFromCache();
            _data = _localDataCache??_data;
          } else if (_localDataCache != _data) {
            ///Пишем данные в кеш, если разница между последней записью и текущими данными больше часа
            final deltaTimeInSecond = _localDataCache?.dateTime.difference(DateTime.now()).inSeconds.abs();
            if ((_localDataCache?.uuid == Constants.nullUuid
                 || deltaTimeInSecond == null
                 || deltaTimeInSecond > Constants.timeOutSafeDataToCache
                )
                && _data.uuid != Constants.nullUuid
               ){
                await featureLocalDataSource.dataToCache(_data);
                _localDataCache = _data;
            }
            if(_type == TypeData.another) _type = TypeData.internal;
          }
        } on Exception catch(e){
          Logger.print(e.toString(), error: true, level: 1);
          cacheFailure = const CacheFailure(errorMessage: Constants.cacheFailureMessage);
        }

        final deltaTimeInSecond = _data.dateTime.difference(DateTime.now()).inSeconds.abs();
        Logger.print('deltaTimeInSecond:$deltaTimeInSecond', error: true, level: 1);
        Logger.print('type:$_type', error: true, level: 1);

        return (
          (deltaTimeInSecond >= Constants.timeOutShowError
               || _data.uuid == Constants.nullUuid) ? failure : cacheFailure,
          _type,
          _data,
        );
      } on Exception catch (e) {
        Logger.print(e.toString(), error: true, level: 1);
        return (const ServerFailure(errorMessage: Constants.serverFailureMessage), TypeData.another, _data);
      }
    });
  }

  @override
  Failure? startGet() {
    try {
      featureRemoteDataSource.startGet();
    } on Exception catch(e){
      Logger.print(e.toString(), error: true);
      return const ServerFailure(errorMessage: Constants.serverFailureMessage);
    }
    return null;
  }

  @override
  Failure? stopGet() {
    try {
      featureRemoteDataSource.stopGet();
    } on Exception catch(e){
      Logger.print(e.toString(), error: true);
      return const ServerFailure(errorMessage: Constants.serverFailureMessage);
    }
    return null;
  }
}
