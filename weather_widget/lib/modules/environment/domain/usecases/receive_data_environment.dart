import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

class ReceiveDataEnvironment with UseCase<EnvironmentDataEntity> {
  final EnvironmentRepository environmentRepository;

  ReceiveDataEnvironment({required this.environmentRepository});

  ///можно явно не указывать метод call
  ///ReceiveDataEnvironment.call(); => getAllPersons();
  @override
  Future<(Failure?, EnvironmentDataEntity?)> call() async {
    return environmentRepository.receiveData();
  }

  Future<Failure?> start() async{
    return environmentRepository.startGet();
  }

  Future<Failure?> stop() async{
    return environmentRepository.stopGet();
  }

}
