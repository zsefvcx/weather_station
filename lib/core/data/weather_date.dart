
import 'package:flutter/cupertino.dart';

@immutable
class WeatherDate{
  final Coord? coord;
  final List<Weather>? weather;
  final String? base;
  final MainStatus? mainStatus;
  final int? visibility;
  final Wind? wind;
  final Clouds? clouds;
  final int? dt;
  final Sys? sys;
  final int? timezone;
  final int? id;
  final String? name;
  final int? cod;

  const WeatherDate({
    this.coord,
    this.weather,
    this.base,
    this.mainStatus,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherDate &&
          runtimeType == other.runtimeType &&
          coord == other.coord &&
          weather == other.weather &&
          base == other.base &&
          mainStatus == other.mainStatus &&
          visibility == other.visibility &&
          wind == other.wind &&
          clouds == other.clouds &&
          dt == other.dt &&
          sys == other.sys &&
          timezone == other.timezone &&
          id == other.id &&
          name == other.name &&
          cod == other.cod);

  @override
  int get hashCode =>
      coord.hashCode ^
      weather.hashCode ^
      base.hashCode ^
      mainStatus.hashCode ^
      visibility.hashCode ^
      wind.hashCode ^
      clouds.hashCode ^
      dt.hashCode ^
      sys.hashCode ^
      timezone.hashCode ^
      id.hashCode ^
      name.hashCode ^
      cod.hashCode;

  @override
  String toString() {
    return 'WeatherDate{ '
        'coord: $coord, '
        'weather: $weather, '
        'base: $base, '
        'mainStatus: $mainStatus, '
        'visibility: $visibility, '
        'wind: $wind, '
        'clouds: $clouds, '
        'dt: $dt, sys: $sys, '
        'timezone: $timezone, '
        'id: $id, '
        'name: $name, '
        'cod: $cod,}';
  }

  WeatherDate copyWith({
    Coord? coord,
    List<Weather>? weather,
    String? base,
    MainStatus? mainStatus,
    int? visibility,
    Wind? wind,
    Clouds? clouds,
    int? dt,
    Sys? sys,
    int? timezone,
    int? id,
    String? name,
    int? cod,
  }) {
    return WeatherDate(
      coord: coord ?? this.coord,
      weather: weather ?? this.weather,
      base: base ?? this.base,
      mainStatus: mainStatus ?? this.mainStatus,
      visibility: visibility ?? this.visibility,
      wind: wind ?? this.wind,
      clouds: clouds ?? this.clouds,
      dt: dt ?? this.dt,
      sys: sys ?? this.sys,
      timezone: timezone ?? this.timezone,
      id: id ?? this.id,
      name: name ?? this.name,
      cod: cod ?? this.cod,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coord': coord?.toJson(),
      'weather': weather?.map((v) => v.toJson()).toList(),
      'base': base,
      'mainStatus': mainStatus?.toJson(),
      'visibility': visibility,
      'wind': wind?.toJson(),
      'clouds': clouds?.toJson(),
      'dt': dt,
      'sys': sys?.toJson(),
      'timezone': timezone,
      'id': id,
      'name': name,
      'cod': cod,
    };
  }

  factory WeatherDate.fromJson(Map<String, dynamic> map) {
    return WeatherDate(
      coord: map['coord']!=null
          ?Coord.fromJson(map['coord'] as Map<String, dynamic>)
          :null,
      weather: map['weather']!=null
          ?<Weather>[
            ...(map['weather'] as List<dynamic>).map(
              (e) => Weather.fromJson(e as Map<String, dynamic>))
          ]
          :null,
      base: map['base'] as String?,
      mainStatus: map['main']!=null
          ?MainStatus.fromJson(map['main'] as Map<String, dynamic>)
          :null,
      visibility: map['visibility'] as int?,
      wind: map['wind']!= null
          ?Wind.fromJson(map['wind'] as Map<String, dynamic>)
          :null,
      clouds: map['clouds']!=null
          ?Clouds.fromJson(map['clouds'] as Map<String, dynamic>)
          :null,
      dt: map['dt'] as int?,
      sys: map['sys']!=null
          ?Sys.fromJson(map['sys'] as Map<String, dynamic>)
          :null,
      timezone: map['timezone'] as int?,
      id: map['id'] as int?,
      name: map['name'] as String?,
      cod: map['cod'] as int?,
    );
  }
}

@immutable
class Coord {
  final double? lon;
  final double? lat;

  const Coord({
    this.lon,
    this.lat,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Coord &&
          runtimeType == other.runtimeType &&
          lon == other.lon &&
          lat == other.lat);

  @override
  int get hashCode => lon.hashCode ^ lat.hashCode;

  @override
  String toString() {
    return 'Coord{ lon: $lon, lat: $lat,}';
  }

  Coord copyWith({
    double? lon,
    double? lat,
  }) {
    return Coord(
      lon: lon ?? this.lon,
      lat: lat ?? this.lat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lon': lon,
      'lat': lat,
    };
  }

  factory Coord.fromJson(Map<String, dynamic> map) {
    return Coord(
      lon: map['lon'] as double?,
      lat: map['lat'] as double?,
    );
  }

}

@immutable
class Weather {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  const Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Weather &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          main == other.main &&
          description == other.description &&
          icon == other.icon);

  @override
  int get hashCode =>
      id.hashCode ^ main.hashCode ^ description.hashCode ^ icon.hashCode;

