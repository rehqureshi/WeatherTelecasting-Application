import 'dart:convert';
import 'dart:ui';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weatherproject2/secrets.dart';

import 'additional_info_item.dart';
import 'hourly_forcast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityname = 'Bangalore';
      final res = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openWeatherApiKey'));

      final data = jsonDecode(res.body);

      if (int.parse(data['cod']) != 200) {
        throw "An Unexpected Error Occured";
      }
      return data;
      //temp = data['list'][0]['main']['temp'];
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
        elevation: 5,
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            final data = snapshot.data!;
            final currentTemp = data['list'][0]['main']['temp'];
            final currentSky = data['list'][0]['weather'][0]['main'];
            final currentPressure = data['list'][0]['main']['pressure'];
            final currentHumidity = data['list'][0]['main']['humidity'];
            final currentWindSpeed = data['list'][0]['wind']['speed'];
            return Column(
              children: [
                //Main Card
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp°K',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 33,
                                    color: Colors.orangeAccent),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud_sharp
                                    : Icons.sunny,
                                size: 67,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                "$currentSky",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //
                //horizontal slide blocks
                const SizedBox(
                  height: 16,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Weather Forcast",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    )),
                const SizedBox(
                  height: 10,
                ),
                // SingleChildScrollView( // saare components saath me bann rahe the hume chahiye ki scroll krte jaaye  yeh widget banta jaaye isliye we have used listview below
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 9; i++)
                //         HourlyForcastwidged(
                //           time: data['list'][i + 1]['dt'].toString(),
                //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Clouds' ||
                //                   data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Rain'
                //               ? Icons.cloud
                //               : Icons.sunny,
                //           temp: data['list'][i + 1]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7, // Build on demand
                    itemBuilder: (context, index) {
                      final hourlyForcast = data['list'][index + 1];
                      final time = DateTime.parse(hourlyForcast['dt_txt']);
                      return HourlyForcastwidged(
                        time: DateFormat('j').format(time),
                        icon: hourlyForcast['weather'][0]['main'] == 'Rain' ||
                                hourlyForcast['weather'][0]['main'] == 'Clouds'
                            ? Icons.cloud
                            : Icons.sunny,
                        temp: '${hourlyForcast['main']['temp']}°K',
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                //Additional Info
                const SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                          icon: Icons.water_drop,
                          parameter: "Humidity",
                          value: "$currentHumidity"),
                      AdditionalInfoItem(
                          icon: Icons.water,
                          parameter: "Wind Speed",
                          value: "$currentWindSpeed"),
                      AdditionalInfoItem(
                          icon: Icons.beach_access,
                          parameter: "Pressure",
                          value: "$currentPressure")
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
