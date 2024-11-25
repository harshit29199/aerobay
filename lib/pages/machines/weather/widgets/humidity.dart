import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../logic/logic.dart';
import '../../../../utils/appcolors.dart';
import '../../../../utils/helper method/helper_methods.dart';
import '../../../../utils/resources/images.dart';
import '../../../../utils/themes/dimensions.dart';
import '../../../../utils/themes/styles.dart';


class HumidityBox extends StatefulWidget {
  const HumidityBox({super.key});

  @override
  State<HumidityBox> createState() => _HumidityBoxState();
}

class _HumidityBoxState extends State<HumidityBox> {
  @override
  Widget build(BuildContext context) {
    final logicProvider = Provider.of<LogicProvider>(context);
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    ///old
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
    //   height: h * 0.2,
    //   width: w * 0.23,
    //   decoration: BoxDecoration(
    //     border: Border.all(color: AppColor.instanse.oxBorderColor, width: 2),
    //     image: const DecorationImage(image: AssetImage(humidImage)),
    //     color: Color.fromRGBO(28, 37, 31, 0.5),
    //     borderRadius: BorderRadius.circular(10),
    //     boxShadow: const [
    //       BoxShadow(
    //         color: Colors.black26,
    //         blurRadius: 5,
    //         offset: Offset(0, 2),
    //       ),
    //     ],
    //   ),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text("HUMIDITY",
    //               style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
    //                   fontWeight: FontWeight.w700, fontSize: w * 0.013)),
    //           Spacer(),
    //           Text(logicProvider.hum, style: AppStyle.instanse.michromaFontTextStyle(
    //               textColor: AppColor.instanse.colorWhite,
    //               fontWeight: FontWeight.w700,
    //               fontSize: w * 0.013, context: context)),
    //           widthGap(w * 0.003),
    //           SizedBox(
    //               height: w * 0.02,
    //               width: w * 0.015,
    //               child: Image.asset(unithum)),
    //         ],
    //       ),
    //       Row(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.only(bottom: 4),
    //             child:
    //             // Text(
    //             //   "VERY HUMID",
    //             //   style: AppStyle.instanse.defaultTextStyle(
    //             //       fontSize: w * 0.011,
    //             //       context,
    //             //       AppColor.instanse.newTextColor,
    //             //       fontWeight: FontWeight.w400),
    //             // ),
    //             logicProvider.hum.isNotEmpty?
    //             int.parse(logicProvider.hum)>=0 && int.parse(logicProvider.hum)<205?
    //             Text(
    //               "VERY DRY",
    //               style: AppStyle.instanse.defaultTextStyle(
    //                   fontSize: w * 0.011,
    //                   context,
    //                   AppColor.instanse.newTextColor,
    //                   fontWeight: FontWeight.w400),
    //             ):int.parse(logicProvider.hum)>=205 && int.parse(logicProvider.hum)<410?Text(
    //               "DRY",
    //               style: AppStyle.instanse.defaultTextStyle(
    //                   fontSize: w * 0.011,
    //                   context,
    //                   AppColor.instanse.newTextColor,
    //                   fontWeight: FontWeight.w400),
    //             ): int.parse(logicProvider.hum)>=410 && int.parse(logicProvider.hum)<615?Text(
    //               "HUMID",
    //               style: AppStyle.instanse.defaultTextStyle(
    //                   fontSize: w * 0.011,
    //                   context,
    //                   AppColor.instanse.newTextColor,
    //                   fontWeight: FontWeight.w400),
    //             ):int.parse(logicProvider.hum)>=615 && int.parse(logicProvider.hum)<1024?Text(
    //                 "VERY HUMID",
    //                 style: AppStyle.instanse.defaultTextStyle(
    //                     fontSize: w * 0.011,
    //                     context,
    //                     AppColor.instanse.newTextColor,
    //                     fontWeight: FontWeight.w400)):
    //             Text('-'):Visibility(visible:false,child: Text('-')),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
    ///new
    return Container(
      height: h * 0.2,
      width: w * 0.23,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColor.instanse.blurFX.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Adjust the blur level as needed
          child: Stack(
              children: [
                Padding(
                  padding:
                  EdgeInsets.only(left: w * 0.07, top: h * 0.01, bottom: h * 0.01),
                  child: Image.asset(humidImage),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("HUMIDITY",
                              style: AppStyle.instanse.defaultTextStyle(
                                  context, Colors.white,
                                  fontWeight: FontWeight.w700, fontSize: w * 0.013)),
                          const Spacer(),
                          Text(logicProvider.hum,
                              style: AppStyle.instanse.michromaFontTextStyle(
                                  textColor: AppColor.instanse.colorWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: w * 0.013,
                                  context: context)),
                          widthGap(w * 0.003),
                          SizedBox(
                              height: w * 0.02,
                              width: w * 0.015,
                              child: Image.asset(unithum)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: logicProvider.hum.isNotEmpty?
                            int.parse(logicProvider.hum)>=0 && int.parse(logicProvider.hum)<205?
                            Text(
                              "VERY DRY",
                              style: AppStyle.instanse.defaultTextStyle(
                                  fontSize: w * 0.011,
                                  context,
                                  AppColor.instanse.newTextColor,
                                  fontWeight: FontWeight.w400),
                            ):int.parse(logicProvider.hum)>=205 && int.parse(logicProvider.hum)<410?Text(
                              "DRY",
                              style: AppStyle.instanse.defaultTextStyle(
                                  fontSize: w * 0.011,
                                  context,
                                  AppColor.instanse.newTextColor,
                                  fontWeight: FontWeight.w400),
                            ): int.parse(logicProvider.hum)>=410 && int.parse(logicProvider.hum)<615?Text(
                              "HUMID",
                              style: AppStyle.instanse.defaultTextStyle(
                                  fontSize: w * 0.011,
                                  context,
                                  AppColor.instanse.newTextColor,
                                  fontWeight: FontWeight.w400),
                            ):int.parse(logicProvider.hum)>=615 && int.parse(logicProvider.hum)<1024?Text(
                                "VERY HUMID",
                                style: AppStyle.instanse.defaultTextStyle(
                                    fontSize: w * 0.011,
                                    context,
                                    AppColor.instanse.newTextColor,
                                    fontWeight: FontWeight.w400)):
                            Text('-'):Visibility(visible:false,child: Text('-')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
