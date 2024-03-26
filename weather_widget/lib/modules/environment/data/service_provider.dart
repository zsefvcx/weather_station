import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class ServiceProvider {
  static final _getIt = GetIt.I;

  final FeatureLocalDataSource featureLocalData = FeatureLocalDataSourceImpl();
  final NetworkInfo networkInfo = NetworkInfoImp(
    internetConnectionChecker: InternetConnectionChecker(),
  );

  late final FeatureRemoteDataSource featureRemoteData;

  T get<T extends Object>() => _getIt.get<T>();

  static final instance = ServiceProvider();

  void initialize() {
    featureRemoteData = FeatureRemoteDataSourceImpl(
      streamService: EnvironmentStreamService(),
      networkInfo: networkInfo,
    );

    _getIt.registerLazySingleton<EnvironmentRepository>(
      () => EnvironmentRepositoryImpl(
        networkInfo: networkInfo,
        featureLocalDataSource: featureLocalData,
        featureRemoteDataSource: featureRemoteData,
      ),
    );
  }

  void dispose(){
    featureRemoteData.dispose();
  }
}
