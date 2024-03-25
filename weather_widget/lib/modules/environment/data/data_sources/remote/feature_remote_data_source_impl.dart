import 'dart:developer' as dev;

import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';

class FeatureRemoteDataSourceImpl extends FeatureRemoteDataSource {
  final EnvironmentStreamService streamService;
  UDPClientSenderReceiver? receiver;
  final NetworkInfo networkInfo;

  FeatureRemoteDataSourceImpl({
    required this.streamService,
    required this.networkInfo,
  });

  @override
  Stream<(Failure?, EnvironmentalConditions?)?> receiveData() {
    return streamService.stream;
  }

  @override
  Failure? startGet() {
    try {
      streamService.initial();
      (receiver??(receiver = UDPClientSenderReceiver(
        serviceEC: streamService,
        type: TypeDataRcv.single,
        networkInfo: networkInfo,
        address: Settings.remoteAddress,
        bindPort: 0,
      ))).run(broadcastEnabled: false);
      return null;
    } on Exception catch (e) {
      Logger.print(
        e.toString(),
        error: true,
        level: 10,
      );
      return const ServerFailure(errorMessage: 'Error start service');
    }
  }

  @override
  Failure? stopGet() {
    try {
      receiver?.dispose();
      streamService.dispose();
      return null;
    } on Exception catch (e) {
      Logger.print(
        e.toString(),
        error: true,
        level: 10,
      );
      return const ServerFailure(errorMessage: 'Error stop service');
    }
  }

  @override
  void dispose(){
    streamService.dispose();
  }
}
