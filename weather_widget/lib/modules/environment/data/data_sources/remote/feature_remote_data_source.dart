import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/data/data.dart';

abstract class FeatureRemoteDataSource {
  ///Начать получение данных при старте программы
  void startGet();
  ///Остановить получение данных, в случае выхода или закрытия программы или окна, для очистки данных
  void  stopGet();
  ///В случае прихода данных наблюдать и получать их.
  Stream<(Failure?, EnvironmentDataModels?)?> receiveData();

  ///Очищаем все за собой
  void dispose();

  ///Приостановить
  void suspend();

  ///Возобновить
  void resume();
}
