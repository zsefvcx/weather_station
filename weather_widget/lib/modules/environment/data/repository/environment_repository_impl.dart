import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class EnvironmentRepositoryImpl extends EnvironmentRepository {
  final FeatureRemoteDataSource featureRemoteDataSourceMultiCast;
  final FeatureRemoteDataSource featureRemoteDataSourceClient;
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
    required this.featureRemoteDataSourceMultiCast,
    required this.featureRemoteDataSourceClient,
  });

  @override
  Stream<(Failure?, TypeData, EnvironmentDataEntity?)> receiveData() {
    final stream = featureRemoteDataSourceMultiCast.receiveData();
    return stream.asyncMap<(Failure?, TypeData, EnvironmentDataEntity?)>((value) async {
      try {
        Failure? multiCastFailure;
        Failure? clientFailure;
        Failure? cacheFailure;

        if (value == null) {
          multiCastFailure = const ServerFailure(errorMessage: Constants.serverFailureMessage);
        } else {
          if (value.$1 != null) {
            multiCastFailure = value.$1;
          } else {
            final data = value.$2;
            if (data == null) {
              multiCastFailure = const ServerFailure(errorMessage: Constants.serverFailureMessage);
            } else {
              _data = data;
              _type = TypeData.external;
            }
          }
        }

        //Данные не пришли читаем из кеша
        try {
          if (_data.uuid == Constants.nullUuid &&
              multiCastFailure is ServerFailure) {
            //Если кеш чистый то читаем данные из памяти
            _type = TypeData.internal;
            _localDataCache =
            await featureLocalDataSource.getLastDataFromCache();
            _data = _localDataCache ?? _data;
            _type = TypeData.internal;
          }
        } on Exception catch(e){
          Logger.print(e.toString(), error: true, level: 1);
          cacheFailure = const CacheFailure(errorMessage: Constants.cacheFailureMessage);
        }

        //Если нет данных то обращаемся через клиента, подразумевая что ip внешний
        if(multiCastFailure is ServerFailure) {
          final deltaTimeInSecond = _data.dateTime
              .difference(DateTime.now())
              .inSeconds
              .abs();
          //Если данные не пришли больше определенного времени,
          try {
            if (_data.uuid == Constants.nullUuid
              || deltaTimeInSecond >= Constants.timeOutShowError ) {
              //останавливаем мультикаст прием
              featureRemoteDataSourceMultiCast.suspend();
              //Делаем сингл запрос
              featureRemoteDataSourceClient.resume();

              final stream = featureRemoteDataSourceClient.receiveData();
              final value = await stream.first.timeout(Constants.periodic,);
              if (value != null) {
                if (value.$1 != null) {
                  multiCastFailure = value.$1;
                } else {
                  final data = value.$2;
                  if (data == null) {
                    multiCastFailure = const ServerFailure(
                        errorMessage: Constants.serverFailureMessage);
                  } else {
                    _data = data;
                    _type = TypeData.external;
                  }
                }
              }
              featureRemoteDataSourceMultiCast.resume();
            }
          } on Exception catch (e) {
            featureRemoteDataSourceMultiCast.resume();
            Logger.print(e.toString(), error: true, level: 1);
            clientFailure =
            const ServerFailure(errorMessage: Constants.cacheFailureMessage);
          }
        }

        //Записываем новые данные
        try {
          if (_localDataCache != _data) {
            //Пишем данные в кеш, если разница между последней записью и текущими данными больше определенного времени.
            //Все сделано для винды или линуха, для андройд скорее всего надо менять таймауты
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
        //Время ожидания для определения как долго должна молчать метеостанция
        //Все сделано для винды или линуха, для андройд скорее всего надо менять таймауты по приему и работе в фоне
        final deltaTimeInSecond = _data.dateTime.difference(DateTime.now()).inSeconds.abs();
        Logger.print('deltaTimeInSecond:$deltaTimeInSecond', level: 1);
        Logger.print('type:$_type',  level: 1);
        Logger.print('data:$_data', level: 1);
        Logger.print('cacheFailure:$cacheFailure', error: true, level: 1);
        Logger.print('multiCastFailure:$multiCastFailure', error: true, level: 1);
        Logger.print('clientFailure:$clientFailure', error: true, level: 1);
        return (
          (deltaTimeInSecond >= Constants.timeOutShowError
               || _data.uuid == Constants.nullUuid) ?(clientFailure??multiCastFailure):cacheFailure,
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
      featureRemoteDataSourceMultiCast.startGet();
      featureRemoteDataSourceClient.startGet();
    } on Exception catch(e){
      Logger.print(e.toString(), error: true);
      return const ServerFailure(errorMessage: Constants.serverFailureMessage);
    }
    return null;
  }

  @override
  Failure? stopGet() {
    try {
      featureRemoteDataSourceMultiCast.stopGet();
      featureRemoteDataSourceClient.stopGet();
    } on Exception catch(e){
      Logger.print(e.toString(), error: true);
      return const ServerFailure(errorMessage: Constants.serverFailureMessage);
    }
    return null;
  }
}
