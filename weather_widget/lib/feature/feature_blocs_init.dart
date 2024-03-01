import 'domain/domain.dart';

abstract class FeatureBlocsInit{
  static late final MainBloc mainBloc;

  static void initState() {
    BlocFactory.instance.initialize();
    mainBloc = BlocFactory.instance.get<MainBloc>();
  }
}
