import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../all imports/allimports.dart';

const emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

Future<void> closeKeyBoard({required BuildContext context}) async {
  FocusScope.of(context).unfocus();
}

double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

SizedBox heightGap(double height) {
  return SizedBox(
    height: height,
  );
}

hideLoader(BuildContext context) {
  Navigator.of(context).pop();
}

Future<void> logOut({BuildContext? context}) async {}

SizedBox widthGap(double width) {
  return SizedBox(
    width: width,
  );
}

extension ContainerShadowExtension on Container {
  Container withShadow(
      {Color shadowColor = const Color.fromRGBO(68, 160, 169, 0.2),
      double borderRadius = 8,
      double dx = 0.5,
      double dy = 0,
      Color color = Colors.white,
      double spreadRadius = 5,
      BoxShape? shape,
      double blurRadius = 5}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: shape ?? BoxShape.rectangle,
        borderRadius: shape != BoxShape.circle
            ? BorderRadius.circular(borderRadius)
            : null,
        boxShadow: [
          BoxShadow(
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            offset: Offset(dx, dy),
            color: shadowColor,
          ),
        ],
      ),
      child: this,
    );
  }
}

extension EmptySpace on num {
  SizedBox get hh => SizedBox(height: toDouble());

  SizedBox get ww => SizedBox(width: toDouble());
}
