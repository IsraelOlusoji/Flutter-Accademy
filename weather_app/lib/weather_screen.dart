import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:weather_app/additional_information.dart';
import 'package:weather_app/hourly_forecast_card.dart';
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  String _selectedCity = 'London';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final cityEncoded = Uri.encodeComponent(_selectedCity);
      final res = await http.get(
        Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=$openWeatherMapApiKey&q=$cityEncoded&days=1&aqi=no&alerts=no',
        ),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode != 200) {
        throw data['error'] != null
            ? data['error']['message']
            : 'An error occurred!';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatLocalTime(String localTimeStr) {
    try {
      final dateTime = DateTime.parse(localTimeStr);
      final weekday = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ][dateTime.weekday - 1];
      final month = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][dateTime.month - 1];
      return '$weekday, ${dateTime.day} $month';
    } catch (_) {
      return localTimeStr;
    }
  }

  String formatHourlyTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final hour = dateTime.hour;
      if (hour == 0) return '12 AM';
      if (hour == 12) return '12 PM';
      if (hour > 12) return '${hour - 12} PM';
      return '$hour AM';
    } catch (_) {
      return dateTimeStr;
    }
  }

  List<Color> getGradientColors(int isDay, String condition) {
    final cond = condition.toLowerCase();
    if (isDay == 0) {
      return [const Color(0xFF0B0F19), const Color(0xFF1E2640)];
    }

    if (cond.contains('rain') ||
        cond.contains('drizzle') ||
        cond.contains('shower')) {
      return [const Color(0xFF374151), const Color(0xFF1F2937)];
    } else if (cond.contains('cloud') ||
        cond.contains('overcast') ||
        cond.contains('mist') ||
        cond.contains('fog')) {
      return [const Color(0xFF4B5563), const Color(0xFF374151)];
    } else {
      return [const Color(0xFF1E88E5), const Color(0xFF1565C0)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: weather,
      builder: (context, snapshot) {
        final data = snapshot.data;

        List<Color> gradientColors = [
          const Color(0xFF0F172A),
          const Color(0xFF1E293B),
        ];

        if (snapshot.hasData && data != null) {
          final currentWeatherData = data['current'];
          final isDay = currentWeatherData['is_day'] ?? 1;
          final currentSkyDescription =
              currentWeatherData['condition']['text'] ?? 'Clear';
          gradientColors = getGradientColors(isDay, currentSkyDescription);
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: _isSearching
                  ? TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'Search city...',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          setState(() {
                            _selectedCity = value.trim();
                            weather = getCurrentWeather();
                            _isSearching = false;
                          });
                        }
                      },
                      autofocus: true,
                    )
                  : const Text(
                      'Weather App',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
              centerTitle: true,
              actions: [
                if (_isSearching)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                      });
                    },
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      weather = getCurrentWeather();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: SafeArea(
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : snapshot.hasError
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              color: Colors.redAccent,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Error Loading Weather',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedCity = 'London';
                                  weather = getCurrentWeather();
                                  _searchController.clear();
                                  _isSearching = false;
                                });
                              },
                              icon: const Icon(Icons.location_city),
                              label: const Text('Reset to London'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white24,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main weather summary card
                            SizedBox(
                              width: double.infinity,
                              child: Card(
                                elevation: 0,
                                color: Colors.white.withValues(alpha: 0.08),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5,
                                      sigmaY: 5,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 24,
                                        horizontal: 16,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            data!['location']['name'],
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            data['location']['country'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            formatLocalTime(
                                              data['location']['localtime'],
                                            ),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white60,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${data['current']['temp_c'].round()}',
                                                style: const TextStyle(
                                                  fontSize: 76,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: -2,
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  top: 12,
                                                ),
                                                child: Text(
                                                  '°C',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Image.network(
                                            'https:${data['current']['condition']['icon']}',
                                            width: 64,
                                            height: 64,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                                      Icons.cloud,
                                                      size: 64,
                                                    ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            '${data['current']['condition']['text']}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Hourly forecast header
                            const Text(
                              'Hourly Forecast',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Hourly forecast list
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                itemCount: 24,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  final hourlyForecast =
                                      data['forecast']['forecastday'][0]['hour'][index];
                                  final hourlyTemp =
                                      '${hourlyForecast['temp_c'].round()}°C';
                                  final time = hourlyForecast['time'];
                                  final hourlyIcon =
                                      hourlyForecast['condition']['icon'];

                                  return HourlyForecastCard(
                                    icon: Image.network(
                                      'https:$hourlyIcon',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.cloud, size: 40),
                                    ),
                                    temperature: hourlyTemp,
                                    time: formatHourlyTime(time),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Additional details header
                            const Text(
                              'Additional Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Grid of additional weather details
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.82,
                              children: [
                                AdditionalInformationItem(
                                  title: 'Sunrise',
                                  value:
                                      '${data['forecast']['forecastday'][0]['astro']['sunrise']}',
                                  icon: Icons.wb_twilight,
                                  iconColor: Colors.amberAccent,
                                ),
                                AdditionalInformationItem(
                                  title: 'Sunset',
                                  value:
                                      '${data['forecast']['forecastday'][0]['astro']['sunset']}',
                                  icon: Icons.nights_stay,
                                  iconColor: Colors.deepOrangeAccent,
                                ),
                                AdditionalInformationItem(
                                  title: 'Feels Like',
                                  value:
                                      '${data['current']['feelslike_c'].round()}°C',
                                  icon: Icons.thermostat,
                                  iconColor: Colors.redAccent,
                                ),
                                AdditionalInformationItem(
                                  title: 'Humidity',
                                  value: '${data['current']['humidity']}%',
                                  icon: Icons.water_drop,
                                  iconColor: Colors.blueAccent,
                                ),
                                AdditionalInformationItem(
                                  title: 'Wind Speed',
                                  value: '${data['current']['wind_kph']} km/h',
                                  icon: Icons.air,
                                  iconColor: Colors.tealAccent,
                                ),
                                AdditionalInformationItem(
                                  title: 'Pressure',
                                  value: '${data['current']['pressure_mb']} mb',
                                  icon: Icons.compress,
                                  iconColor: Colors.orangeAccent,
                                ),

                                AdditionalInformationItem(
                                  title: 'UV Index',
                                  value: '${data['current']['uv']}',
                                  icon: Icons.wb_sunny,
                                  iconColor: Colors.yellowAccent,
                                ),
                                AdditionalInformationItem(
                                  title: 'Visibility',
                                  value: '${data['current']['vis_km']} km',
                                  icon: Icons.visibility,
                                  iconColor: Colors.greenAccent,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
