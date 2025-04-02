import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter/locator.dart';
import 'package:gorouter/model/weather_model.dart';
import 'package:gorouter/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> with TickerProviderStateMixin {
  final WeatherService weatherService = getIt<WeatherService>();
  final TextEditingController cityController = TextEditingController();
  WeatherData? weatherData;
  bool isLoading = false;
  String errorMessage = '';

  // Animation controllers
  late AnimationController fadeController;
  late AnimationController slideController;
  late AnimationController scaleController;

  // Weather animation
  late AnimationController weatherAnimationController;
  String currentWeatherAnimation = 'assets/animations/sunny.json';

  @override
  void initState() {
    super.initState();

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    weatherAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Start animations
    SchedulerBinding.instance.addPostFrameCallback((_) {
      fadeController.forward();
      slideController.forward(from: 0.0);
      scaleController.forward(from: 0.0);
    });

    loadDefaultWeather();
  }

  Future<void> loadDefaultWeather() async {
    await fetchWeatherByLocation(6.927079, 79.861244);
  }

  Future<void> fetchWeather(String city) async {
    if (city.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final weather = await weatherService.getWeather(city);
      updateWeatherAnimation(weather);
      setState(() => weatherData = weather);
      playSuccessAnimation();
    } catch (e) {
      setState(() => errorMessage = e.toString());
      playErrorAnimation();
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchWeatherByLocation(double lat, double lon) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final weather = await weatherService.getWeatherByLocation(lat, lon);
      updateWeatherAnimation(weather);
      setState(() {
        weatherData = weather;
        cityController.text = weather.name;
      });
      playSuccessAnimation();
    } catch (e) {
      setState(() => errorMessage = e.toString());
      playErrorAnimation();
    } finally {
      setState(() => isLoading = false);
    }
  }

  void updateWeatherAnimation(WeatherData weather) {
    final mainWeather =
        weather.weather.isNotEmpty ? weather.weather[0].main.toLowerCase() : '';

    if (mainWeather.contains('rain')) {
      currentWeatherAnimation = 'assets/animations/rain.json';
    } else if (mainWeather.contains('cloud')) {
      currentWeatherAnimation = 'assets/animations/cloudy.json';
    } else if (mainWeather.contains('snow')) {
      currentWeatherAnimation = 'assets/animations/snow.json';
    } else if (mainWeather.contains('thunder') ||
        mainWeather.contains('storm')) {
      currentWeatherAnimation = 'assets/animations/thunder.json';
    } else {
      currentWeatherAnimation = 'assets/animations/sunny.json';
    }

    weatherAnimationController.reset();
    weatherAnimationController.forward();
  }

  void playSuccessAnimation() {
    scaleController.reset();
    scaleController.forward();
  }

  void playErrorAnimation() {
    slideController.reset();
    slideController.forward(from: 0.0);
  }

  @override
  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    scaleController.dispose();
    weatherAnimationController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: fadeController,
          builder: (context, child) {
            return Opacity(
              opacity: fadeController.value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - fadeController.value)),
                child: const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 22,
                  ),
                ),
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          FadeTransition(
            opacity: fadeController,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.5, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: fadeController, curve: Curves.easeOut),
              ),
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) {
                      context.go('/login');
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logout failed: ${e.toString()}'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ),
          FadeTransition(
            opacity: fadeController,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.5, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: fadeController, curve: Curves.easeOut),
              ),
              child: IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.black87),
                onPressed: () => GoRouter.of(context).go('/profile'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildWeatherContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: slideController, curve: Curves.easeOutQuart),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextField(
          controller: cityController,
          decoration: InputDecoration(
            hintText: 'Search for a city...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            suffixIcon:
                cityController.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[500]),
                      onPressed: () {
                        cityController.clear();
                        setState(() {});
                      },
                    )
                    : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          style: const TextStyle(fontSize: 16),
          onSubmitted: (value) => fetchWeather(value),
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    if (isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Fetching weather data...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: slideController, curve: Curves.elasticOut),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red[100]!),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[400]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red[700]),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20, color: Colors.red[400]),
                onPressed: () => setState(() => errorMessage = ''),
              ),
            ],
          ),
        ),
      );
    }

    if (weatherData == null) {
      return FadeTransition(
        opacity: fadeController,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Lottie.asset(
              'assets/animations/world-location.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Search for a city to see weather',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: scaleController, curve: Curves.easeOutBack),
      ),
      child: buildWeatherCard(),
    );
  }

  Widget buildWeatherCard() {
    final weather = weatherData!;
    final mainWeather = weather.weather.isNotEmpty ? weather.weather[0] : null;
    final date = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getCardGradient(weather),
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => fetchWeather(weather.name),
                ),
              ],
            ),

            if (mainWeather != null) ...[
              const SizedBox(height: 8),
              Text(
                mainWeather.main,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                mainWeather.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],

            const SizedBox(height: 16),
            Column(
              children: [
                SizedBox(
                  height: 120,
                  child: Lottie.asset(
                    currentWeatherAnimation,
                    width: 200,

                    controller: weatherAnimationController,
                    onLoaded: (composition) {
                      weatherAnimationController
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${weather.temperature.current.toStringAsFixed(1)}°',

                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherInfoItem(
                        '${weather.minTemperature.toStringAsFixed(1)}°',
                        'Min',
                        Icons.arrow_downward,
                      ),
                      _buildWeatherInfoItem(
                        '${weather.maxTemperature.toStringAsFixed(1)}°',
                        'Max',
                        Icons.arrow_upward,
                      ),
                      _buildWeatherInfoItem(
                        '${weather.humidity}%',
                        'Humidity',
                        Icons.water_drop,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherInfoItem(
                        '${weather.wind.speed} m/s',
                        'Wind',
                        Icons.air,
                      ),
                      _buildWeatherInfoItem(
                        '${weather.pressure} hPa',
                        'Pressure',
                        Icons.speed,
                      ),
                      // _buildWeatherInfoItem(
                      //   '${weather.clouds}%',
                      //   'Clouds',
                      //   Icons.cloud,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getCardGradient(WeatherData weather) {
    final mainWeather =
        weather.weather.isNotEmpty ? weather.weather[0].main.toLowerCase() : '';

    if (mainWeather.contains('rain')) {
      return [const Color(0xFF4B79CF), const Color(0xFF283E51)];
    } else if (mainWeather.contains('cloud')) {
      return [const Color(0xFFB7B8B6), const Color(0xFF676767)];
    } else if (mainWeather.contains('snow')) {
      return [const Color(0xFFE0EAFC), const Color(0xFFCFDEF3)];
    } else if (mainWeather.contains('thunder') ||
        mainWeather.contains('storm')) {
      return [const Color(0xFF0F2027), const Color(0xFF203A43)];
    } else if (mainWeather.contains('clear')) {
      return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
    } else if (weather.temperature.current > 30) {
      return [const Color(0xFFFF416C), const Color(0xFFFF4B2B)];
    } else {
      return [const Color(0xFF00B4DB), const Color(0xFF0083B0)];
    }
  }

  Widget _buildWeatherInfoItem(String value, String label, IconData icon) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: scaleController,
          curve: Interval(
            0.2 + _getIndexForIcon(icon) * 0.2,
            1.0,
            curve: Curves.easeOutBack,
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  double _getIndexForIcon(IconData icon) {
    switch (icon) {
      case Icons.arrow_downward:
        return 0;
      case Icons.arrow_upward:
        return 1;
      case Icons.water_drop:
        return 2;
      case Icons.air:
        return 3;
      case Icons.speed:
        return 4;
      case Icons.cloud:
        return 5;
      default:
        return 0;
    }
  }
}
