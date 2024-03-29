import 'package:auto_route/auto_route.dart';

import 'package:weather_widget/modules/modules.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {

  @override
  List<AutoRoute> get routes => [
    /// routes go here
    AutoRoute(
        page: MainRoute.page,
        initial: true,
        children: const [
          /// children routes go here
        ]
    ),
    AutoRoute(
        page: SettingsAppRoute.page,
        children: const [
          /// children routes go here
        ]
    ),
  ];
}
