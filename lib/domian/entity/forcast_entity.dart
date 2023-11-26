import 'dart:convert';

ForecastModel forecastModelFromJson(String str) => ForecastModel.fromJson(json.decode(str));

String forecastModelToJson(ForecastModel data) => json.encode(data.toJson());

class ForecastModel {
  final List<Daily> daily;

  ForecastModel({
    required this.daily,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) => ForecastModel(
    daily: List<Daily>.from(json["daily"].map((x) => Daily.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "daily": List<dynamic>.from(daily.map((x) => x.toJson())),
  };
}

class Daily {
  final String summary;
  final Temp temp;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double windSpeed;
  final int windDeg;
  final double windGust;
  final List<Weather> weather;

  Daily({
    required this.summary,
    required this.temp,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.weather,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
    summary: json["summary"],
    temp: Temp.fromJson(json["temp"]),
    pressure: json["pressure"],
    humidity: json["humidity"],
    dewPoint: json["dew_point"]?.toDouble(),
    windSpeed: json["wind_speed"]?.toDouble(),
    windDeg: json["wind_deg"],
    windGust: json["wind_gust"]?.toDouble(),
    weather: List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "summary": summary,
    "temp": temp.toJson(),
    "pressure": pressure,
    "humidity": humidity,
    "dew_point": dewPoint,
    "wind_speed": windSpeed,
    "wind_deg": windDeg,
    "wind_gust": windGust,
    "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
  };
}

class Temp {
  final int day;
  final int min;
  final double max;

  Temp({
    required this.day,
    required this.min,
    required this.max,
  });

  factory Temp.fromJson(Map<String, dynamic> json) => Temp(
    day: json["day"],
    min: json["min"],
    max: json["max"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "min": min,
    "max": max,
  };
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    id: json["id"],
    main: json["main"],
    description: json["description"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "main": main,
    "description": description,
    "icon": icon,
  };
}
