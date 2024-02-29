import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../core/core.dart';
import '../domain/domain.dart';
import 'data.dart';
import 'data_sources/data_sources.dart';

class ServiceProvider{
  static final _getIt = GetIt.I;

  final FeatureRemoteDataSource featureRemoteData = FeatureRemoteDataSourceImpl();
  final FeatureLocalDataSource featureLocalData = FeatureLocalDataSourceImpl();
  final NetworkInfo networkInfo = NetworkInfoImp(internetConnectionChecker: InternetConnectionChecker());

  T get<T extends Object>() => _getIt.get<T>();

  static final instance = ServiceProvider();

  void initialize(){
    _getIt.registerLazySingleton<FeatureRepository>(
          () => FeatureRepositoryImpl(networkInfo: networkInfo,
            featureLocalDataSource: featureLocalData,
            featureRemoteDataSource: featureRemoteData,
          ),
    );
  }
}
