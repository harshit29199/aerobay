
import 'package:flutter/material.dart';

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

/*Widget richTextWidget(
    {required BuildContext context,
      required String firstText,
      required String secondText,
      TextDecoration? decoration,
      required Function() onTap}) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.dMSans,
          color: AppColors.textDarkGrey),
      children: [
        TextSpan(
          text: firstText,
        ),
        const WidgetSpan(child: SizedBox(width: 3)),
        TextSpan(
          text: secondText,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: decoration,
            fontFamily: AppFonts.dMSans,
          ),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        ),
      ],
    ),
  );
}*/

/*Widget shimmerEffect({required Widget widget}) {
  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBaseColor,
    highlightColor: Colors.white,
    child: widget,
  );
}*/

/*showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(
          color: AppColors.primary,
        ),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: const TextWidget(text: "Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}*/

/*void showSnackBar({
  BuildContext? context,
  String? message,
  bool isSuccess = true,
}) {
  final snackBar = SnackBar(
    elevation: 6,
    duration: const Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
    content: Row(
      children: [
        isSuccess
            ? const Icon(Icons.check, color: AppColors.white)
            : const Icon(Icons.error_outline_rounded, color: AppColors.white),
        widthGap(10),
        Flexible(
            child: TextWidget(
              text: message ?? "",
              fontFamily: AppFonts.dMSans,
              color: AppColors.white,
              overflow: TextOverflow.fade,
            )),
      ],
    ),
    backgroundColor: isSuccess ? AppColors.green : AppColors.red,
  );
  ScaffoldMessenger.of(context!).showSnackBar(snackBar);
}*/

SizedBox widthGap(double width) {
  return SizedBox(
    width: width,
  );
}

/*extension ContainerShadowExtension on Container {
  Container withShadow(
      {Color shadowColor = const Color.fromRGBO(68, 160, 169, 0.2),
        double borderRadius = 8,
        double dx = 0.5,
        double dy = 0,
        Color color = AppColors.white,
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
}*/

extension EmptySpace on num {
  SizedBox get hh => SizedBox(height: toDouble());

  SizedBox get ww => SizedBox(width: toDouble());
}
