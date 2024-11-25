import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../logic/logic.dart';
import '../../../../utils/appcolors.dart';
import '../../../../utils/helper method/helper_methods.dart';
import '../../../../utils/themes/dimensions.dart';
import '../../../../utils/themes/styles.dart';


class AtmBox extends StatefulWidget {
  const AtmBox({super.key});

  @override
  State<AtmBox> createState() => _AtmBoxState();
}

class _AtmBoxState extends State<AtmBox> {
  @override
  Widget build(BuildContext context) {
    final logicProvider = Provider.of<LogicProvider>(context);
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    final ValueNotifier<double> valueNotifier = ValueNotifier(0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      height: h * 0.43,
      width: w * 0.21,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.instanse.oxBorderColor, width: 2),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ATM",
                  style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                      fontWeight: FontWeight.w700, fontSize: w * 0.013)),

              logicProvider.atmDirection.isNotEmpty? Text(logicProvider.atmDirection,
                  style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                      fontWeight: FontWeight.w700, fontSize: w * 0.013)):Text("-",
                  style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                      fontWeight: FontWeight.w700, fontSize: w * 0.013)),
            ],
          ),
          Center(
            child: SizedBox(
              height: h * 0.27,
              width: h * 0.27,
              child: DashedCircularProgressBar.aspectRatio(
                animationCurve: Curves.linear,
                aspectRatio: 1,
                valueNotifier: valueNotifier,
                startAngle: 270,
                progress: logicProvider.atmValue.isNotEmpty?double.parse(logicProvider.atmValue):0,
                maxProgress: 3600,
                corners: StrokeCap.round,
                foregroundColor: const Color(0xFFffd964),
                backgroundColor: Colors.white.withOpacity(0.05),
                foregroundStrokeWidth: 10,
                backgroundStrokeWidth: 10,
                animation: true,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: valueNotifier,
                        builder: (_, double value, __) =>
                        logicProvider.atmValue.isNotEmpty?     Text(
                          '${int.parse(logicProvider.atmValue)}',
                          style: TextStyle(
                              color: const Color(0xFFffd964),
                              fontWeight: FontWeight.w900,
                              fontSize: w * 0.013),
                        ): Text(
                          '-',
                          style: TextStyle(
                              color: const Color(0xFFffd964),
                              fontWeight: FontWeight.w900,
                              fontSize: w * 0.013),
                        ),
                      ),
                      widthGap(w * 0.01),
                      Text("Pa",
                          style: AppStyle.instanse.michromaFontTextStyle(context: context,
                              textColor: AppColor.instanse.colorWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: w * 0.013)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("LONGITUDE",
                  style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                      fontWeight: FontWeight.w700, fontSize: w * 0.012)),
              logicProvider.atmLong.isNotEmpty?  Text("${ logicProvider.atmLong}",
                  style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                      fontWeight: FontWeight.w400, fontSize: w * 0.011)):Text("-",
                  style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                      fontWeight: FontWeight.w400, fontSize: w * 0.011)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("LATITUDE",
                  style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                      fontWeight: FontWeight.w700, fontSize: w * 0.012)),
              logicProvider.atmLong.isNotEmpty?  Text("${logicProvider.atmLat}",
                  style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                      fontWeight: FontWeight.w400, fontSize: w * 0.011)): Text("-",
                  style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                      fontWeight: FontWeight.w400, fontSize: w * 0.011)),
            ],
          ),
        ],
      ),
    );
  }
}
