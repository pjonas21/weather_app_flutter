import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:weather_app/theme/theme_provider.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('YOUR_API_KEY');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/clouds.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    // double temp = double.parse(_weather?.temperature ?? "12.0");
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // location
              Column(
                children: [
                  Icon(
                    Icons.location_pin,
                    size: 28,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  // get city name
                  Text(
                    _weather?.cityName.toUpperCase() ?? "Loading ...",
                    style: GoogleFonts.teko(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // animation
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

              // get temperature
              Text(
                '${_weather?.temperature.round()}ºC',
                style: GoogleFonts.teko(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.light_mode, size: 18,),
            Icon(Icons.dark_mode, size: 18,)
          ],
        ),
      ),
    );
  }
}
