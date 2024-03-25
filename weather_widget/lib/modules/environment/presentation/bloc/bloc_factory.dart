import 'package:get_it/get_it.dart';
import 'package:weather_widget/modules/environment/data/data.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';
import 'package:weather_widget/modules/environment/presentation/bloc/bloc.dart';

class BlocFactory {
  static final _getIt = GetIt.I;

  T get<T extends Object>() => _getIt.get<T>();

  static final instance = BlocFactory();

  void initialize() {
    ServiceProvider.instance.initialize();

    _getIt.registerLazySingleton<EnvironmentBloc>(
      () => EnvironmentBloc(
        receiveData: ReceiveDataEnvironment(
            environmentRepository:
                ServiceProvider.instance.get<EnvironmentRepository>()),
      ),
    );
  }

  void dispose(){
    ServiceProvider.instance.dispose();
  }
}
