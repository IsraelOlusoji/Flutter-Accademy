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
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';

      final res = await http.get(
        Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=$openWeatherMapApiKey&q=$cityName&days=1&aqi=no&alerts=no',
        ),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode != 200) {
        throw 'An error occurred!';
      }

      return data;

      // setState(() {
      //   temp = data['current']['temp_c'];
      //   conditionIcon = data['current']['condition']['icon'];
      // });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
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
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          //current weather condition
          final currentWeatherData = data['current'];
          final currentTemp = currentWeatherData['temp_c'];
          final currentConditionIcon = currentWeatherData['condition']['icon'];
          final currentSkyDescription = currentWeatherData['condition']['text'];
          final currentHumidity = currentWeatherData['humidity'];
          final currentWindSpeed = currentWeatherData['wind_kph'];
          final currentPressure = currentWeatherData['pressure_mb'];

          //hourly weather forecast

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                //main card
                // const Placeholder(fallbackHeight: 250),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp°C',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 10),

                              // const Icon(Icons.cloud, size: 80),
                              Image.network(
                                'https:$currentConditionIcon',
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),

                              SizedBox(height: 10),

                              Text(
                                '$currentSkyDescription',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                //weather forecast cards
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 24; i++) ...[
                //         HourlyForecastCard(
                //           icon: Image.network(
                //             'https:${data['forecast']['forecastday'][0]['hour'][i]['condition']['icon']}',
                //             width: 32,
                //             height: 32,
                //             fit: BoxFit.contain,
                //           ),
                //           temperature:
                //               '${data['forecast']['forecastday'][0]['hour'][i]['temp_c']}°C',
                //           time: DateTime.fromMillisecondsSinceEpoch(
                //             data['forecast']['forecastday'][0]['hour'][i]['time_epoch'] *
                //                 1000,
                //           ).toString().substring(10, 16),
                //         ),
                //       ],
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: 24,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final hourlyForcast =
                          data['forecast']['forecastday'][0]['hour'][index];

                      final hourlyTemp = hourlyForcast['temp_c'].toString();
                      final time = hourlyForcast['time'];

                      final hourlyTime = time.substring(11);

                      final hourlyIcon = hourlyForcast['condition']['icon'];

                      return HourlyForecastCard(
                        icon: Image.network(
                          'https:$hourlyIcon',
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                        temperature: hourlyTemp,
                        time: hourlyTime,
                      );
                    },
                  ),
                ),

                //Additional info cards
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformationItem(
                      title: 'Humidity',
                      value: '${currentHumidity.toString()}%',
                      icon: Icons.water_drop,
                    ),
                    AdditionalInformationItem(
                      title: 'Wind speed',
                      value: '${currentWindSpeed.toString()} km/h',
                      icon: Icons.air,
                    ),
                    AdditionalInformationItem(
                      title: 'Pressure',
                      value: '${currentPressure.toString()} mb',
                      icon: Icons.beach_access,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
