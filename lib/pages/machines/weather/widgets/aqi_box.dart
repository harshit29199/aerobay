
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../logic/logic.dart';
import '../../../../utils/appcolors.dart';
import '../../../../utils/resources/images.dart';
import '../../../../utils/themes/dimensions.dart';
import '../../../../utils/themes/styles.dart';
import '../AQI Screen/aqi_screen.dart';


class AqiBox extends StatefulWidget {
  const AqiBox({super.key});

  @override
  State<AqiBox> createState() => _AqiBoxState();
}

class _AqiBoxState extends State<AqiBox> {
  @override
  Widget build(BuildContext context) {
    final logicProvider = Provider.of<LogicProvider>(context);
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    return GestureDetector(
      onTap: () {
        String schoolNam=logicProvider.schoolName;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  AqiScreen(school:schoolNam),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        height: h * 0.35,
        width: w * 0.18,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.instanse.oxBorderColor, width: 2),
          // image: const DecorationImage(image: AssetImage(aqiImage)),
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
          // color: Colors.grey.shade800,
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
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AQI",
                style: AppStyle.instanse.defaultTextStyle(context,Colors.white,
                    fontWeight: FontWeight.w700, fontSize: w * 0.013)),
            Row(
              children: [
                SizedBox(width: w * 0.05,),
                SizedBox(
                  height: w * 0.07,
                    width: w * 0.07,
                    child: Image.asset(aqiImage)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: h * 0.04,),
                    logicProvider.aqi.isNotEmpty?
                    int.parse(logicProvider.aqi)>=0 && int.parse(logicProvider.aqi)<342?
                    Text(
                      "SATISFACTORY",
                      style:
                          AppStyle.instanse.whiteTextStyle(fontSize: w * 0.01, context: context),
                    ):int.parse(logicProvider.aqi)>=342 && int.parse(logicProvider.aqi)<683?Text(
                      "BEARABLE",
                      style:
                      AppStyle.instanse.whiteTextStyle(fontSize: w * 0.01, context: context),
                    ): int.parse(logicProvider.aqi)>=683 && int.parse(logicProvider.aqi)<1024?Text(
                      "HARMFUL",
                      style:
                      AppStyle.instanse.whiteTextStyle(fontSize: w * 0.01, context: context),
                    ):Text('-'):Visibility(visible:false,child: Text('-')),
                    Text(logicProvider.aqi,
                        style: AppStyle.instanse.whiteTextStyle(
                            fontSize: w * 0.021, fontWeight: FontWeight.w700, context: context)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
