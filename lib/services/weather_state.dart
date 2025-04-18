// lib/services/weather_state.dart
import 'package:rxdart/rxdart.dart';
import 'package:gorouter/model/weather_model.dart';
import 'package:gorouter/services/weather_service.dart';

class WeatherState {
  final WeatherService weatherService;

  // Private subjects
  final weatherSubject = BehaviorSubject<WeatherData?>();
  final loadingSubject = BehaviorSubject<bool>.seeded(false);
  final errorSubject = BehaviorSubject<String>.seeded('');
  final citySubject = BehaviorSubject<String>.seeded('');

  // Public streams
  Stream<WeatherData?> get weather$ => weatherSubject.stream;
  Stream<bool> get loading$ => loadingSubject.stream;
  Stream<String> get error$ => errorSubject.stream;
  Stream<String> get city$ => citySubject.stream;

  // Current values
  WeatherData? get weather => weatherSubject.valueOrNull;
  bool get isLoading => loadingSubject.value;
  String get error => errorSubject.value;
  String get city => citySubject.value;

  WeatherState({WeatherService? weatherService})
    : weatherService = weatherService ?? WeatherService();

  Future<void> fetchWeather(String cityName) async {
    if (cityName.isEmpty) return;

    loadingSubject.add(true);
    errorSubject.add('');
    citySubject.add(cityName);

    try {
      final weather = await weatherService.getWeather(cityName);
      weatherSubject.add(weather);
    } catch (e) {
      errorSubject.add(e.toString());
      weatherSubject.addError(e);
    } finally {
      loadingSubject.add(false);
    }
  }

  Future<void> fetchWeatherByLocation(double lat, double lon) async {
    loadingSubject.add(true);
    errorSubject.add('');

    try {
      final weather = await weatherService.getWeatherByLocation(lat, lon);
      weatherSubject.add(weather);
      if (weather.name.isNotEmpty) {
        citySubject.add(weather.name);
      }
    } catch (e) {
      errorSubject.add(e.toString());
      weatherSubject.addError(e);
    } finally {
      loadingSubject.add(false);
    }
  }

  void clearError() {
    errorSubject.add('');
  }

  void dispose() {
    weatherSubject.close();
    loadingSubject.close();
    errorSubject.close();
    citySubject.close();
  }
}
