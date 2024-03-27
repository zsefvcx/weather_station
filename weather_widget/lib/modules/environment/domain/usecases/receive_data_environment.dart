import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class ReceiveDataEnvironment with UseCase<EnvironmentDataEntity, TypeData> {
  final EnvironmentRepository environmentRepository;

  ReceiveDataEnvironment({required this.environmentRepository});

  ///можно явно не указывать метод call
  ///ReceiveDataEnvironment.call(); => getAllPersons();
  @override
  Stream<(Failure?, TypeData, EnvironmentDataEntity?)> call() {
    return environmentRepository.receiveData();
  }

  Failure? start() {
    return environmentRepository.startGet();
  }

  Failure? stop() {
    return environmentRepository.stopGet();
  }

}
