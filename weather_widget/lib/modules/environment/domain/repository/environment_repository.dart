import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

enum TypeData{
  internal,
  external,
  another;

  @override
  String toString() {
    switch (index) {
      case 0:
        return 'internal';
      case 1:
        return 'external';
      case 3:
        return 'another';
      default:
        return name;
    }
  }
}

abstract class EnvironmentRepository {

  ///Начать получение данных при старте программы
  Failure? startGet();
  ///Остановить получение данных, в случае выхода или закрытия программы или окна, для очистки данных
  Failure?  stopGet();
  ///В случае прихода данных наблюдать и получать их.
  Stream<(Failure?, TypeData, EnvironmentDataEntity?)> receiveData();

  /// Обращение к базе данных другой репозиторий
  // Future<(Failure?, EnvironmentDataEntity?)> getPrev(int step);
  // Future<(Failure?, EnvironmentDataEntity?)> getNext(int step);
  // Future<(Failure?, EnvironmentDataEntity?)> getDayCurrent();
  // Future<(Failure?, EnvironmentDataEntity?)> getMonthCurrent();
}
