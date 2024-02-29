import 'package:get_it/get_it.dart';

import '../../data/data.dart';
import '../domain.dart';

class BlocFactory {
  static final _getIt = GetIt.I;

  T get<T extends Object>() => _getIt.get<T>();

  static final instance = BlocFactory();

  void initialize(){
    ServiceProvider.instance.initialize();

    _getIt.registerLazySingleton<MainBloc>(
          () => MainBloc(
        repository:  ServiceProvider.instance.get<FeatureRepository>(),
      ),
    );

  }
}
