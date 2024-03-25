import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/bloc/environment_bloc/environment_bloc.dart';

@RoutePage()
class MainPage extends StatelessWidget {

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final block = BlocProvider.of<EnvironmentBloc>(context)
        ..add(const EnvironmentEvent.receiveData());
    final liltError = <String>[];
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
                    final res = '${DateTime.now()} ${value.massage}';
                    liltError.add(res);
                    if(liltError.length>=10)liltError.removeAt(0);
                    return Text(liltError.toString());
                  },
                  stop: (value) {
                    return Text('Poll stopped'.hardcoded);
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
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(onPressed: ()=>
            block.add(const EnvironmentEvent.stopGet()),
            tooltip: 'Stop'.hardcoded,
            child: const Icon(Icons.stop),
          ),
          10.w,
          FloatingActionButton(onPressed: ()=>
              block
                  ..add(const EnvironmentEvent.startGet())
                  ..add(const EnvironmentEvent.receiveData()),
            tooltip: 'Start'.hardcoded,
            child: const Icon(Icons.start),
          ),
        ],
      ),
    );
  }
}