  @override
  String toString() {
    return 'Weather{ '
        'id: $id, '
        'main: $main, '
        'description: $description, '
        'icon: $icon,}';
  }

  Weather copyWith({
    int? id,
    String? main,
    String? description,
    String? icon,
  }) {
    return Weather(
      id: id ?? this.id,
      main: main ?? this.main,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mainStatus': main,
      'description': description,
      'icon': icon,
    };
  }

  factory Weather.fromJson(Map<String, dynamic> map) {
    return Weather(
      id: map['id'] as int?,
      main: map['main'] as String?,
      description: map['description'] as String?,
      icon: map['icon'] as String?,
    );
  }
}

@immutable
class MainStatus{
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? grndLevel;

  const MainStatus({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MainStatus &&
          runtimeType == other.runtimeType &&
          temp == other.temp &&
          feelsLike == other.feelsLike &&
          tempMin == other.tempMin &&
          tempMax == other.tempMax &&
          pressure == other.pressure &&
          humidity == other.humidity &&
          seaLevel == other.seaLevel &&
          grndLevel == other.grndLevel);

  @override
  int get hashCode =>
      temp.hashCode ^
      feelsLike.hashCode ^
      tempMin.hashCode ^
      tempMax.hashCode ^
      pressure.hashCode ^
      humidity.hashCode ^
      seaLevel.hashCode ^
      grndLevel.hashCode;

  @override
  String toString() {
    return 'MainStatus{ '
        'temp: $temp, '
        'feels_like: $feelsLike, '
        'temp_min: $tempMin, '
        'temp_max: $tempMax, '
        'pressure: $pressure, '
        'humidity: $humidity, '
        'sea_level: $seaLevel, '
        'grnd_level: $grndLevel,}';
  }

  MainStatus copyWith({
    double? temp,
    double? feelsLike,
    double? tempMin,
    double? tempMax,
    int? pressure,
    int? humidity,
    int? seaLevel,
    int? grndLevel,
  }) {
    return MainStatus(
      temp: temp ?? this.temp,
      feelsLike: feelsLike ?? this.feelsLike,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      pressure: pressure ?? this.pressure,
      humidity: humidity ?? this.humidity,
      seaLevel: seaLevel ?? this.seaLevel,
      grndLevel: grndLevel ?? this.grndLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'feelsLike': feelsLike,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'pressure': pressure,
      'humidity': humidity,
      'seaLevel': seaLevel,
      'grndLevel': grndLevel,
    };
  }

  factory MainStatus.fromJson(Map<String, dynamic> map) {
    return MainStatus(
      temp: map['temp'] as double?,
      feelsLike: map['feels_like'] as double?,
      tempMin: map['temp_min'] as double?,
      tempMax: map['temp_max'] as double?,
      pressure: map['pressure'] as int?,
      humidity: map['humidity'] as int?,
      seaLevel: map['sea_level'] as int?,
      grndLevel: map['grnd_level'] as int?,
    );
  }
}

@immutable
class Wind {
  final double? speed;
  final int? deg;
  final double? gust;

  const Wind({
    this.speed,
    this.deg,
    this.gust,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Wind &&
          runtimeType == other.runtimeType &&
          speed == other.speed &&
          deg == other.deg &&
          gust == other.gust);

  @override
  int get hashCode => speed.hashCode ^ deg.hashCode ^ gust.hashCode;

  @override
  String toString() {
    return 'Wind{ speed: $speed, deg: $deg, gust: $gust,}';
  }

  Wind copyWith({
    double? speed,
    int? deg,
    double? gust,
  }) {
    return Wind(
      speed: speed ?? this.speed,
      deg: deg ?? this.deg,
      gust: gust ?? this.gust,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'deg': deg,
      'gust': gust,
    };
  }

  factory Wind.fromJson(Map<String, dynamic> map) {
    return Wind(
      speed: map['speed'] as double?,
      deg: map['deg'] as int?,
      gust: map['gust'] as double?,
    );
  }

}

@immutable
class Clouds {
  final int? all;

  const Clouds({
    this.all,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Clouds && runtimeType == other.runtimeType && all == other.all);

  @override
  int get hashCode => all.hashCode;

  @override
  String toString() {
    return 'Clouds{ all: $all,}';
  }

  Clouds copyWith({
    int? all,
  }) {
    return Clouds(
      all: all ?? this.all,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'all': all,
    };
  }

  factory Clouds.fromJson(Map<String, dynamic> map) {
    return Clouds(
      all: map['all'] as int?,
    );
  }

}

@immutable
class Sys {
  final String? country;
  final int? sunrise;
  final int? sunset;

  const Sys({
    this.country,
    this.sunrise,
    this.sunset,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sys &&
          runtimeType == other.runtimeType &&
          country == other.country &&
          sunrise == other.sunrise &&
          sunset == other.sunset);

  @override
  int get hashCode => country.hashCode ^ sunrise.hashCode ^ sunset.hashCode;

  @override
  String toString() {
    return 'Sys{ country: $country, sunrise: $sunrise, sunset: $sunset,}';
  }

  Sys copyWith({
    String? country,
    int? sunrise,
    int? sunset,
  }) {
    return Sys(
      country: country ?? this.country,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }

  factory Sys.fromJson(Map<String, dynamic> map) {
    return Sys(
      country: map['country'] as String?,
      sunrise: map['sunrise'] as int?,
      sunset: map['sunset'] as int?,
    );
  }
}
