import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class ReceiveDataEnvironment with UseCase<EnvironmentDataEntity, TypeData> {
  final EnvironmentRepository environmentRepository;

  ReceiveDataEnvironment({required this.environmentRepository});

  ///можно явно не указывать метод call
  ///ReceiveDataEnvironment.call(); => getAllPersons();
  // @override
  //  Stream<({EnvironmentDataEntity? data, Failure? falure, TypeData type,})> call() {
  //    return environmentRepository.receiveData();
  //  }
  @override
  Stream<({EnvironmentDataEntity? data, Failure? failure, TypeData type})> call() {
    return environmentRepository.receiveData().map((event) => event);
  }
  
  
  Failure? start() {
    return environmentRepository.startGet();
  }

  Failure? stop() {
    return environmentRepository.stopGet();
  }
}
