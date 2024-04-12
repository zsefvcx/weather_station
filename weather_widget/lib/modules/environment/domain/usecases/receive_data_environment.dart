import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class ReceiveDataEnvironment with UseCase<EnvironmentDataEntity> {
  final EnvironmentRepository environmentRepository;

  ReceiveDataEnvironment({required this.environmentRepository});

  ///можно явно не указывать метод call
  ///ReceiveDataEnvironment.call(); => getAllPersons();
  @override
  Stream<TypeOfResponse<EnvironmentDataEntity>> call() {
    return environmentRepository.receiveData().map((event) => event);
  }
  
  
  Failure? start() {
    return environmentRepository.startGet();
  }

  Failure? stop() {
    environmentRepository.isReceived = false;
    return environmentRepository.stopGet();
  }

  bool status(){
    return environmentRepository.isReceived;
  }

}
