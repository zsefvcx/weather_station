import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class ServiceProvider {
  static final _getIt = GetIt.I;

  final FeatureLocalDataSource featureLocalData = FeatureLocalDataSourceImpl(
    prefs: SharedPreferences.getInstance(),
  );

  final NetworkInfo networkInfo = NetworkInfoImp(
    internetConnectionChecker: InternetConnectionChecker(),
  );

  late final FeatureRemoteDataSource featureRemoteDataMultiCast;
  late final FeatureRemoteDataSource featureRemoteDataClient;

  T get<T extends Object>() => _getIt.get<T>();

  static final instance = ServiceProvider();

  void initialize() {
    featureRemoteDataMultiCast = FeatureRemoteDataSourceImpl(
      streamService: EnvironmentStreamService(),
      networkInfo: networkInfo,
    );
    featureRemoteDataClient = FeatureRemoteDataSourceImpl(
      streamService: EnvironmentStreamService(),
      networkInfo: networkInfo,
      type: TypeDataRcv.single,
    );

    _getIt.registerLazySingleton<EnvironmentRepository>(
      () => EnvironmentRepositoryImpl(
        networkInfo: networkInfo,
        featureLocalDataSource: featureLocalData,
        featureRemoteDataSourceMultiCast: featureRemoteDataMultiCast,
        featureRemoteDataSourceClient: featureRemoteDataClient
      ),
    );
  }

  void dispose(){
    featureRemoteDataMultiCast.dispose();
    featureRemoteDataClient.dispose();
  }
}
