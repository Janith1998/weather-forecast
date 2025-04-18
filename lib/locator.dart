import 'package:get_it/get_it.dart';
import 'package:gorouter/auth/controller/auth_service.dart';

import 'package:gorouter/app/controller/theme_service.dart';
import 'package:gorouter/auth/controller/email_service.dart';
import 'package:gorouter/home/controller/weather_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<WeatherService>(() => WeatherService());
  getIt.registerSingleton<ThemeService>(ThemeService());
  getIt.registerLazySingleton<EmailService>(() => EmailService());
}
