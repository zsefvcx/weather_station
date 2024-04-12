import 'package:uuid/uuid.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';

class FeatureRemoteDataSourceImpl extends FeatureRemoteDataSource {

  UDPClientSenderReceiver? receiver;
  final NetworkInfo networkInfo;
  final uuid = const Uuid();

  final TypeDataRcv type;//TypeDataRcv.single;

  FeatureRemoteDataSourceImpl({
    required super.streamService,
    required this.networkInfo,
    this.type = TypeDataRcv.multi,
  });

  @override
  Stream<({Failure? failure, EnvironmentDataModels? data})?> receiveData() {
    final stream = streamService.stream;
    return stream.map<({Failure? failure, EnvironmentDataModels? data})>((value) {
      try{
        Logger.print('FeatureRemoteDataSourceImpl stream.map V:$value', level: 1);
        if (value == null) {
          return (
            failure:const ServerFailure(
                errorMessage: Constants.serverFailureMessage
            ),
            data: null
          );
        }
        if (value.failure != null) return (failure:value.failure, data:null);
        final data = value.dataEnv;
        if (data == null) {
          return (
            failure:const ServerFailure(
                errorMessage: Constants.unexpectedErrorMessage
            ),
            data: null
          );
        }
        return (
          failure: null,
          data: EnvironmentDataModels(
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
      streamService.initial(type);
      receiver = UDPClientSenderReceiver(
        serviceEC: streamService,
        type: type,
        networkInfo: networkInfo,
        address: (type == TypeDataRcv.single)?Settings.remoteAddress:Constants.address,
        bindPort: (type == TypeDataRcv.single)?0:Constants.bindPort,
      );
      // if(type != TypeDataRcv.single){
      //   receiver?.run(broadcastEnabled: type != TypeDataRcv.single);
      // }
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
  void launching() {
    receiver?.serviceEC.initial(type);
    receiver?.run(broadcastEnabled: type != TypeDataRcv.single);
  }
}
