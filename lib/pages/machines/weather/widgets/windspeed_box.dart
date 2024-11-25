// import '../../../Utils/all imports/allimports.dart';
// import 'dart:math';
//
// class WindSpeedBox extends StatefulWidget {
//   const WindSpeedBox({super.key});
//
//   @override
//   State<WindSpeedBox> createState() => _WindSpeedBoxState();
// }
//
// class _WindSpeedBoxState extends State<WindSpeedBox> {
//   @override
//   Widget build(BuildContext context) {
//     double w = ResponsiveSize.width(context);
//     double h = ResponsiveSize.height(context);
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
//       height: h * 0.26,
//       width: w * 0.3,
//       decoration: BoxDecoration(
//         border: Border.all(color: AppColor.instanse.oxBorderColor, width: 2),
//         gradient: const LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF4d5591),
//               Color(0xFF535893),
//               Color(0xFF656aa6),
//               Color(0xFF7176b3),
//               Color(0xFF8083c1),
//             ]),
//         color: Colors.blueGrey[900],
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text("WIND SPEED",
//                   style: AppStyle.instanse.defaultTextStyle(context, Colors.white,
//                       fontWeight: FontWeight.w700, fontSize: w * 0.013)),
//               Spacer(),
//               Container(
//                 height: h * 0.06,
//                 width: w * 0.028,
//                 child: Text("11",
//                     style: AppStyle.instanse.michromaFontTextStyle(
//                         textColor: AppColor.instanse.colorWhite,
//                         fontWeight: FontWeight.w700,
//                         fontSize: w * 0.013, context: context)),
//               ),
//               Column(
//                 children: [
//                   SizedBox(
//                       height: w * 0.02,
//                       width: w * 0.015,
//                       child: Image.asset(unitwind)),
//                   Text('m/s',
//                       style: TextStyle(
//                           fontSize: w * 0.008,
//                           color: AppColor.instanse.colorWhite)),
//                 ],
//               )
//             ],
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(6, (index) {
//                   int speedValue = 50 - index * 10;
//                   return Text(
//                     '$speedValue',
//                     style: TextStyle(
//                       fontSize: w * 0.008,
//                       color: AppColor.instanse.colorWhite,
//                     ),
//                   );
//                 }),
//               ),
//               widthGap(w * 0.004),
//               Container(
//                 width: w * 0.008,
//                 height: h * 0.175,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.red,
//                       Colors.orange,
//                       Colors.yellow,
//                       Colors.green,
//                       Colors.cyan,
//                       Colors.blue,
//                     ],
//                   ),
//                 ),
//               ),
//               widthGap(w * 0.01),
//               // Wind Chart
//               Expanded(
//                 child: WindSpeedChart(
//                   width: w * 0.2,
//                   height: h * 0.15,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class WindSpeedChart extends StatelessWidget {
//   final double width;
//   final double height;
//
//   const WindSpeedChart({required this.width, required this.height, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(width, height),
//       painter: WindSpeedChartPainter(),
//     );
//   }
// }
//
// class WindSpeedChartPainter extends CustomPainter {
//   final List<String> days = ['TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN', 'MON'];
//   final List<double> windSpeeds = List.generate(7, (index) => Random().nextDouble() * 50);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint fillPaint = Paint()
//       ..color = Colors.white.withOpacity(0.4)
//       ..style = PaintingStyle.fill;
//
//     Paint linePaint = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 2;
//
//     Path path = Path();
//     double xStep = size.width / (days.length - 1);
//     double maxWindSpeed = 50;
//
//     for (int i = 0; i < days.length; i++) {
//       double x = i * xStep;
//       double y = size.height - (windSpeeds[i] / maxWindSpeed) * size.height;
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }
//
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//     canvas.drawPath(path, fillPaint);
//
//     // Draw the line on top of the filled path
//     for (int i = 0; i < days.length - 1; i++) {
//       double x1 = i * xStep;
//       double y1 = size.height - (windSpeeds[i] / maxWindSpeed) * size.height;
//       double x2 = (i + 1) * xStep;
//       double y2 = size.height - (windSpeeds[i + 1] / maxWindSpeed) * size.height;
//       canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

///try1

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../logic/logic.dart';
import '../../../../utils/appcolors.dart';
import '../../../../utils/resources/images.dart';
import '../../../../utils/themes/dimensions.dart';
import '../../../../utils/themes/styles.dart';

class WindSpeedBox extends StatefulWidget {
  const WindSpeedBox({super.key});

  @override
  State<WindSpeedBox> createState() => _WindSpeedBoxState();
}

class _WindSpeedBoxState extends State<WindSpeedBox> {



  @override
  Widget build(BuildContext context) {

    final logicProvider = Provider.of<LogicProvider>(context);
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    double aa;
    double a1=0;
    double a2=0;
    double a3=0;
    double a4=0;
    double a5=0;
    double a6=0;

    List <String>windl=logicProvider.windL;
    // Fluttertoast.showToast(msg: windl.toString());
    // Fluttertoast.showToast(msg: windl.toString());
    // Future.delayed(const Duration(seconds: 1), () {
    if(windl.isNotEmpty && windl.length==6){
      if(windl[0].isNotEmpty){
        a1=double.parse(windl[0]);
      }
      if(windl[1].isNotEmpty){
        a2=double.parse(windl[1]);
      }
      if(windl[2].isNotEmpty){
        a3=double.parse(windl[2]);
      }
      if(windl[3].isNotEmpty){
        a4=double.parse(windl[3]);
      }
      if(windl[4].isNotEmpty){
        a5=double.parse(windl[4]);
      }
      if(windl[5].isNotEmpty){
        a6=double.parse(windl[5]);
      }}

    if(windl.isNotEmpty && windl.length==5){
      if(windl[0].isNotEmpty){
        a1=double.parse(windl[0]);
      }
      if(windl[1].isNotEmpty){
        a2=double.parse(windl[1]);
      }
      if(windl[2].isNotEmpty){
        a3=double.parse(windl[2]);
      }
      if(windl[3].isNotEmpty){
        a4=double.parse(windl[3]);
      }
      if(windl[4].isNotEmpty){
        a5=double.parse(windl[4]);
      }
      // if(windl[5].isNotEmpty){
      //   a6=double.parse(windl[5]);
      // }
    }

    if(windl.isNotEmpty && windl.length==4){
      if(windl[0].isNotEmpty){
        a1=double.parse(windl[0]);
      }
      if(windl[1].isNotEmpty){
        a2=double.parse(windl[1]);
      }
      if(windl[2].isNotEmpty){
        a3=double.parse(windl[2]);
      }
      if(windl[3].isNotEmpty){
        a4=double.parse(windl[3]);
      }
      // if(windl[4].isNotEmpty){
      //   a5=double.parse(windl[4]);
      // }
      // if(windl[5].isNotEmpty){
      //   a6=double.parse(windl[5]);
      // }
    }

    if(windl.isNotEmpty && windl.length==3){
      if(windl[0].isNotEmpty){
        a1=double.parse(windl[0]);
      }
      if(windl[1].isNotEmpty){
        a2=double.parse(windl[1]);
      }
      if(windl[2].isNotEmpty){
        a3=double.parse(windl[2]);
      }
      // if(windl[3].isNotEmpty){
      //   a4=double.parse(windl[3]);
      // }
      // if(windl[4].isNotEmpty){
      //   a5=double.parse(windl[4]);
      // }
      // if(windl[5].isNotEmpty){
      //   a6=double.parse(windl[5]);
      // }
    }

    if(windl.isNotEmpty && windl.length==2){
      if(windl[0].isNotEmpty){
        a1=double.parse(windl[0]);
      }
      if(windl[1].isNotEmpty){
        a2=double.parse(windl[1]);
      }
      // if(windl[2].isNotEmpty){
      //   a3=double.parse(windl[2]);
      // }
      // if(windl[3].isNotEmpty){
      //   a4=double.parse(windl[3]);
      // }
      // if(windl[4].isNotEmpty){
      //   a5=double.parse(windl[4]);
      // }
      // if(windl[5].isNotEmpty){
      //   a6=double.parse(windl[5]);
      // }
    }

    if(windl.isNotEmpty && windl.length==1){
      if(windl[0].isNotEmpty){
        a1=double.parse(windl[0]);
      }
      // if(windl[1].isNotEmpty){
      //   a2=double.parse(windl[1]);
      // }
      // if(windl[2].isNotEmpty){
      //   a3=double.parse(windl[2]);
      // }
      // if(windl[3].isNotEmpty){
      //   a4=double.parse(windl[3]);
      // }
      // if(windl[4].isNotEmpty){
      //   a5=double.parse(windl[4]);
      // }
      // if(windl[5].isNotEmpty){
      //   a6=double.parse(windl[5]);
      // }
    }


    // });



    logicProvider.wind.isEmpty?  aa=0:aa= double.parse(logicProvider.wind);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      height: h * 0.26,
      // width: w * 0.3,
      width: w * 0.31,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.instanse.oxBorderColor, width: 2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4d5591),
            Color(0xFF535893),
            Color(0xFF656aa6),
            Color(0xFF7176b3),
            Color(0xFF8083c1),
          ],
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            children: [
              Text(
                "WIND SPEED",
                style: AppStyle.instanse.defaultTextStyle(
                  context,
                  Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: w * 0.013,
                ),
              ),
              Spacer(),
              Container(
                height: h * 0.06,
                width: w * 0.028,
                child: Text(
                  logicProvider.wind,
                  style: AppStyle.instanse.michromaFontTextStyle(
                    textColor: AppColor.instanse.colorWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: w * 0.013,
                    context: context,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: w * 0.02,
                    width: w * 0.015,
                    child: Image.asset(unitwind),
                  ),
                  Text(
                    'm/s',
                    style: TextStyle(
                      fontSize: w * 0.008,
                      color: AppColor.instanse.colorWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: h * 0.02),
          // Filled Curve Line Chart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 50,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, a6),
                        FlSpot(1, a5),
                        FlSpot(2, a4),
                        FlSpot(3, a3),
                        FlSpot(4, a2),
                        FlSpot(5, a1),
                        FlSpot(6, aa),
                        // FlSpot(0, 10),
                        // FlSpot(1, 10),
                        // FlSpot(2, 10),
                        // FlSpot(3, 10),
                        // FlSpot(4, 10),
                        // FlSpot(5, 10),
                        // FlSpot(6, 10),
                      ],
                      isCurved: true,
                      barWidth: 1,
                      color: Colors.blue,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          List<String> days = ['TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN', 'MON'];
                          String currentDay = DateFormat('EEE').format(DateTime.now()).toUpperCase();

                          // Find the index of the current day
                          int currentIndex = days.indexOf(currentDay);

                          // Rearrange the list: take elements from the current day to the end, followed by the ones before it
                           days = days.sublist(currentIndex + 1) + days.sublist(0, currentIndex + 1);
                          return Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              days[value.toInt()],
                              style: TextStyle(
                                color: Colors.grey[900],
                                // fontSize: w * 0.009,
                                fontSize: w * 0.008,
                              ),
                            ),
                          );
                        },
                        reservedSize: 18,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 10,
                        getTitlesWidget: (value, meta) {
                          return Row(
                            children: [
                              value.toInt()==0?Text(
                                '  ${value.toInt()}',
                                style: TextStyle(
                                  color: Colors.grey.shade200,
                                  fontSize: w * 0.008,
                                ),
                              ):Text(
                                '${value.toInt()}',
                                style: TextStyle(
                                  color: Colors.grey.shade200,
                                  fontSize: w * 0.008,
                                ),
                              ),
                              Container(
                                height: 8,
                                width: 5,
                              )
                            ],
                          );
                        },
                      ),
                      ///if include middle day hide due to space
                      axisNameWidget: Padding(
                        // padding: const EdgeInsets.only(left: 20.0),
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Container(
                          height: 5,
                          width: 45,
                          // color: Colors.orange,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              // begin: Alignment.topCenter,
                              // end: Alignment.bottomCenter,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.red,
                                Colors.orange,
                                Colors.yellow,
                                Colors.green,
                                Colors.cyan,
                                Colors.blue,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
