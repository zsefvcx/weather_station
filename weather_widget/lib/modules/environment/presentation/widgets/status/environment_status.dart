import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class EnvironmentStatusWidget extends StatelessWidget {
  const EnvironmentStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnvironmentBloc, EnvironmentState>(
      builder: (_, state) {
        return state.map(
          loading: (value) {
            return const Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          stop: (value) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: CustomTextWidget('Poll stopped'.hrd),
              ),
            );
          },
          loaded: (value) {
            final data = value.data;
            Logger.print('loaded data:$data', level: 1);
            return Column(
              children: [
                ShowStatusEnvironmentWidget(data: data),
                const Divider(height: 10,),
                LastMessageDataTime(dateTime: data.dateTime),
              ],
            );
          },
          error: (value) {
            final data = value.cacheData;
            final message = value.massage.split(':').first;
            Logger.print('error data:$data', error: true, level: 1);
            return Column(
              children: [
                if (data != null) ShowStatusEnvironmentWidget(data: data),
                if (data != null) const Divider(height: 10,),
                if (data != null) LastMessageDataTime(dateTime: data.dateTime),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CustomTextWidget(
                    message,
                    failureMessage: true,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
