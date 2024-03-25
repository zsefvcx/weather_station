import 'package:weather_widget/core/core.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

abstract class FeatureRemoteDataSource {
  ///Начать получение данных при старте программы
  Failure? startGet();
  ///Остановить получение данных, в случае выхода или закрытия программы или окна, для очистки данных
  Failure?  stopGet();
  ///В случае прихода данных наблюдать и получать их.
  Stream<(Failure?, EnvironmentalConditions?)?> receiveData();

  ///Очищаем все за собой
  void dispose();
}
