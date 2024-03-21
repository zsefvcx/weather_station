import 'presentation/presentation.dart';

abstract class FeatureBlocsInit{
  static late final EnvironmentBloc environmentBloc;

  static void initState() {
    BlocFactory.instance.initialize();
    environmentBloc = BlocFactory.instance.get<EnvironmentBloc>();
    environmentBloc.add(const EnvironmentEvent.startGet());
  }
}
