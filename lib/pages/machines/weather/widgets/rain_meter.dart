import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../logic/logic.dart';
import '../../../../utils/appcolors.dart';
import '../../../../utils/resources/images.dart';
import '../../../../utils/themes/dimensions.dart';
import '../../../../utils/themes/styles.dart';


class RainMeter extends StatefulWidget {
  const RainMeter({super.key});

  @override
  State<RainMeter> createState() => _RainMeterState();
}

class _RainMeterState extends State<RainMeter> {
  @override
  Widget build(BuildContext context) {
    final logicProvider = Provider.of<LogicProvider>(context);
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      height: h * 0.23,
      width: w * 0.23,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.instanse.oxBorderColor, width: 2),
        // image: const DecorationImage(image: AssetImage(rainmeterImage)),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("RAIN METER",
                  style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                      fontWeight: FontWeight.w700, fontSize: w * 0.013)),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(logicProvider.rainValue, style: AppStyle.instanse.michromaFontTextStyle(
                      textColor: AppColor.instanse.colorWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.013, context: context)),
                  Text("cm", style: AppStyle.instanse.michromaFontTextStyle(
                      textColor: AppColor.instanse.colorWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.008, context: context)),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right:12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: h * 0.05,
                    ),
                    Text(
                      logicProvider.rainMax,
                      style: AppStyle.instanse.defaultTextStyle(
                          fontSize: w * 0.011,
                          context,
                          AppColor.instanse.newTextColor,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "7cm",
                      style: AppStyle.instanse.defaultTextStyle(
                          fontSize: w * 0.011,
                          context,
                          AppColor.instanse.newTextColor,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "JUNE 5",
                      style: AppStyle.instanse.defaultTextStyle(
                          fontSize: w * 0.01,
                          context,
                          AppColor.instanse.newTextColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                        height: w * 0.065,
                        width: w * 0.055,
                        child: Image.asset(rainmeterImage)),
                    // Container(
                    //   color: Colors.red,
                    //   height: w * 0.065,
                    //   width: w * 0.04,
                    // ),
                    SizedBox(
                      height: h * 0.01,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: h * 0.05,
                    ),
                    Text(
                      logicProvider.rainAvg,
                      style: AppStyle.instanse.defaultTextStyle(
                          fontSize: w * 0.01,
                          context,
                          AppColor.instanse.newTextColor,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "7cm",
                      style: AppStyle.instanse.defaultTextStyle(
                          fontSize: w * 0.01,
                          context,
                          AppColor.instanse.newTextColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: h * 0.05,
                    ),
                    Text(
                      logicProvider.rainTotal,
                      style: AppStyle.instanse.defaultTextStyle(
                          fontSize: w * 0.01,
                          context,
                          AppColor.instanse.newTextColor,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "12cm",
                      style: AppStyle.instanse.defaultTextStyle(
                          fontSize: w * 0.01,
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
