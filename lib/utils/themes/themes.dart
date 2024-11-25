import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../appcolors.dart';
import 'dimensions.dart';

ThemeData themeData(context) {
  double w = ResponsiveSize.width(context);
  double h = ResponsiveSize.height(context);
  return ThemeData(
      scaffoldBackgroundColor: AppColor.instanse.colorWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.instanse.colorPrimary.withOpacity(0.1),
      ),
      primaryColor: AppColor.instanse.colorWhite,
      useMaterial3: true,
      // userMaterial3 used only in flutter 3.10 and above

      appBarTheme: AppBarTheme(
        titleSpacing: -2,
        centerTitle: true,
        backgroundColor: AppColor.instanse.colorWhite,
        elevation: 0.0,
        titleTextStyle: GoogleFonts.lato(
            color: AppColor.instanse.colorBlack,
            fontSize: w * 0.04,
            fontWeight: FontWeight.w600),
        iconTheme: IconThemeData(
          color: AppColor.instanse.colorBlack, //change your color here
        ),
      ));
}
