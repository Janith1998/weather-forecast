// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:gorouter/model/weather_model.dart';

// class WeatherService {
//   static const String apiKey = "2f628f57f1cd8a6b999fa894736207bb";
//   static const String baseUrl = "https://api.openweathermap.org/data/2.5";

//   Future<WeatherData> getWeather(String cityName) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric'),
//     );

//     if (response.statusCode == 200) {
//       return WeatherData.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load weather: ${response.statusCode}');
//     }
//   }

//   Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
//     final response = await http.get(
//       Uri.parse(
//         '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
//       ),
//     );

//     if (response.statusCode == 200) {
//       return WeatherData.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load weather: ${response.statusCode}');
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:gorouter/model/weather_model.dart';

class WeatherService {
  static const String apiKey = "2f628f57f1cd8a6b999fa894736207bb";
  static const String baseUrl = "https://api.openweathermap.org/data/2.5";

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<WeatherData> getWeather(String cityName) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric'},
      );
      return WeatherData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load weather: ${e.message}');
    }
  }

  Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
        },
      );
      return WeatherData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load weather: ${e.message}');
    }
  }
}
