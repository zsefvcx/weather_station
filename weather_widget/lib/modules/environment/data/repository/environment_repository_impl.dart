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
  Stream<(Failure?, EnvironmentDataEntity?)> receiveData() {
    final stream = featureRemoteDataSource.receiveData();
    return stream.map<(Failure?, EnvironmentDataEntity?)>((value) {
      try {
        if (value == null) return (const ServerFailure(errorMessage: serverFailureMessage), null);
        if (value.$1 != null) return (value.$1, null);
        final data = value.$2;
        if (data == null) return (const ServerFailure(errorMessage: unexpectedErrorMessage), null);
        return (
          null,
          EnvironmentDataModels(
            dateTime: DateTime.now(),
            uuid: uuid.v4(),
            tempInt: data.temperature ?? -273,
            tempExt: data.temperature2 ?? -273,
            humidityInt: data.humidity ?? -1,
            humidityExt: data.humidity2 ?? -1,
            pressure: data.pressure ?? -1,
          )
        );
      } on Exception catch (e) {
        Logger.print(e.toString(), error: true, level: 1);
        return (const ServerFailure(errorMessage: serverFailureMessage), null);
      }
    }).timeout(
        const Duration(seconds: Constants.periodicECSec),
        onTimeout: (sink) {

        });
  }

  @override
  Failure? startGet() {
     return featureRemoteDataSource.startGet();
  }

  @override
  Failure? stopGet() {
      return featureRemoteDataSource.stopGet();
  }
}
