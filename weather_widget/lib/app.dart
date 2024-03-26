import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/modules.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {

    final mainBloc = FeatureBlocsInit.environmentBloc;
    final appRouter = AppRouter();

    return MultiProvider(
      providers: [
        Provider<EnvironmentBloc>(
          create: (_) => mainBloc,
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    FeatureBlocsInit.dispose();
  }
}
