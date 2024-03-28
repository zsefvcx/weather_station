import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class EnvironmentWidget extends StatelessWidget {
  const EnvironmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnvironmentBloc, EnvironmentState>(
      builder: (_, state) {
        return state.map(
          loading: (value) {
            return const Padding(
              padding: EdgeInsets.all(15),
              child: Center(child: CircularProgressIndicator()),
            );
          },
          loaded: (value) {
            final data = value.data;
            return Column(
              children: [
                ShowStatusEnvironmentWidget(data: data),
                CustomTextWidget(
                  'lm: ${DateFormat('kk:mm').format(data.dateTime)}'.hrd,
                  failureMessage: true,
                ),
              ],
            );
          },
          error: (value) {
            final data = value.cacheData;
            var message = value.massage;
            if(data != null && data.uuid == Constants.nullUuid){
              message = 'lm: ${DateFormat('kk:mm').format(data.dateTime)} '
                        '${value.massage}'.hrd;
            }
            return Column(
              children: [
                if (data != null) ShowStatusEnvironmentWidget(data: data),
                CustomTextWidget(
                  message,
                  failureMessage: true,
                ),
              ],
            );
          },
          stop: (value) {
            return CustomTextWidget(
              'Poll stopped'.hrd,
              failureMessage: true,
            );
          },
        );
      },
    );
  }
}