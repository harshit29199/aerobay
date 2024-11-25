import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../logic/logic.dart';
import '../../../../utils/appcolors.dart';
import '../../../../utils/resources/images.dart';
import '../../../../utils/themes/dimensions.dart';
import '../../../../utils/themes/styles.dart';

class VisibilityBox extends StatefulWidget {
  const VisibilityBox({super.key});

  @override
  State<VisibilityBox> createState() => _VisibilityBoxState();
}

class _VisibilityBoxState extends State<VisibilityBox> {
  @override
  Widget build(BuildContext context) {
    final logicProvider = Provider.of<LogicProvider>(context);
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    double a1=0;
    double a2=0;
    double a3=0;
    double a4=0;
    double a5=0;
    double a6=0;
    List <String>windl=logicProvider.VisiL;
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

    List<String> days = ['TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN', 'MON'];
    String currentDay = DateFormat('EEE').format(DateTime.now()).toUpperCase();

    // Find the index of the current day
    int currentIndex = days.indexOf(currentDay);

    // Rearrange the list: take elements from the current day to the end, followed by the ones before it
    days = days.sublist(currentIndex + 1) + days.sublist(0, currentIndex + 1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      height: h * 0.26,
      // width: w * 0.3,
      width: w * 0.33,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.instanse.oxBorderColor, width: 2),
        // image: const DecorationImage(image: AssetImage(visibilityImage)),
        gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF34184f),
              Color(0xFF361a4f),
              Color(0xFF563d81),
              Color(0xFF5b36a2),
              Color(0xFF6037af),
            ]),
        color: Colors.blueGrey[900],
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("VISIBILITY",
                  style: AppStyle.instanse.defaultTextStyle(
                      context, Colors.white,
                      fontWeight: FontWeight.w700, fontSize: w * 0.013)),

              // Text("2 LUX",
              //     style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
              //         fontWeight: FontWeight.w600, fontSize: w * 0.008)),
              // Text("4 LUX",
              //     style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
              //         fontWeight: FontWeight.w600, fontSize: w * 0.008)),
              // Text("5 LUX",
              //     style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
              //         fontWeight: FontWeight.w600, fontSize: w * 0.008)),
              // Text("3 LUX",
              //     style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
              //         fontWeight: FontWeight.w600, fontSize: w * 0.008)),
              // Text("6 LUX",
              //     style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
              //         fontWeight: FontWeight.w600, fontSize: w * 0.008)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(logicProvider.visibility,
                      style: AppStyle.instanse.michromaFontTextStyle(
                          textColor: AppColor.instanse.colorWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: w * 0.013,
                          context: context)),
                  Column(
                    children: [
                      SizedBox(
                          height: w * 0.02,
                          width: w * 0.015,
                          child: Image.asset(unitvis)),
                      Text("lux",
                          style: AppStyle.instanse.michromaFontTextStyle(
                              textColor: AppColor.instanse.colorWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: w * 0.008,
                              context: context)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: h * 0.01),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: w * 0.02,
                    ),
                    Column(
                      children: [
                        Text("${a6.toInt()} LUX",
                            style: AppStyle.instanse.defaultTextStyle(
                                context, Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: w * 0.008)),
                        SizedBox(
                            height: h * 0.1,
                            width: w * 0.012,
                            child: Transform.scale(
                                scale: 2.2, child: Image.asset(visi3))),
                      ],
                    ),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    Column(
                      children: [
                        Text("${a5.toInt()} LUX",
                            style: AppStyle.instanse.defaultTextStyle(
                                context, Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: w * 0.008)),
                        SizedBox(
                          height: h * 0.07,
                        ),
                        SizedBox(
                            height: h * 0.03,
                            width: w * 0.012,
                            child: Image.asset(visi1)),
                      ],
                    ),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    Column(
                      children: [
                        Text("${a4.toInt()} LUX",
                            style: AppStyle.instanse.defaultTextStyle(
                                context, Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: w * 0.008)),
                        SizedBox(
                          height: h * 0.04,
                        ),
                        SizedBox(
                            height: h * 0.05,
                            width: w * 0.012,
                            child: Transform.scale(
                                scale: 1.5, child: Image.asset(visi2))),
                      ],
                    ),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    Column(
                      children: [
                        Text("${a3.toInt()} LUX",
                            style: AppStyle.instanse.defaultTextStyle(
                                context, Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: w * 0.008)),
                        SizedBox(
                            height: h * 0.1,
                            width: w * 0.012,
                            child: Transform.scale(
                                scale: 2.2, child: Image.asset(visi3))),
                      ],
                    ),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    Column(
                      children: [
                        Text("${a2.toInt()} LUX",
                            style: AppStyle.instanse.defaultTextStyle(
                                context, Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: w * 0.008)),
                        SizedBox(
                            height: h * 0.1,
                            width: w * 0.012,
                            child: Transform.scale(
                                scale: 2.2, child: Image.asset(visi3))),
                      ],
                    ),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    Column(
                      children: [
                        Text("${a1.toInt()} LUX",
                            style: AppStyle.instanse.defaultTextStyle(
                                context, Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: w * 0.008)),
                        SizedBox(
                            height: h * 0.1,
                            width: w * 0.012,
                            child: Transform.scale(
                                scale: 2.2, child: Image.asset(visi3))),
                      ],
                    ),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    Column(
                      children: [
                        Text("${logicProvider.visibility} LUX",
                            style: AppStyle.instanse.defaultTextStyle(
                                context, Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: w * 0.008)),
                        SizedBox(
                            height: h * 0.1,
                            width: w * 0.012,
                            child: Transform.scale(
                                scale: 2.2,
                                child: logicProvider.visibility.isNotEmpty
                                    ? int.parse(logicProvider.visibility) > 0 &&
                                            int.parse(
                                                    logicProvider.visibility) <
                                                3
                                        ? Image.asset(visi1)
                                        : int.parse(logicProvider.visibility) >
                                                    2 &&
                                                int.parse(logicProvider
                                                        .visibility) <
                                                    6
                                            ? Image.asset(visi2)
                                            : int.parse(logicProvider
                                                            .visibility) >
                                                        5 &&
                                                    int.parse(logicProvider
                                                            .visibility) <
                                                        8
                                                ? Image.asset(visi3)
                                                : Visibility(
                                                    visible: false,
                                                    child: Image.asset(visi3))
                                    : Visibility(
                                        visible: false,
                                        child: Image.asset(visi1)))),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // width: w * 0.26,
                      width: w * 0.3,
                      height: h * 0.0008,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.01,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // "JUNE 01  JUNE 02  JUNE 03  JUNE 04  JUNE 05  JUNE 06",
                      "${days[0]}       ${days[1]}        ${days[2]}       ${days[3]}       ${days[4]}       ${days[5]}       ${days[6]}",
                      style: AppStyle.instanse.defaultTextStyle(
                          fontSize: w * 0.0105,
                          context,
                          AppColor.instanse.newTextColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
