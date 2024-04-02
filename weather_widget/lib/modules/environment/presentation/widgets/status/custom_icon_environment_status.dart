
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class CustomIconEnvironmentStatus extends StatelessWidget {
  const CustomIconEnvironmentStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnvironmentBloc, EnvironmentState>(
      builder: (_, state) {
        return state.map(
          loading: (value) => const CustomIcon(
            Icons.connect_without_contact,
          ),
          stop: (value) => const CustomIcon(
            Icons.close,
          ),
          loaded: (value) => CustomIcon(
            value.type != TypeData.external
                ? Icons.leak_add_outlined
                : Icons.leak_remove,
          ),
          error: (value) => const CustomIcon(
            Icons.error_outline_outlined,
            color: AppColors.red,
          ),
        );
      },
    );
  }
}
