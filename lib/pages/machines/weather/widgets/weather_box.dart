import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../logic/logic.dart';
import '../../../../logic/mqtt_class.dart';
import '../../../../utils/appcolors.dart';
import '../../../../utils/resources/images.dart';
import '../../../../utils/themes/dimensions.dart';
import '../../../../utils/themes/styles.dart';
import '../Weather Screen/weather_screen.dart';

class WeatherBox extends StatefulWidget {
  const WeatherBox({super.key});

  @override
  State<WeatherBox> createState() => _WeatherBoxState();
}

class _WeatherBoxState extends State<WeatherBox> {


  @override
  Widget build(BuildContext context) {
    final logicProvider = Provider.of<LogicProvider>(context);
    MQTTService.instance.messageStream.listen((message) {
      // Update weather data when a new message is received
      // final weatherData = message['weather'];
      // if (weatherData != null) {
      //   logicProvider.updateWeatherData(weatherData);
      // }
      logicProvider.updateWeatherData(message);
      // print('Temperature: ${logicProvider.weatherData!['temp']}°C');
      // print('Humidity: ${logicProvider.weatherData!['humidity']}%');
      // print('Condition: ${logicProvider.weatherData!['info']}');
    });
    final now = DateTime.now();

    // Format the time as "HH:mm"
    final formattedTime = DateFormat('HH:mm').format(now);
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    return GestureDetector(
      onTap: (){
        String schoolNam=logicProvider.schoolName;
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  WeatherScreen(school:schoolNam)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        height: h * 0.35,
        width: w * 0.18,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.instanse.oxBorderColor, width: 2),
          image: const DecorationImage(image: AssetImage(weatherImage)),
          // gradient: const LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //       Color(0xFF100f15),
          //       Color(0xFF191635),
          //       Color(0xFF251f53),
          //       Color(0xFF2c235c),
          //       Color(0xFF2c235b),
          //     ]),
          // color: Colors.blueGrey[900],
          color: Color.fromRGBO(28, 37, 31, 0.5),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("WEATHER",
                style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                    fontWeight: FontWeight.w700, fontSize: w * 0.013)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                logicProvider.temp.isNotEmpty?  Text(
                    // logicProvider.weatherData!['temp'],
                    logicProvider.temp+'\u00B0',
                    style: AppStyle.instanse.whiteTextStyle(
                        fontSize: w * 0.021, fontWeight: FontWeight.w700, context: context)):Text(
                  // logicProvider.weatherData!['temp'],
                    '',
                    style: AppStyle.instanse.whiteTextStyle(
                        fontSize: w * 0.021, fontWeight: FontWeight.w700, context: context)),
                Text(
                  // logicProvider.weatherData!['info'],
                  logicProvider.weatherInfo,
                  style: AppStyle.instanse.whiteTextStyle(fontSize: w * 0.01, context: context),
                ),
                Column(
                  children: [
                    Text(
                      formattedTime,
                      style: AppStyle.instanse.whiteTextStyle(context: context,),
                    ),
                    Text(
                      "TODAY",
                      style: AppStyle.instanse.whiteTextStyle(context: context),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
