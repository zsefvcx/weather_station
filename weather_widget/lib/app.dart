import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/core.dart';
import 'modules/modules.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    final mainBloc = FeatureBlocsInit.mainBloc;
    final appRouter = AppRouter();

    return MultiProvider(
      providers: [
        Provider<MainBloc>(
          create: (_) => mainBloc,
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
      ),
    );
  }
}
