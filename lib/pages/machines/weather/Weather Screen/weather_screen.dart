import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/appcolors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/resources/images.dart';
import '../../../../utils/themes/dimensions.dart';
import '../../../../utils/themes/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/upper_bar.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, required this.school});

  final String school;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  List<Map<String, dynamic>> forecastData = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  String formatDate(String dateTimeString) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the date as "MMM dd" (e.g., "JUN 06")
    String formattedDate = DateFormat('MMM dd').format(dateTime).toUpperCase();

    return formattedDate;
  }

  Future<void> fetchWeatherData() async {
    const url = 'https://cspv.in/aerobay/weatherMan/get.php';
    DateTime now = DateTime.now();

    // Format the date
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

    // Format the date
    String formattedDate1 = DateFormat('yyyy-MM-dd').format(sevenDaysAgo);
    final payload = jsonEncode({
      // "schoolname": "avm234",
      "schoolname": widget.school,
      // "startdate": "2024-11-06",
      "startdate": formattedDate1,
      // "enddate": "2024-11-12",
      "enddate": formattedDate,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final dataList = decodedData['data'] as List;
        print(dataList);
        setState(() {
          forecastData = dataList.map((item) {
            final weatherInfo = jsonDecode(item['weather']);
            return {
              'weather': weatherInfo['info'],
              'temp': weatherInfo['temp'],
              'humidity': item['humidity'],
              // 'date': item['created_at'].split(' ')[0],
              'date': formatDate(item['created_at']),
              'today': item['created_at'] == DateTime.now().toString().split(' ')[0] ? 'TODAY' : 'TODAY',
              'icon': getWeatherIcon(weatherInfo['info']), // Implement your icon logic
            };
          }).toList();
        });
      } else {
        print('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String getWeatherIcon(String weatherInfo) {
    if (weatherInfo == 'SUNNY') return sunImage;
    if (weatherInfo == 'HEAVY RAIN') return rainmeterImage;
    return sunImage; // Default
  }

  @override
  Widget build(BuildContext context) {
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    return Container(
      decoration: const BoxDecoration(
        image:  DecorationImage(image: AssetImage(weather_sub_bg)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: EdgeInsets.only(
                top: w * 0.03,
                left: w * 0.03,
                right: w * 0.03,
                bottom: w * 0.01),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color(0xFF898798), width: 3)),
            child:  Column(
              children: [
                UpperBar(index:"sub"),
                SizedBox(height: w * 0.04),
                WeatherForecast(forecastData: forecastData),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherForecast extends StatelessWidget {
  final List<Map<String, dynamic>> forecastData;

  const WeatherForecast({super.key, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    // final List<Map<String, dynamic>> forecastData = [
    //   {
    //     'weather': 'PARTLY CLOUDY',
    //     'temp': '45',
    //     'humidity': '29%',
    //     'date': 'JUN 06',
    //     'today': 'TODAY',
    //     'icon': sunImage
    //   },
    //   {
    //     'weather': 'SUNNY',
    //     'temp': '37',
    //     'humidity': '29%',
    //     'date': 'JUN 05',
    //     'today': '',
    //     'icon': sunImage
    //   },
    //   {
    //     'weather': 'HEAVY RAIN',
    //     'temp': '29',
    //     'humidity': '29%',
    //     'date': 'JUN 04',
    //     'today': '',
    //     'icon': rainmeterImage
    //   },
    //   {
    //     'weather': 'PARTLY CLOUDY',
    //     'temp': '29',
    //     'humidity': '29%',
    //     'date': 'JUN 04',
    //     'today': '',
    //     'icon': sunImage
    //   },
    //   {
    //     'weather': 'PARTLY CLOUDY',
    //     'temp': '29',
    //     'humidity': '29%',
    //     'date': 'JUN 04',
    //     'today': '',
    //     'icon': sunImage
    //   },
    //   {
    //     'weather': 'PARTLY CLOUDY',
    //     'temp': '29',
    //     'humidity': '29%',
    //     'date': 'JUN 04',
    //     'today': '',
    //     'icon': sunImage
    //   },
    //   {
    //     'weather': 'PARTLY CLOUDY',
    //     'temp': '29',
    //     'humidity': '29%',
    //     'date': 'JUN 04',
    //     'today': '',
    //     'icon': sunImage
    //   },
    // ];

    ///
    final List<Map<String, dynamic>> forecastData111 = [
      {
        'weather': '-',
        'temp': '-',
        'humidity': '-',
        'date': 'JUN 06',
        'today': 'TODAY',
        'icon': sunImage
      },
      {
        'weather': '-',
        'temp': '-',
        'humidity': '-',
        'date': 'JUN 05',
        'today': '',
        'icon': sunImage
      },
      {
        'weather': '-',
        'temp': '-',
        'humidity': '-',
        'date': 'JUN 04',
        'today': '',
        'icon': rainmeterImage
      },
      {
        'weather': '-',
        'temp': '-',
        'humidity': '-',
        'date': 'JUN 04',
        'today': '',
        'icon': sunImage
      },
      {
        'weather': '-',
        'temp': '-',
        'humidity': '-',
        'date': 'JUN 04',
        'today': '',
        'icon': sunImage
      },
      {
        'weather': '-',
        'temp': '-',
        'humidity': '-',
        'date': 'JUN 04',
        'today': '',
        'icon': sunImage
      },
      {
        'weather': '-',
        'temp': '-',
        'humidity': '-',
        'date': 'JUN 04',
        'today': '',
        'icon': sunImage
      },
    ];

    return SizedBox(
      height: h * 0.6,
      child: forecastData.isNotEmpty?ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastData.length,
        itemBuilder: (context, index) {
          // double width = index == 0 ? 160 : 120;
          double width = index == 0 ? 140 : 100;
          double height = index == 0 ? 260 : 250;
          double w = ResponsiveSize.width(context);
          double h = ResponsiveSize.height(context);
          final data = forecastData[index];
          return weatherBox(
            forecastData[index]['weather'],
            forecastData[index]['temp'],
            forecastData[index]['humidity'],
            forecastData[index]['date'],
            forecastData[index]['today'],
            forecastData[index]['icon'],
              // data['weather'],
              // data['temp'],
              // data['humidity'],
              // data['date'],
              // data['today'],
              // data['icon'],
            width,
            height,
            index, w,h,context// Pass index to determine layout
          );
        },
      ):ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastData111.length,
        itemBuilder: (context, index) {
          // double width = index == 0 ? 160 : 120;
          double width = index == 0 ? 140 : 100;
          double height = index == 0 ? 260 : 250;
          double w = ResponsiveSize.width(context);
          double h = ResponsiveSize.height(context);
          final data = forecastData111[index];
          return weatherBox(
              forecastData111[index]['weather'],
              forecastData111[index]['temp'],
              forecastData111[index]['humidity'],
              forecastData111[index]['date'],
              forecastData111[index]['today'],
              forecastData111[index]['icon'],
              // data['weather'],
              // data['temp'],
              // data['humidity'],
              // data['date'],
              // data['today'],
              // data['icon'],
              width,
              height,
              index, w,h,context// Pass index to determine layout
          );
        },
      ),
    );
  }

  Widget weatherBox(String weather, String temp, String humidity, String date,
      String today, String iconPath, double width, double height, int index, double w, double h, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.all(0.5),
      // decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topRight,
      //       end: Alignment.bottomLeft,
      //       stops: [0.0, 0.3, 0.4, 0.5, 0.6, 0.7, 1.0],
      //       colors: [
      //         Colors.white,
      //         Color(0xE1DFDFCA),
      //         Color(0xFF5e6c94),
      //         Color(0xFF626475),
      //         Color(0xff3e3e63),
      //         Color(0xFF47407A),
      //         Color(0xff47407a),
      //       ],
      //     ),
      //     borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        decoration: BoxDecoration(
          // color: const Color(0xFF2c245b),
          color: Color.fromRGBO(28, 37, 31, 0.5),
          borderRadius: BorderRadius.circular(15),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black38,
          //     blurRadius: 5,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              weather,
              style: AppStyle.instanse.michromaFontTextStyle(
                context: context,
                textColor: AppColor.instanse.colorWhite,
                fontWeight: FontWeight.w700,
                fontSize: w * 0.01,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: index == 0?Image.asset(
                iconPath,
                height: h * 0.23,
              ):Image.asset(
                iconPath,
                height: h * 0.15,
              ),
            ),
            if (index == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: w * 0.02),
                    child: Column(
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        if (today.isNotEmpty)
                          Text(
                            today,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '$temp°c',
                        style: TextStyle(
                          fontSize: w * 0.03,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 1,
                        width: w * 0.07,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            stops: [0.0, 0.3, 0.4, 0.5, 0.6, 0.7, 1.0],
                            colors: [
                              Color(0xFF5c6c94),
                              Color(0xFF5e6c94),
                              Color(0xFF57648e),
                              Color(0xFF444976),
                              Color(0xFF3a3a6a),
                              Color(0xFF322c5f),
                              Color(0xFF2c245b),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        humidity,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '$temp°c',
                        style: TextStyle(
                          fontSize: w * 0.025,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: w * 0.04,),
                          Container(
                            height: 1,
                            width: w * 0.09,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                stops: [0.0, 0.3, 0.4, 0.5, 0.6, 0.7, 1.0],
                                colors: [
                                  Color(0xFF5c6c94),
                                  Color(0xFF5e6c94),
                                  Color(0xFF57648e),
                                  Color(0xFF444976),
                                  Color(0xFF3a3a6a),
                                  Color(0xFF322c5f),
                                  Color(0xFF2c245b),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        humidity,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
