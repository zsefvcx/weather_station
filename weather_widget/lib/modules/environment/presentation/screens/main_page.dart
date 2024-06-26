import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  @override
  Widget build(BuildContext context) {
    BlocProvider.of<EnvironmentBloc>(context).add(const EnvironmentEvent.receiveData());

    return ClipRRect(
      borderRadius: BorderRadius.circular(Constants.borderRadius),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: AppColors.blue,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomMainBarWin(
                        title: Constants.title,
                        action: ()async=>context.router.push(const SettingsAppRoute()),
                        iconAction: Icons.settings,
                        textAction: 'Setting',
                      ),
                      const EnvironmentStatusWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: const CustomIconEnvironmentStatus(),
      ),
    );
  }

}
