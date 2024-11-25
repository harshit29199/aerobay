import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'appcolors.dart';

class AppTheme {
   // Define your primary theme color
   Color primaryColor = const Color.fromRGBO(107, 122, 143, 1.0);
   Color primaryColor1 = const Color.fromRGBO(107, 122, 143, 0.5);
   Color appbarColor = Colors.grey.shade400;

   // Define your text styles
   TextStyle titleStyle = GoogleFonts.ubuntu(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w400,
   );

   TextStyle labelStyle = GoogleFonts.ubuntu(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500,
   );


   TextStyle innerUiStyle = GoogleFonts.ubuntu(
      color: AppColor.instanse.newEffect,
      fontSize: 10,
      fontWeight: FontWeight.w500,
   );


   TextStyle alabelStyle = GoogleFonts.ubuntu(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w400,
   );

   TextStyle suggestionText = GoogleFonts.ubuntu(
      color:AppColor.instanse.greyOnBlack,
      fontSize: 8,
      fontWeight: FontWeight.w400,
   );

TextStyle unselectedButtonTextStyle = GoogleFonts.ubuntu(
      color: AppColor.instanse.blurColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
   );

   TextStyle inputStyle = GoogleFonts.ubuntu(
      color: Colors.white,
      fontSize: 18,
   );


   TextStyle hintStyle = GoogleFonts.ubuntu(
      color: AppColor.instanse.greyOnBlack,
      fontSize: 12,
      fontWeight: FontWeight.w400
   );

   TextStyle abhintStyle = GoogleFonts.ubuntu(
      color: AppColor.instanse.blurColor,
      fontSize: 12,
      fontWeight: FontWeight.w400
   );
   
   TextStyle disableHintStyle = GoogleFonts.ubuntu(
      color: AppColor.instanse.greyOnBlack.withOpacity(0.3),
      fontSize: 12,
      fontWeight: FontWeight.w400
   );


   TextStyle newText = GoogleFonts.ubuntu(
      color: AppColor.instanse.colorWhite,
      fontSize: 12,
      fontWeight: FontWeight.w400
   );

   TextStyle newSetText = GoogleFonts.ubuntu(
      color: AppColor.instanse.greyOnWhite,
      fontSize: 12,
      fontWeight: FontWeight.w400
   );

   TextStyle smallTextStyle = GoogleFonts.ubuntu(
      decoration: TextDecoration.none,
      color:Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 12,
   );

   TextStyle smallTextStyleUnderLine = GoogleFonts.ubuntu(
      decoration: TextDecoration.underline,
      decorationColor: Colors.white,
      color:Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 10,
   );

   TextStyle smallTextStyleBold = GoogleFonts.ubuntu(
      decoration: TextDecoration.none,
      color:Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 10,
   );

   TextStyle primaryButtonTextSTyle = GoogleFonts.ubuntu(
      color:AppColor.instanse.blurColor,
      fontWeight: FontWeight.w400,
      fontSize: 12,
   );


   TextStyle buttonTextStyle = GoogleFonts.lato(
      color: Colors.black,
      fontSize: 14,
   );

   Color getColorFromHex(String hexColor) {
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 6) {
         hexColor = "FF" + hexColor;
      }
      return Color(int.parse("0x$hexColor"));
   }

   Color btn=Color.fromRGBO(216, 216, 216, 1);
   String title = "Welcome to AeroBay !!";
}
