import 'package:get_it/get_it.dart';
import 'package:gorouter/services/weather_state.dart';
import 'package:gorouter/services/auth_service.dart';
import 'package:gorouter/services/theme_service.dart';
import 'package:gorouter/services/weather_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<WeatherService>(() => WeatherService());
  getIt.registerSingleton<ThemeService>(ThemeService());
  getIt.registerFactory<WeatherState>(() => WeatherState());
}
