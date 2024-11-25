
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssss/pages/machines/weather/widgets/aqi_box.dart';
import 'package:ssss/pages/machines/weather/widgets/atm_box.dart';
import 'package:ssss/pages/machines/weather/widgets/humidity.dart';
import 'package:ssss/pages/machines/weather/widgets/rain_meter.dart';
import 'package:ssss/pages/machines/weather/widgets/upper_bar.dart';
import 'package:ssss/pages/machines/weather/widgets/uvindex_box.dart';
import 'package:ssss/pages/machines/weather/widgets/visibility_box.dart';
import 'package:ssss/pages/machines/weather/widgets/weather_box.dart';
import 'package:ssss/pages/machines/weather/widgets/windspeed_box.dart';

import '../../../logic/logic.dart';
import '../../../logic/mqtt_class.dart';
import '../../../utils/helper method/helper_methods.dart';
import '../../../utils/resources/images.dart';
import '../../../utils/themes/dimensions.dart';

class WeatherManScreen extends StatefulWidget {
  const WeatherManScreen({super.key, required this.title});

  final String title;

  @override
  State<WeatherManScreen> createState() => _WeatherManScreenState();
}

class _WeatherManScreenState extends State<WeatherManScreen> {

  @override
  void initState() {
    super.initState();
    fetchWeatherData1();
    _connect();
  }

  Future<void> fetchWeatherData1() async {
    Future.delayed(const Duration(seconds: 2), () async {
      DateTime yesterday = DateTime.now();
      DateTime yesterday1 = DateTime.now().subtract(Duration(days: 6));
      String formattedEndDate  = DateFormat('yyyy-MM-dd').format(yesterday);
      String formattedStartDate  = DateFormat('yyyy-MM-dd').format(yesterday1);
      // print("helloooooooooooooooooo");
      // print(formattedDate);
      // print(formattedDate1);
      String ss=context.read<LogicProvider>().schoolName;

      final requestData = {
        "schoolname": ss,
        "startdate": formattedStartDate ,
        "enddate": formattedEndDate ,
      };

      try {
        final response = await http.post(
          Uri.parse("https://cspv.in/aerobay/weatherMan/get.php"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestData),
        );

        if (response.statusCode == 200) {
          // final responseData = jsonDecode(response.body);
          //
          // if (responseData['message'] == 'Data retrieved successfully' && responseData['data'] != null) {
          //   final data = responseData['data'];
          //   print("api data");
          //   print(data);
          //   final data1 = responseData['data'][0];
          //   context.read<LogicProvider>().updateWeatherData1(data1);
          //
          //
          // } else {
          //   print("Error in response: ${responseData['message']}");
          //   Fluttertoast.showToast(msg: "${responseData['message']}");
          // }
          ///try
          final responseData = jsonDecode(response.body);

          if (responseData['message'] == 'Data retrieved successfully' && responseData['data'] != null) {
            final dataList = responseData['data'];

            // Update today's data
            final todayData = dataList.firstWhere(
                  (data) =>
              DateFormat('yyyy-MM-dd').format(DateTime.parse(data['created_at'])) ==
                  formattedEndDate,
              orElse: () => null,
            );

            if (todayData != null) {
              context.read<LogicProvider>().updateWeatherData1(todayData);
            }

            // Update the previous six days' data
            List<String> windL = [];
            List<String> VisiL = [];
            List<String> UVL = [];

            for (var data in dataList) {
              final createdAt = DateTime.parse(data['created_at']);
              final formattedDate = DateFormat('yyyy-MM-dd').format(createdAt);

              if (formattedDate != formattedEndDate) {
                windL.add(data['wind']?.toString() ?? '0');
                VisiL.add(data['visibility']?.toString() ?? '0');
                UVL.add(data['uv']?.toString() ?? '0');
              }
            }

            // Update lists in the provider
            context.read<LogicProvider>().updatePreviousDaysData(windL, VisiL, UVL);
          } else {
            print("Error in response: ${responseData['message']}");
            Fluttertoast.showToast(msg: "${responseData['message']}");
          }
        } else {
          print("Failed to fetch data: ${response.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
      }
    });
  }

  Future<void> _connect() async {
    try {
      await MQTTService.instance.initialize(
        server: 'otplai.com',
        port: 8883, // or the port you're using
        clientId: 'xxxx',
        username: 'oyt',
        password: '123456789',
      );
    } catch (e) {
      print('Error connecting to MQTT: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(image: AssetImage(wea1)),
      ),
      // decoration: const BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.centerRight,
      //     end: Alignment.centerLeft,
      //     stops: [0.0, 0.3, 0.4, 0.5, 0.6, 0.7, 1.0],
      //     colors: [
      //       Color(0xFF070614),
      //       Color(0xFF2a1d74),
      //       Color(0xFF382693),
      //       Color(0xFF382698),
      //       Color(0xFF382693),
      //       Color(0xFF2a1d74),
      //       Color(0xFF070614),
      //     ],
      //   ),
      // ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.all(8),
          padding: EdgeInsets.only(
              top: w * 0.03,
              // left: w * 0.03,
              left: w * 0.025,
              // right: w * 0.03,
              // right: w * 0.005,
              bottom: w * 0.01),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color(0xFF898798), width: 3)),
          child: Column(
            children: [
              const  UpperBar(index:"main"),
              //Weather Container
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: w*0.05,right: w*0.05,top: h*0.01),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WeatherBox(),
                            SizedBox(height: h * 0.01,),
                            AqiBox(),
                          ],
                        ),
                      ), SizedBox(width: w * 0.01,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                               WindSpeedBox(),
                              widthGap(w *0.01),
                               VisibilityBox(),
                            ],
                          ),
                           Row(
                            children: [
                              Column(
                                children: [
                                   HumidityBox(),
                                  heightGap(h*0.012),
                                   RainMeter(),
                                ],
                              ),
                              // widthGap(w*0.02),
                              widthGap(w*0.04),
                               AtmBox(),
                              // widthGap(w*0.02),
                              widthGap(w*0.04),
                               UvIndexBox()
                              // widthGap(w * 0.15)
                            ],
                          ),
                          // SizedBox(
                          //   height:h * 0.22,
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
