
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';

class StackDataOpenWeather  extends CustomStack<WeatherData>{

  Stream<WeatherData?> stream;

  StackDataOpenWeather(this.stream, {super.maxCount = Constants.maxCountStackWD});

  void get listen {
    try{
      stream.listen((event) {
        try{
          if(event != null){
            add(event);
            Logger.print('length StackDataOpenWeather: $length');
          }
        } on Exception catch(e,t) {
          Logger.print('Error StackDataOpenWeather.listen with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
        }
      },
      onDone: () => Logger.print('stream StackDataOpenWeather.onDone'),
      onError: (e, t) => Logger.print('Error StackDataOpenWeather.onError with:\n$e\n$t', error: true, name: 'err', safeToDisk: true),
      );
    } on Exception catch(e,t) {
      Logger.print('Error add StackDataOpenWeather.stream with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
    }
  }

}
