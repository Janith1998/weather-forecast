class WeatherData {
  final String name;
  final Temperature temperature;
  final int humidity;
  final Wind wind;
  final double maxTemperature;
  final double minTemperature;
  final int pressure;
  final List<WeatherInfo> weather;

  WeatherData({
    required this.name,
    required this.temperature,
    required this.humidity,
    required this.wind,
    required this.maxTemperature,
    required this.minTemperature,
    required this.pressure,
    required this.weather,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      name: json['name'],
      temperature: Temperature.fromJson(json['main']['temp']),
      humidity: json['main']['humidity'],
      wind: Wind.fromJson(json['wind']),
      maxTemperature: json['main']['temp_max'].toDouble(),
      minTemperature: json['main']['temp_min'].toDouble(),
      pressure: json['main']['pressure'],
      weather: List<WeatherInfo>.from(
        json['weather'].map((weather) => WeatherInfo.fromJson(weather)),
      ),
    );
  }
}

class WeatherInfo {
  final String main;
  final String description;
  final String icon;

  WeatherInfo({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class Temperature {
  final double current;

  Temperature({required this.current});

  factory Temperature.fromJson(dynamic json) {
    return Temperature(current: json.toDouble());
  }
}

class Wind {
  final double speed;
  final int deg;

  Wind({required this.speed, required this.deg});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(speed: json['speed'].toDouble(), deg: json['deg']);
  }
}
