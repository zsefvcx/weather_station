import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

typedef TypeOfResponse = ({Failure? failure, TypeData type, EnvironmentDataEntity? data});

abstract class EnvironmentRepository {

  ///Начать получение данных при старте программы
  Failure? startGet();
  ///Остановить получение данных, в случае выхода или закрытия программы или окна, для очистки данных
  Failure?  stopGet();
  ///В случае прихода данных наблюдать и получать их.
  Stream<TypeOfResponse> receiveData();

  ///Статус приема данных
  bool isReceived = false;

  /// Обращение к базе данных другой репозиторий
  // Future<(Failure?, EnvironmentDataEntity?)> getPrev(int step);
  // Future<(Failure?, EnvironmentDataEntity?)> getNext(int step);
  // Future<(Failure?, EnvironmentDataEntity?)> getDayCurrent();
  // Future<(Failure?, EnvironmentDataEntity?)> getMonthCurrent();
}
