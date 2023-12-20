import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';

class StackDataEnvironmentalConditions extends CustomStack<EnvironmentalConditions>{

  num? _temperature;
  num? _humidity;
  num? _pressure;
  num? _temperature2;
  num? _humidity2;
  num? _pressure2;

  StackDataEnvironmentalConditions({super.maxCount = Constants.maxCountStackEC});

  @override
  void add(EnvironmentalConditions value) {
    final temperature = _temperature;
    final vTemperature = value.temperature;
    // if(vTemperature !=null && temperature != null && (temperature-vTemperature).abs){
    //
    // }




    super.add(value);
  }

}
