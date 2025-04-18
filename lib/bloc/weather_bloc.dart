import 'package:rxdart/rxdart.dart';
import 'package:gorouter/model/weather_model.dart';
import 'package:gorouter/services/weather_service.dart';

class WeatherBloc {
  final WeatherService _weatherService;

  // Private subjects
  final _weatherSubject = BehaviorSubject<WeatherData?>();
  final _loadingSubject = BehaviorSubject<bool>.seeded(false);
  final _errorSubject = BehaviorSubject<String>();
  final _citySubject = BehaviorSubject<String>();

  WeatherBloc({WeatherService? weatherService})
    : _weatherService = weatherService ?? WeatherService() {
    // Combine latest city and location changes
    _setupReactiveStreams();
  }

  void _setupReactiveStreams() {
    // You can add more reactive combinations here if needed
  }

  // Stream getters
  Stream<WeatherData?> get weatherStream => _weatherSubject.stream;
  Stream<bool> get loadingStream => _loadingSubject.stream;
  Stream<String> get errorStream => _errorSubject.stream;
  Stream<String> get cityStream => _citySubject.stream;

  // Public methods
  Future<void> fetchWeather(String cityName) async {
    if (cityName.isEmpty) return;

    _loadingSubject.add(true);
    _errorSubject.add('');
    _citySubject.add(cityName);

    try {
      final weather = await _weatherService.getWeather(cityName);
      _weatherSubject.add(weather);
    } catch (e) {
      _errorSubject.add(e.toString());
      _weatherSubject.addError(e);
    } finally {
      _loadingSubject.add(false);
    }
  }

  Future<void> fetchWeatherByLocation(double lat, double lon) async {
    _loadingSubject.add(true);
    _errorSubject.add('');

    try {
      final weather = await _weatherService.getWeatherByLocation(lat, lon);
      _weatherSubject.add(weather);
      if (weather.name.isNotEmpty) {
        _citySubject.add(weather.name);
      }
    } catch (e) {
      _errorSubject.add(e.toString());
      _weatherSubject.addError(e);
    } finally {
      _loadingSubject.add(false);
    }
  }

  void clearError() {
    _errorSubject.add('');
  }

  void dispose() {
    _weatherSubject.close();
    _loadingSubject.close();
    _errorSubject.close();
    _citySubject.close();
  }
}
