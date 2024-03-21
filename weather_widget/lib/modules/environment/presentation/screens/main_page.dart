import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_widget/modules/environment/presentation/bloc/environment_bloc/environment_bloc.dart';
import 'package:weather_widget/modules/environment/presentation/bloc/environment_bloc/environment_bloc.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<EnvironmentBloc>(context)
        .add(const EnvironmentEvent.receiveData());

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: BlocBuilder<EnvironmentBloc, EnvironmentState>(
            builder: (context, state) {
              return state.map(
                  loading: (value) {
                    return const CircularProgressIndicator();
                  },
                  loaded: (value) {
                    return Text(value.data.toString());
                  },
                  error: (value) {
                    return Text(value.massage);
                  },
              );



              // return Container(
              //   width: 100,
              //   height: 200,
              //   color: Colors.black,
              //   child: const Text('T1 C, H1 %, P mmHd'),
              // );
            },
          ),
        ),
      ),
    );
  }
}
