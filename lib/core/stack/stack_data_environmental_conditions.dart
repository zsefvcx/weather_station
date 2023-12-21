import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';

class StackDataEnvironmentalConditions extends CustomStack<EnvironmentalConditions> {

  StackDataEnvironmentalConditions({
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

}
