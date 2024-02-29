import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain.dart';

part 'main_bloc.freezed.dart';
part 'main_event.dart';
part 'main_state.dart';
part 'main_data.dart';

class MainBloc extends Bloc<MainBlocEvent, MainBlocState>{

  final FeatureRepository repository;

  static int timeOutV = 10;

  MainBlocModelData data = const MainBlocModelData(
    timeOut: false,
    data: null,
    e: '',
    error: false,
  );

  MainBloc({
    required this.repository,
  }) : super(const MainBlocState.loading()) {
    on<MainBlocEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
      );
    });
  }

}
