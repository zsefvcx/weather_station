
import 'dart:math';

import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';

class StackChartDataValue extends CustomStack<ChartDataValue>{

  num? _minYT;
  num? get minYT {
    final minYT = _minYT;
    return minYT!=null?minYT-5:null;
  }

  num? _maxYT;
  num? get maxYT {
    final maxYT = _maxYT;
    return maxYT!=null?maxYT+5:null;
  }

  num? get intervalYT {
    final maxYT = _maxYT;
    final minYT = _minYT;
    if(maxYT != null && minYT != null){
      return (maxYT+5 - minYT+5)~/10;
    }
    return null;
  }

  void _valMinMaxYT(ChartDataValue value){
    var minYT = _minYT;
    var maxYT = _maxYT;
    final t1 = value.t1;
    final t2 = value.t2;
    final t3 = value.t3;
    if(t1!=null){
      minYT = minYT!=null?min(minYT, t1):t1;
      maxYT = maxYT!=null?max(maxYT, t1):t1;
    }
    if(t2!=null){
      minYT = minYT!=null?min(minYT, t2):t2;
      maxYT = maxYT!=null?max(maxYT, t2):t2;
    }
    if(t3!=null){
      minYT = minYT!=null?min(minYT, t3):t3;
      maxYT = maxYT!=null?max(maxYT, t3):t3;
    }
    _maxYT = maxYT;
    _minYT = minYT;
    Logger.print('maxYT=$maxYT minYT=$minYT');
  }

  num? _minYH;
  num? get minYH {
    final minYH = _minYH;
    return minYH!=null?(minYH-5)<=0?0:minYH-5:null;
  }

  num? _maxYH;
  num? get maxYH {
    final maxYH = _maxYH;
    return maxYH!=null?(maxYH+5)>=100?100:maxYH+5:null;
  }

  num? get intervalYH {
    final maxYH = _maxYH;
    final minYH = _minYH;
    if(maxYH != null && minYH != null){
      return (maxYH+5 - minYH+5)~/10;
    }
    return null;
  }

  void _valMinMaxYH(ChartDataValue value){
    var minYH = _minYH;
    var maxYH = _maxYH;
    final h1 = value.h1;
    final h2 = value.h2;
    final h3 = value.h3;
    if(h1!=null){
      minYH = minYH!=null?min(minYH, h1):h1;
      maxYH = maxYH!=null?max(maxYH, h1):h1;
    }
    if(h2!=null){
      minYH = minYH!=null?min(minYH, h2):h2;
      maxYH = maxYH!=null?max(maxYH, h2):h2;
    }
    if(h3!=null){
      minYH = minYH!=null?min(minYH, h3):h3;
      maxYH = maxYH!=null?max(maxYH, h3):h3;
    }
    _maxYH = maxYH;
    _minYH = minYH;
    Logger.print('maxYH=$maxYH minYH=$minYH');
  }

  num? _minYP;
  num? get minYP {
    final minYP = _minYP;
    return minYP!=null?minYP-5:null;
  }

  num? _maxYP;
  num? get maxYP {
    final maxYP = _maxYP;
    return maxYP!=null?maxYP+5:null;
  }

  num? get intervalYP {
    final maxYP = _maxYP;
    final minYP = _minYP;
    if(maxYP != null && minYP != null){
      return (maxYP+5 - minYP+5)~/10;
    }
    return null;
  }

  void _valMinMaxYP(ChartDataValue value){
    var minYP = _minYP;
    var maxYP = _maxYP;
    final p1 = value.p1;
    final p2 = value.p2;
    final p3 = value.p3;
    if(p1!=null){
      minYP = minYP!=null?min(minYP, p1):p1;
      maxYP = maxYP!=null?max(maxYP, p1):p1;
    }
    if(p2!=null){
      minYP = minYP!=null?min(minYP, p2):p2;
      maxYP = maxYP!=null?max(maxYP, p2):p2;
    }
    if(p3!=null){
      minYP = minYP!=null?min(minYP, p3):p3;
      maxYP = maxYP!=null?max(maxYP, p3):p3;
    }
    _maxYP = maxYP;
    _minYP = minYP;
    Logger.print('maxYP=$maxYP minYP=$minYP');
  }

  num? _minX;
  num? get minX {
    final minX = _minX;
    return minX!=null?minX-30:null;
  }

  num? _maxX;
  num? get maxX {
    final maxX = _maxX;
    return maxX!=null?maxX+30:null;
  }

  num? get intervalX {
    final maxX = _maxX;
    final minX = _minX;
    if(maxX != null && minX != null){
      return (maxX+30 - minX+30)~/5;
    }
    return null;
  }

  void _valMinMaxX(ChartDataValue value){
    var minX = _minX;
    var maxX = _maxX;
    final time= value.time;
    if(super.isEmpty){
      minX = time.second + time.minute*60 + time.hour*60*60;
      maxX = minX;
    } else {
      maxX = time.second + time.minute*60 + time.hour*60*60;
    }
    _maxX = maxX;
    _minX = minX;
    Logger.print('maxX=$maxX minX=$minX');
  }

  Stream<WeatherData?> streamWD;
  StackChartDataValue(this.streamWD, {super.maxCount = Constants.maxCountStack});

  void get listen {
    try{
      streamWD.listen((event) {
        try{
          if(event != null){
            add(ChartDataValue.fromWeatherDate(event));
            Logger.print('length StackChartDataValue: $length');
          }
        } on Exception catch(e,t) {
          Logger.print('Error add StackChartDataValue.streamWD.listen from WeatherData with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
        }
      },
        onDone: () => Logger.print('stream StackChartDataValue.onDone from WeatherData'),
        onError: (e, t) => Logger.print('Error StackChartDataValue.onError from WeatherData with:\n$e\n$t', error: true, name: 'err', safeToDisk: true),
      );
    } on Exception catch(e,t) {
      Logger.print("Error add StackChartDataValue.stream's with:\n$e\n$t", error: true, name: 'err', safeToDisk: true);
    }
  }


  @override
  void add(ChartDataValue value) {
    try {
      _valMinMaxYT(value);
      _valMinMaxYH(value);
      _valMinMaxYP(value);
      _valMinMaxX(value);
      super.add(value);
    } on Exception catch(e,t) {
      Logger.print('Error add StackChartDataValue with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
    }
  }
}
