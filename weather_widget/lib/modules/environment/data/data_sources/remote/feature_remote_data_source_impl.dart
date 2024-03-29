import 'package:uuid/uuid.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';

class FeatureRemoteDataSourceImpl extends FeatureRemoteDataSource {
  final EnvironmentStreamService streamService;
  UDPClientSenderReceiver? receiver;
  final NetworkInfo networkInfo;
  final uuid = const Uuid();

  final TypeDataRcv _type =  TypeDataRcv.multi;//TypeDataRcv.single;

  FeatureRemoteDataSourceImpl({
    required this.streamService,
    required this.networkInfo,
  });

  @override
  Stream<(Failure?, EnvironmentDataModels?)?> receiveData() {
    final stream = streamService.stream;
    return stream.map<(Failure?, EnvironmentDataModels?)>((value) {
      try{
        if (value == null) return (const ServerFailure(errorMessage: Constants.serverFailureMessage), null);
        if (value.$1 != null) return (value.$1, null);
        final data = value.$2;
        if (data == null) return (const ServerFailure(errorMessage: Constants.unexpectedErrorMessage), null);
        return (
        null,
        EnvironmentDataModels(
          dateTime: DateTime.now(),
          uuid: uuid.v4(),
          errorInt: data.error,
          errorExt: data.error2,
          tempInt: data.temperature ?? -273,
          tempExt: data.temperature2 ?? -273,
          humidityInt: data.humidity ?? -1,
          humidityExt: data.humidity2 ?? -1,
          pressure: data.pressure ?? -1,
        )
        );
      } on Exception catch (e) {
        Logger.print(e.toString(), error: true, level: 1);
        throw ServerException(errorMessage: Constants.serverFailureMessage);
      }
    });
  }

  @override
  void startGet() {
    try {
      streamService.initial();
      (receiver??(receiver = UDPClientSenderReceiver(
        serviceEC: streamService,
        type: _type,
        networkInfo: networkInfo,
        address: (_type == TypeDataRcv.single)?Settings.remoteAddress:Constants.address,
        bindPort: (_type == TypeDataRcv.single)?0:Constants.bindPort,
      ))).run(broadcastEnabled: _type != TypeDataRcv.single);
    } on Exception catch (e) {
      Logger.print(
        e.toString(),
        error: true,
        level: 10,
      );
      throw ServerException(errorMessage: 'Error start service');
    }
  }

  @override
  void stopGet() {
    try {
      receiver?.dispose();
      streamService.dispose();
    } on Exception catch (e) {
      Logger.print(
        e.toString(),
        error: true,
        level: 10,
      );
      throw ServerException(errorMessage: 'Error stop service');
    }
  }

  @override
  void dispose(){
    streamService.dispose();
  }
}
