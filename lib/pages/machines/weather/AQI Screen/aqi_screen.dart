import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/appcolors.dart';
import '../../../../utils/helper method/helper_methods.dart';
import '../../../../utils/images.dart';
import '../../../../utils/resources/images.dart';
import '../../../../utils/themes/dimensions.dart';
import '../../../../utils/themes/styles.dart';
import '../widgets/upper_bar.dart';


class AqiScreen extends StatefulWidget {
  const AqiScreen({super.key, required this.school});

  final String school;

  @override
  State<AqiScreen> createState() => _AqiScreenState();
}

class _AqiScreenState extends State<AqiScreen> {

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
      "enddate": formattedDate
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
        setState(() {
          forecastData = dataList.map((item) {
            final aqiInfo = jsonDecode(item['aqi_json']);
            return {
              'aqi': aqiInfo['aqi'],
              'pollutants': {
              'dust': aqiInfo['dust'],
              'smoke': aqiInfo['smoke'],
              'co2': aqiInfo['co2'],
              'co': aqiInfo['co'],
              'alcohol': aqiInfo['alcohol'],
              'ammonia': aqiInfo['ammonia'],
              'benzene': aqiInfo['benzene'],
              'toluene': aqiInfo['toluene'],
              'methane': aqiInfo['methane'],
            },
              'date': formatDate(item['created_at']),
              'today': item['created_at'] == DateTime.now().toString().split(' ')[0] ? 'TODAY' : 'TODAY'
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

  @override
  Widget build(BuildContext context) {
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    return Container(
      decoration: const BoxDecoration(
        image:  DecorationImage(image: AssetImage(aqi_bg)),
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
            child: Column(
              children: [
                const  UpperBar(index:"sub1"),// Your existing upper bar
                 SizedBox(
                    height:
                        h * 0.05 ), // Add spacing between the UpperBar and AQI list
                Expanded(
                  child:
                      buildAqiList(w,h), // Build the AQI list as a separate widget
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    Widget buildAqiList(double w, double h) {
      final List<Map<String, dynamic>> forecastData1 = [
        {
          'aqi': '-',
          'date': 'TODAY',
          'pollutants': {
            'DUST PARTICLES': '-',
            'SMOKE': '-',
            'CO2': '-',
            'CO': '-',
            'ALCOHOL': '-',
            'AMMONIA': '-',
            'BENZENE': '-',
            'TOLUENE': '-',
            'METHANE': '-',
          }
        },
        {
          'aqi': '-',
          'date': '-',
          'pollutants': {
            'DUST PARTICLES': '-',
            'SMOKE': '-',
            'CO2': '-',
            'CO': '-',
            'ALCOHOL': '-',
            'AMMONIA': '-',
            'BENZENE': '-',
            'TOLUENE': '-',
            'METHANE': '-',
          }
        },
        {
          'aqi': '-',
          'date': '-',
          'pollutants': {
            'DUST PARTICLES': '-',
            'SMOKE': '-',
            'CO2': '-',
            'CO': '-',
            'ALCOHOL': '-',
            'AMMONIA': '-',
            'BENZENE': '-',
            'TOLUENE': '-',
            'METHANE': '-',
          }
        },
        {
          'aqi': '-',
          'date': '-',
          'pollutants': {
            'DUST PARTICLES': '-',
            'SMOKE': '-',
            'CO2': '-',
            'CO': '-',
            'ALCOHOL': '-',
            'AMMONIA': '-',
            'BENZENE': '-',
            'TOLUENE': '-',
            'METHANE': '-',
          }
        },
        {
          'aqi': '-',
          'date': '-',
          'pollutants': {
            'DUST PARTICLES': '-',
            'SMOKE': '-',
            'CO2': '-',
            'CO': '-',
            'ALCOHOL': '-',
            'AMMONIA': '-',
            'BENZENE': '-',
            'TOLUENE': '-',
            'METHANE': '-',
          }
        },
        {
          'aqi': '-',
          'date': '-',
          'pollutants': {
            'DUST PARTICLES': '-',
            'SMOKE': '-',
            'CO2': '-',
            'CO': '-',
            'ALCOHOL': '-',
            'AMMONIA': '-',
            'BENZENE': '-',
            'TOLUENE': '-',
            'METHANE': '-',
          }
        },
        {
          'aqi': '-',
          'date': '-',
          'pollutants': {
            'DUST PARTICLES': '-',
            'SMOKE': '-',
            'CO2': '-',
            'CO': '-',
            'ALCOHOL': '-',
            'AMMONIA': '-',
            'BENZENE': '-',
            'TOLUENE': '-',
            'METHANE': '-',
          }
        },
        {
          'aqi': '-',
          'date': '-',
          'pollutants': {
            'DUST PARTICLES': '-',
            'SMOKE': '-',
            'CO2': '-',
            'CO': '-',
            'ALCOHOL': '-',
            'AMMONIA': '-',
            'BENZENE': '-',
            'TOLUENE': '-',
            'METHANE': '-',
          }
        },
      ];

      return forecastData.isNotEmpty?ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastData.length,
        itemBuilder: (context, index) {
          return airQualityCard(forecastData[index], index,w,h);
        },
      ):ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastData1.length,
        itemBuilder: (context, index) {
          return airQualityCard(forecastData1[index], index,w,h);
        },
      );
    }

    Widget airQualityCard(Map<String, dynamic> data, int index, double w, double h) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        padding: const EdgeInsets.all(0.5),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Container(
          width: index == 0 ? w * 0.245 : w * 0.13,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            // color: const Color(0xFF2c245b),
            borderRadius: BorderRadius.circular(15),
            color: Color.fromRGBO(28, 37, 31, 0.5),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (index == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      aqiImage,
                      height: h * 0.12,
                      width: w * 0.12,
                    ),
                    // const SizedBox(width: 8),
                    Padding(
                      padding:  EdgeInsets.only(right: w * 0.022),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: w * 0.015,),
                              Text(
                                data['aqi'],
                                style: AppStyle.instanse.michromaFontTextStyle(
                                    context: context,
                                    textColor: AppColor.instanse.greenCcc,
                                    fontWeight: FontWeight.w700,
                                    fontSize: w * 0.02),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.01,),
                          Text(data['date'],
                              style: AppStyle.instanse.michromaFontTextStyle(
                                  context: context,
                                  textColor: AppColor.instanse.colorWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: w * 0.014))
                        ],
                      ),
                    ),
                  ],
                ),
              if (index != 0)
                Row(
                  children: [
                    Container(
                      // width: w * 0.3,
                      width: w * 0.1,
                      height: h * 0.12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // color: Colors.red,
                        image: const DecorationImage(image: AssetImage(leaf_bg),fit: BoxFit.fill),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            data['aqi'],
                            style: AppStyle.instanse.michromaFontTextStyle(
                                context: context,
                                textColor: AppColor.instanse.colorWhite,
                                fontWeight: FontWeight.w700,
                                fontSize: w * 0.02),
                          ),
                          SizedBox(height: h * 0.01,),
                          Text(data['date'],
                              style: AppStyle.instanse.michromaFontTextStyle(
                                  context: context,
                                  textColor: AppColor.instanse.colorWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: w * 0.01)),
                        ],
                      ),
                    ),
                  ],
                ),
              ///unused code
              // index == 0
              //     ? Text(data['date'],
              //         style: AppStyle.instanse.michromaFontTextStyle(
              //             context: context,
              //             textColor: AppColor.instanse.colorWhite,
              //             fontWeight: FontWeight.w500,
              //             fontSize: w * 0.01))
              //     : Text(data['date'],
              //         style: AppStyle.instanse.michromaFontTextStyle(
              //             context: context,
              //             textColor: AppColor.instanse.colorWhite,
              //             fontWeight: FontWeight.w500,
              //             fontSize: w * 0.01)),
              ///
              index == 0 ? heightGap(h * 0.03) : heightGap(h * 0.03),
              Column(
                children: data['pollutants'].entries.map<Widget>((entry) {
                  return pollutantRow(entry.key, entry.value, index,w,h);
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }

    Widget pollutantRow(String pollutant, String value, int index, double w, double h) {
      return Column(
        children: [
          Container(
            height: 0.3,
            width: w * 0.35,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 15),
            child: Row(
              mainAxisAlignment: index==0?MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
              children: [
                if (index == 0)
                  Text(
                    pollutant,
                    style: TextStyle(color: Colors.white, fontSize: w * 0.015,fontWeight: FontWeight.bold),
                  ),
                Text(
                  value,
                  style: TextStyle(color: Colors.white, fontSize: w * 0.015,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      );
    }
}
