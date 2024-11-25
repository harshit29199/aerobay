import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../logic/logic.dart';
import '../../../../utils/themes/styles.dart';

class UvIndexBox extends StatefulWidget {
  const UvIndexBox({super.key});

  @override
  State<UvIndexBox> createState() => _UvIndexBoxState();
}

class _UvIndexBoxState extends State<UvIndexBox> {
  String ss = "";
  double a1 = 0;
  double a2 = 0;
  double a3 = 0;
  double a4 = 0;
  double a5 = 0;
  double a6 = 0;
  @override
  Widget build(BuildContext context) {
    final logicProvider = Provider.of<LogicProvider>(context);
    ss = logicProvider.visibility;
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    // List<String> windl = logicProvider.UVL;
    // windl.add('0.0');
    // if (windl.isNotEmpty) {
    //   if (windl[0].isNotEmpty) {
    //     a1 = double.parse(windl[0]);
    //   }
    //   if (windl[1].isNotEmpty) {
    //     a2 = double.parse(windl[1]);
    //   }
    //   if (windl[2].isNotEmpty) {
    //     a3 = double.parse(windl[2]);
    //   }
    //   if (windl[3].isNotEmpty) {
    //     a4 = double.parse(windl[3]);
    //   }
    //   if (windl[4].isNotEmpty) {
    //     a5 = double.parse(windl[4]);
    //   }
    //   if (windl[5].isNotEmpty) {
    //     a6 = double.parse(windl[5]);
    //   }
    // }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      height: h * 0.43,
      width: w * 0.13,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "UV INDEX",
                style: AppStyle.instanse.defaultTextStyle(context, Colors.white,
                    fontWeight: FontWeight.w700, fontSize: w * 0.013),
              ),
            ],
          ),
          SizedBox(
            height: h * 0.35,
            child: SingleChildScrollView(
              child: uvIndexWidget(w, h, logicProvider),
            ),
          ),
        ],
      ),
    );
  }

  Widget uvIndexWidget(double w, double h, LogicProvider logicProvider) {
    List<String> windl = logicProvider.UVL;
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
    // windl.insert(0, "0.0");
    DateTime today = DateTime.now();
    List<String> daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    List<Map<String, dynamic>> uvData = [];

    // if (a1.toString().isNotEmpty &&
    //     a2.toString().isNotEmpty &&
    //     a3.toString().isNotEmpty &&
    //     a4.toString().isNotEmpty &&
    //     a5.toString().isNotEmpty &&
    //     a6.toString().isNotEmpty)
      List<double> aa = [3.1, a1, a2, a3, a4, a5, a6];
    // else
    //   List<double> aa = [3.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

    for (int i = 0; i < 7; i++) {
      DateTime currentDay = today.subtract(Duration(days: i));
      String dayOfWeek = daysOfWeek[currentDay.weekday % 7];
      uvData.add({
        'day': dayOfWeek,
        'color': i == 0 ? Colors.green : Colors.grey,
        // 'uv': (i + 1) * 1.5,
        'uv': aa[i],
      });
    }

    return Column(
      children: [
        for (var item in uvData)
          uvIndexItem(
              day: item['day'],
              color: item['color'],
              uv: item['uv'],
              w: w,
              h: h,
              logicProvider: logicProvider),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: w * 0.01,
            ),
            Text(
              "${logicProvider.uv} uv",
              style: TextStyle(
                fontSize: w * 0.0115,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String dayOfWeek = "";

  Color getColorForDay(String day) {
    switch (day) {
      case 'MON':
        return Colors.green;
      case 'TUE':
        return Colors.pinkAccent;
      case 'WED':
        return Colors.red;
      case 'THU':
        return Colors.orange;
      case 'FRI':
        return Colors.yellowAccent;
      case 'SAT':
        return Colors.green;
      case 'SUN':
        return Colors.orange;
      default:
        return Colors.grey; // Default color if day is not recognized
    }
  }

  Widget uvIndexItem(
      {required String day,
      required Color color,
      required double uv,
      required double w,
      required double h,
      required LogicProvider logicProvider}) {
    DateTime today = DateTime.now();
    dayOfWeek = DateFormat('EEE')
        .format(today)
        .toUpperCase(); // EEE gives abbreviated day name
    Color color = getColorForDay(day);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Align items vertically center
        children: [
          SizedBox(
            width: w * 0.001,
          ),
          // Day label
          SizedBox(
            // width: 18,
            // width: w * 0.0235,
            width: w * 0.025,
            child: day == dayOfWeek
                ? Text(
                    day,
                    // dayOfWeek,
                    style: TextStyle(
                      // fontSize: w * 0.013,
                      fontSize: w * 0.011,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    day,
                    // dayOfWeek,
                    style: TextStyle(
                      fontSize: w * 0.0094,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          // Vertically centered colored circle
          Row(
            children: [
              // SizedBox(width: 25,),
              Container(
                width: w * 0.0145,
                height: h * 0.04,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          // UV index value
          day == dayOfWeek
              ? SizedBox(
                  width: 28,
                  child: Text(
                    '${logicProvider.uv} uv',
                    style: TextStyle(
                      fontSize: w * 0.01,
                      color: Colors.white,
                    ),
                  ),
                )
              : SizedBox(
                  width: 28,
                  child: Text(
                    '$uv uv',
                    style: TextStyle(
                      fontSize: w * 0.01,
                      color: Colors.white,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// Widget uvIndexWidget(double w, double h, LogicProvider logicProvider) {
//   DateTime today = DateTime.now();
//   List<String> daysOfWeek = ['SUN','MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
//
//   List<Map<String, dynamic>> uvData = [];
//   List <double>aa=[2.1,2.1,2.1,2.1,2.1,2.1,2.1];
//   for (int i = 0; i < 7; i++) {
//     DateTime currentDay = today.subtract(Duration(days: i));
//     String dayOfWeek = daysOfWeek[currentDay.weekday % 7];
//     uvData.add({
//       'day': dayOfWeek,
//       'color': i == 0 ? Colors.green : Colors.grey,
//       // 'uv': (i + 1) * 1.5,
//       'uv': aa[i],
//     });
//   }
//
//   return Column(
//     children: [
//       for (var item in uvData)
//         uvIndexItem(
//           day: item['day'],
//           color: item['color'],
//           uv: item['uv'],
//           w: w,
//           h: h
//         ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: w * 0.01,
//           ),
//           Text(
//             "${aa[0]}uv",
//             style: TextStyle(
//               fontSize: w*0.0115,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }
//
// String dayOfWeek="";
//
// Color getColorForDay(String day) {
//   switch (day) {
//     case 'MON':
//       return Colors.green;
//     case 'TUE':
//       return Colors.pinkAccent;
//     case 'WED':
//       return Colors.red;
//     case 'THU':
//       return Colors.orange;
//     case 'FRI':
//       return Colors.yellowAccent;
//     case 'SAT':
//       return Colors.green;
//     case 'SUN':
//       return Colors.orange;
//     default:
//       return Colors.grey; // Default color if day is not recognized
//   }
// }
//
// Widget uvIndexItem({
//   required String day,
//   required Color color,
//   required double uv,
//   required double w,
//   required double h
// }) {
//   DateTime today = DateTime.now();
//   dayOfWeek = DateFormat('EEE').format(today).toUpperCase(); // EEE gives abbreviated day name
//   Color color = getColorForDay(day);
//
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically center
//       children: [
//         SizedBox(
//           width: w * 0.001,
//         ),
//         // Day label
//         SizedBox(
//           // width: 18,
//           // width: w * 0.0235,
//           width: w * 0.025,
//           child: day==dayOfWeek?Text(
//             day,
//             // dayOfWeek,
//             style: TextStyle(
//               // fontSize: w * 0.013,
//               fontSize: w * 0.011,
//               color:Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ):Text(
//             day,
//             // dayOfWeek,
//             style: TextStyle(
//               fontSize: w * 0.0094,
//               color: Colors.grey,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         // Vertically centered colored circle
//         Row(
//           children: [
//             // SizedBox(width: 25,),
//             Container(
//               width: w * 0.0145,
//               height: h * 0.04,
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ],
//         ),
//         // UV index value
//         day==dayOfWeek? SizedBox(
//           width: 28,
//           child: Text(
//             ' uv',
//             style: TextStyle(
//               fontSize: w * 0.01,
//               color: Colors.white,
//             ),
//           ),
//         ):SizedBox(
//           width: 28,
//           child: Text(
//             '$uv uv',
//             style: TextStyle(
//               fontSize: w * 0.01,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
