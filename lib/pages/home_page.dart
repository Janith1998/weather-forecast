// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gorouter/locator.dart';
// import 'package:gorouter/model/weather_model.dart';
// import 'package:gorouter/services/weather_service.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => HomepageState();
// }

// class HomepageState extends State<Homepage> {
//   final WeatherService weatherService = getIt<WeatherService>();
//   final TextEditingController cityController = TextEditingController();
//   WeatherData? weatherData;
//   bool isLoading = false;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     loadDefaultWeather();
//   }

//   Future<void> loadDefaultWeather() async {
//     await fetchWeatherByLocation(6.927079, 79.861244);
//   }

//   Future<void> fetchWeather(String city) async {
//     if (city.isEmpty) return;

//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     try {
//       final weather = await weatherService.getWeather(city);
//       setState(() => weatherData = weather);
//     } catch (e) {
//       setState(() => errorMessage = e.toString());
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> fetchWeatherByLocation(double lat, double lon) async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     try {
//       final weather = await weatherService.getWeatherByLocation(lat, lon);
//       setState(() {
//         weatherData = weather;
//         cityController.text = weather.name;
//       });
//     } catch (e) {
//       setState(() => errorMessage = e.toString());
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     cityController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text('Weather Forecast'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             onPressed: () => GoRouter.of(context).go('/profile'),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildSearchBar(),
//             const SizedBox(height: 20),
//             _buildWeatherContent(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: cityController,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter city name',
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (value) => fetchWeather(value),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.search),
//               onPressed: () => fetchWeather(cityController.text),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeatherContent() {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (errorMessage.isNotEmpty) {
//       return Center(
//         child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
//       );
//     }

//     if (weatherData == null) {
//       return const Center(
//         child: Text(
//           'Search for a city to see weather',
//           style: TextStyle(fontSize: 18),
//         ),
//       );
//     }

//     return buildWeatherCard();
//   }

//   Widget buildWeatherCard() {
//     final weather = weatherData!;
//     final mainWeather = weather.weather.isNotEmpty ? weather.weather[0] : null;

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Text(
//               weather.name,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             if (mainWeather != null) ...[
//               Text(
//                 mainWeather.main,
//                 style: const TextStyle(fontSize: 18, color: Colors.blue),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 mainWeather.description,
//                 style: const TextStyle(fontSize: 14, color: Colors.grey),
//               ),
//             ],
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 buildWeatherInfo(
//                   '${weather.temperature.current.toStringAsFixed(1)}°C',
//                   'Current',
//                   Icons.thermostat,
//                 ),
//                 buildWeatherInfo(
//                   '${weather.minTemperature.toStringAsFixed(1)}°C',
//                   'Min',
//                   Icons.arrow_downward,
//                 ),
//                 buildWeatherInfo(
//                   '${weather.maxTemperature.toStringAsFixed(1)}°C',
//                   'Max',
//                   Icons.arrow_upward,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 buildWeatherInfo(
//                   '${weather.humidity}%',
//                   'Humidity',
//                   Icons.water_drop,
//                 ),
//                 buildWeatherInfo(
//                   '${weather.wind.speed} m/s',
//                   'Wind',
//                   Icons.air,
//                 ),
//                 buildWeatherInfo(
//                   '${weather.pressure} hPa',
//                   'Pressure',
//                   Icons.speed,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildWeatherInfo(String value, String label, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, size: 30, color: Colors.blue),
//         const SizedBox(height: 5),
//         Text(
//           value,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter/locator.dart';
import 'package:gorouter/model/weather_model.dart';
import 'package:gorouter/services/weather_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final WeatherService weatherService = getIt<WeatherService>();
  final TextEditingController cityController = TextEditingController();
  WeatherData? weatherData;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
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
      setState(() => weatherData = weather);
    } catch (e) {
      setState(() => errorMessage = e.toString());
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
      setState(() {
        weatherData = weather;
        cityController.text = weather.name;
      });
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Weather Forecast',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () => GoRouter.of(context).go('/profile'),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
    );
  }

  Widget _buildWeatherContent() {
    if (isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
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
          ],
        ),
      );
    }

    if (weatherData == null) {
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Image.asset(
            'assets/weather_placeholder.png', // Replace with your asset
            width: 150,
            height: 150,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            'Search for a city to see weather',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      );
    }

    return buildWeatherCard();
  }

  Widget buildWeatherCard() {
    final weather = weatherData!;
    final mainWeather = weather.weather.isNotEmpty ? weather.weather[0] : null;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[400]!, Colors.blue[600]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              weather.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            if (mainWeather != null) ...[
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
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
            const SizedBox(height: 30),
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
                      buildWeatherInfo(
                        '${weather.minTemperature.toStringAsFixed(1)}°',
                        'Min',
                        Icons.arrow_downward,
                      ),
                      buildWeatherInfo(
                        '${weather.maxTemperature.toStringAsFixed(1)}°',
                        'Max',
                        Icons.arrow_upward,
                      ),
                      buildWeatherInfo(
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
                      buildWeatherInfo(
                        '${weather.wind.speed} m/s',
                        'Wind',
                        Icons.air,
                      ),
                      buildWeatherInfo(
                        '${weather.pressure} hPa',
                        'Pressure',
                        Icons.speed,
                      ),
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

  Widget buildWeatherInfo(String value, String label, IconData icon) {
    return Column(
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
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }
}
