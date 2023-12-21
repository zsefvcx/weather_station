import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';

class StackDataEnvironmentalConditions extends CustomStack<EnvironmentalConditions> {

  Stream<EnvironmentalConditions?> streamEC;
  StackDataEnvironmentalConditions(this.streamEC, {
    super.maxCount = Constants.maxCountStackEC
  });

  @override
  void add(EnvironmentalConditions value) {
    try{
      super.add(value);
    } on Exception catch(e,t) {
      Logger.print('Error add StackDataEnvironmentalConditions with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
    }
  }

  void get listen {
    try{
      streamEC.listen((event) {
        try{
          if(event != null){
            add(event);
            Logger.print('length StackDataEnvironmentalConditions: $length');
          }
        } on Exception catch(e,t) {
          Logger.print('Error StackDataEnvironmentalConditions.listen with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
        }
      },
        onDone: () => Logger.print('stream StackDataEnvironmentalConditions.onDone'),
        onError: (e, t) => Logger.print('Error stream StackDataEnvironmentalConditions.onError with:\n$e\n$t', error: true, name: 'err', safeToDisk: true),
      );
    } on Exception catch(e,t) {
      Logger.print('Error add StackDataEnvironmentalConditions.stream with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
    }
  }

}
