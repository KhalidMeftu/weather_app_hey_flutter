import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {
  final Coord coord;
  final List<WeatherElement> weather;
  final String base;
  final Main main;
  final int visibility;
  final Wind wind;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  Weather({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    coord: Coord.fromJson(json["coord"]),
    weather: List<WeatherElement>.from(json["weather"].map((x) => WeatherElement.fromJson(x))),
    base: json["base"],
    main: Main.fromJson(json["main"]),
    visibility: json["visibility"],
    wind: Wind.fromJson(json["wind"]),
    clouds: Clouds.fromJson(json["clouds"]),
    dt: json["dt"],
    sys: Sys.fromJson(json["sys"]),
    timezone: json["timezone"],
    id: json["id"],
    name: json["name"],
    cod: json["cod"],
  );

  Map<String, dynamic> toJson() => {
    "coord": coord.toJson(),
    "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
    "base": base,
    "main": main.toJson(),
    "visibility": visibility,
    "wind": wind.toJson(),
    "clouds": clouds.toJson(),
    "dt": dt,
    "sys": sys.toJson(),
    "timezone": timezone,
    "id": id,
    "name": name,
    "cod": cod,
  };
}

class Clouds {
  final int all;

  Clouds({
    required this.all,
  });

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
    all: json["all"],
  );

  Map<String, dynamic> toJson() => {
    "all": all,
  };
}

class Coord {
  final double lon;
  final double lat;

  Coord({
    required this.lon,
    required this.lat,
  });

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
    lon: json["lon"]?.toDouble(),
    lat: json["lat"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lon": lon,
    "lat": lat,
  };
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
    temp: json["temp"]?.toDouble(),
    feelsLike: json["feels_like"]?.toDouble(),
    tempMin: json["temp_min"]?.toDouble(),
    tempMax: json["temp_max"]?.toDouble(),
    pressure: json["pressure"],
    humidity: json["humidity"],
  );

  Map<String, dynamic> toJson() => {
    "temp": temp,
    "feels_like": feelsLike,
    "temp_min": tempMin,
    "temp_max": tempMax,
    "pressure": pressure,
    "humidity": humidity,
  };
}

class Sys {
  final int type;
  final int id;
  final String country;
  final int sunrise;
  final int sunset;

  Sys({
    required this.type,
    required this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic> json) => Sys(
    type: json["type"],
    id: json["id"],
    country: json["country"],
    sunrise: json["sunrise"],
    sunset: json["sunset"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "country": country,
    "sunrise": sunrise,
    "sunset": sunset,
  };
}

class WeatherElement {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherElement({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherElement.fromJson(Map<String, dynamic> json) => WeatherElement(
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

class Wind {
  final double speed;
  final int deg;

  Wind({
    required this.speed,
    required this.deg,
  });

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
    speed: json["speed"]?.toDouble(),
    deg: json["deg"],
  );

  Map<String, dynamic> toJson() => {
    "speed": speed,
    "deg": deg,
  };
}
