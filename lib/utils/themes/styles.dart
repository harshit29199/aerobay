import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../appcolors.dart';
import 'dimensions.dart';

class AppStyle {
  AppStyle._();
  static final instanse = AppStyle._();

  //black text style
  TextStyle michromaFontTextStyle(
      {required BuildContext context, double? fontSize, FontWeight? fontWeight, Color? textColor}) {
    double w = ResponsiveSize.width(context);
    double h = ResponsiveSize.height(context);
    return GoogleFonts.michroma(
        fontSize: fontSize ?? w * 0.035,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: textColor ?? AppColor.instanse.colorWhite);
  }

//black text style
  TextStyle appIconTextStyle(
      {required BuildContext context, double? fontSize, FontWeight? fontWeight, Color? textColor}) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
        fontSize: fontSize ?? w * 0.035,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: textColor ?? AppColor.instanse.colorWhite);
  }

//black text style
  TextStyle blackTextStyle({required BuildContext context, double? fontSize, FontWeight? fontWeight}) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
        fontSize: fontSize ?? w * 0.035,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: AppColor.instanse.colorBlack);
  }

// orange text style
  TextStyle orangeTextStyle({required BuildContext context, double? fontSize, FontWeight? fontWeight}) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
        fontSize: fontSize ?? w * 0.04,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: AppColor.instanse.colorPrimary);
  }

// Custom  text style
  TextStyle customTextStyle(
      {required BuildContext context, double? fontSize,
      FontWeight? fontWeight,
      TextDecoration? decoration,
      Color? color}) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
      color: color ?? AppColor.instanse.colorWhite,
      fontSize: fontSize ?? w * 0.03,
      fontWeight: fontWeight ?? FontWeight.w600,
      decoration: decoration ?? TextDecoration.none,
    );
  }

// white  text style
  TextStyle whiteTextStyle({required BuildContext context,
    double? fontSize,
    FontWeight? fontWeight,
    TextDecoration? decoration,
  }) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
      color: AppColor.instanse.colorWhite,
      fontSize: fontSize ?? w * 0.013,
      fontWeight: fontWeight ?? FontWeight.w600,
      decoration: decoration ?? TextDecoration.none,
    );
  }

  TextStyle navSelectedTextStyle({required BuildContext context,
    double? fontSize,
    FontWeight? fontWeight,
    TextDecoration? decoration,
  }) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
      color: AppColor.instanse.colorWhite,
      fontSize: fontSize ?? w * 0.028,
      fontWeight: fontWeight ?? FontWeight.w700,
      decoration: decoration ?? TextDecoration.none,
    );
  }

  TextStyle navUnSelectedTextStyle({required BuildContext context,
    double? fontSize,
    FontWeight? fontWeight,
    TextDecoration? decoration,
  }) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
      color: AppColor.instanse.colorPrimaryLight,
      fontSize: fontSize ?? w * 0.022,
      fontWeight: fontWeight ?? FontWeight.w400,
      decoration: decoration ?? TextDecoration.none,
    );
  }

// white  text style
  TextStyle whiteUnderlineTextStyle({required BuildContext context,
    double? fontSize,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
  }) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
      color: AppColor.instanse.colorWhite,
      fontSize: fontSize ?? w * 0.04,
      fontWeight: fontWeight ?? FontWeight.w600,
      decoration: decoration ?? TextDecoration.underline,
      decorationColor: decorationColor ?? AppColor.instanse.colorWhite,
      // Default color
      decorationThickness: decorationThickness ?? 1.5, // Default thickness
    );
  }

// grey text style
  TextStyle greyTextStyle({required BuildContext context, double? fontSize, FontWeight? fontWeight}) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
        color: AppColor.instanse.colorGrey,
        fontSize: fontSize ?? w * 0.035,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

// default text style
  TextStyle defaultTextStyle(BuildContext context, Color color,
      {double? fontSize, FontWeight? fontWeight}) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
        color: color,
        // decoration:TextDecoration.underline,
        fontSize: fontSize ?? w * 0.04,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  TextStyle defaultTextStyleWithUnderline(BuildContext context,Color color,
      {double? fontSize, FontWeight? fontWeight,Color? decorationColor}) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.urbanist(
        color: color,
        decoration:TextDecoration.underline,
        decorationColor:decorationColor,
        fontSize: fontSize ?? w * 0.04,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

// red text style
  TextStyle redTextStyle({required BuildContext context,double? fontSize, FontWeight? fontWeight}) {
    double w = ResponsiveSize.width(context);
    return TextStyle(
        color: AppColor.instanse.colorRed,
        fontSize: fontSize ?? w * 0.035,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  // microchroma font
// default text style
  TextStyle defaultMichromaTextStyle(BuildContext context,Color color,
      {double? fontSize, FontWeight? fontWeight}) {
    double w = ResponsiveSize.width(context);
    return GoogleFonts.michroma(
        color: color,
        fontSize: fontSize ?? w * 0.04,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

}

// for dashed under text
TextStyle defaultDashedTextStyle(BuildContext context,Color color,
    {double? fontSize, FontWeight? fontWeight}) {
  double w = ResponsiveSize.width(context);
  return GoogleFonts.urbanist(
      color: color,
      fontSize: fontSize ?? w * 0.04,
      fontWeight: fontWeight ?? FontWeight.w400);
}

