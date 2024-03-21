import 'package:uuid/uuid.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';


class EnvironmentRepositoryImpl extends EnvironmentRepository {

 final FeatureRemoteDataSource featureRemoteDataSource;
 final FeatureLocalDataSource featureLocalDataSource;
 final NetworkInfo networkInfo;
 final uuid = const Uuid();

 EnvironmentRepositoryImpl({
   required this.featureLocalDataSource,
   required this.networkInfo,
   required this.featureRemoteDataSource,
 });

  @override
  Future<(Failure?, EnvironmentDataEntity?)> receiveData() async {
    final mockData = EnvironmentDataModels(
      dateTime: DateTime.now(),
      uuid: uuid.v1(),
      tempInt: 25.1,
      tempExt: -10.2,
      humidityInt: 50,
      humidityExt: 45,
      pressure: 750,
    );

    if (await networkInfo.isConnected) {
      ///Из сети
      return (null , await Future.delayed(const Duration(seconds: 5), () => mockData,));

      ///Потом надо будет их сохранить в базу данных

    }
    ///Из локального хранилища последний сохраненный
    return (null , await Future.delayed(const Duration(milliseconds: 200), () => mockData,));
  }

  @override
  Future<Failure?> startGet() async{
    ///Запускаем процесс получения данных
    return null;
  }

  @override
  Future<Failure?> stopGet() async{
    ///Останавливаем процесс полученимя данных
    return null;
  }







}
