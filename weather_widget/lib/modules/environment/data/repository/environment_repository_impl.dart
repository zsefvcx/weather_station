import 'dart:async';

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

  Future<Failure?> _readDataFromCache() async {
      Failure? cacheFailure;
      try {
        if (_data.uuid == Constants.nullUuid) {
          Logger.print('stream => read from cache', level: 1);
          //Если кеш чистый то читаем данные из памяти
          _localDataCache = await featureLocalDataSource.getLastDataFromCache();
          _data = _localDataCache ?? _data;
          _type = TypeData.internal;
        }
      } on Exception catch (e) {
        Logger.print(e.toString(), error: true, level: 1);
        cacheFailure =
        const CacheFailure(errorMessage: Constants.cacheFailureMessage);
      }
      return cacheFailure;
  }

  Future<Failure?> _safeDataToCache() async{
    Failure? cacheFailure;
    try {
      if (_localDataCache != _data) {
        //Пишем данные в кеш, если разница между последней записью и текущими данными больше определенного времени.
        //Все сделано для винды или линуха, для андройд скорее всего надо менять таймауты
        final deltaTimeInSecond = _localDataCache?.dateTime
            .difference(DateTime.now())
            .inSeconds
            .abs();
        if ((_localDataCache?.uuid == Constants.nullUuid ||
            deltaTimeInSecond == null ||
            deltaTimeInSecond > Constants.timeOutSafeDataToCache) &&
            _data.uuid != Constants.nullUuid) {
          Logger.print('safeDataToCache _data:$_data', level: 1);
          await featureLocalDataSource.dataToCache(_data);
          _localDataCache = _data;
        }
        if (_type == TypeData.another) _type = TypeData.internal;
      }
    } on Exception catch (e) {
      Logger.print(e.toString(), error: true, level: 1);
      cacheFailure =
      const CacheFailure(errorMessage: Constants.cacheFailureMessage);
    }
    return cacheFailure;
  }

  Future<Failure?> _readDataFromSource(FeatureRemoteDataSource source) async {
    Failure? clientFailure;
    final deltaTimeInSecond =
    _data.dateTime.difference(DateTime.now()).inSeconds.abs();
    //Если данные не пришли
    //или данных нет в кеше то посылаем обычный запрос
    try {
      if (_data.uuid == Constants.nullUuid ||
          deltaTimeInSecond >=
              (Constants.periodicECSec + Constants.timeLimitECSec)) {
        Logger.print(
          'stream => read from server ip:${Settings.remoteAddress}',
          level: 1
        );

        //Делаем сингл запрос
        source.launching();
        //Берем поток
        final stream = source.receiveData();
        //Ожидаем первое сообщение
        final value = await stream.first.timeout(
          //Не более времени сна устройства
          const Duration(seconds: Constants.timeSleepDevices)
        ).onError((error, stackTrace) {
          clientFailure = const ServerFailure(
            errorMessage: Constants.serverFailureMessage);
          return null;
        });
        //Останавливаем опрос, если он сам не остановился до этого
        source.stopRunning();
        //Проверяем сообщение
        if (value != null) {
          if (value.failure != null) {
            clientFailure = value.failure;
          } else {
            final data = value.data;
            if (data == null) {
              clientFailure = const ServerFailure(
                  errorMessage: Constants.serverFailureMessage);
            } else {
              _data = data;
              _type = TypeData.external;
            }
          }
        }
      }
    } on Exception catch (e) {
      Logger.print(e.toString(), error: true, level: 1);
      clientFailure = const ServerFailure(
          errorMessage: Constants.serverFailureMessage);
    }
    //Останавливаем в любом случае, даже если уже все...
    source.stopRunning();
    return clientFailure;
  }

  /// Функция генератор
  @override
  Stream<TypeOfResponse> receiveData() async* {
    if (isReceived) return;
    isReceived = true;
    Failure? multiCastFailure;
    Failure? clientFailure;
    Failure? cacheFailure ;

    //Первый запуск читаем данные из кеша
    cacheFailure = isReceived? await _readDataFromCache():null;

    //Кидаем в поток результат as TypeOfResponse
    if(isReceived){
      yield (
        failure:cacheFailure,
        type: TypeData.another,
        data: _data
      ) as TypeOfResponse;
    } else {
      return;
    }

    //Читаем данные на прямую из источника - как клиент
    clientFailure = isReceived? await _readDataFromSource(featureRemoteDataSourceClient): null;
    //Проверяем на третье состояние (если релоад то есть)
    if (featureRemoteDataSourceClient.statusRunning() == null) {
      isReceived = false;
      return;
    }

    //Если ошибка Читаем данные из источника - как мультикаст клиент
    if(clientFailure is ServerFailure) {
      Logger.print('multiCastFailure:$multiCastFailure', error: true, level: 1);
      multiCastFailure =
      isReceived?await _readDataFromSource(featureRemoteDataSourceMultiCast):null;
      if (featureRemoteDataSourceMultiCast.statusRunning() == null) {
        isReceived = false;
        return;
      }
    }

    //Записываем новые данные
    cacheFailure = isReceived?await _safeDataToCache():null;

    //Время ожидания для определения как долго должна молчать метеостанция
    //Все сделано для винды или линуха, для андройд скорее всего надо менять таймауты по приему и работе в фоне
    final deltaTimeInSecond = _data.dateTime.difference(DateTime.now()).inSeconds.abs();

    //Отладочная информация
    Logger.print('deltaTimeInSecond:$deltaTimeInSecond', level: 1);
    Logger.print('type:$_type', level: 1);
    Logger.print('data:$_data', level: 1);
    Logger.print('cacheFailure:$cacheFailure', error: true, level: 1);
    Logger.print('multiCastFailure:$multiCastFailure', error: true, level: 1);
    Logger.print('clientFailure:$clientFailure', error: true, level: 1);

    //возвращаем результат as TypeOfResponse
    if(isReceived) {
      yield (
        failure: (deltaTimeInSecond >= Constants.timeOutShowError ||
            _data.uuid == Constants.nullUuid)
            ? (clientFailure ?? multiCastFailure)
            : cacheFailure,
        type: TypeData.another,
        data: _data
      ) as TypeOfResponse;
    }
    Logger.print('All Data is update', level: 1);
            //После ожидания 10 минут повторить запрос
            // }).timeout(const Duration(minutes: 10), onTimeout: (_) {
            //     Logger.print('multiCast repeat after 10 minutes', level: 1);
            //     featureRemoteDataSourceMultiCast.launching();
            // },);
    isReceived = false;
  }

  @override
  Failure? startGet() {
    try {
      featureRemoteDataSourceMultiCast.startGet();
      featureRemoteDataSourceClient.startGet();
    } on Exception catch (e) {
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
    } on Exception catch (e) {
      Logger.print(e.toString(), error: true);
      return const ServerFailure(errorMessage: Constants.serverFailureMessage);
    }
    return null;
  }
}
