import 'package:flutter/material.dart';

class ScreenUtils {
  final BuildContext context;

  ScreenUtils(this.context);

  // Get screen width
  double get screenWidth => MediaQuery.of(context).size.width;

  // Get screen height
  double get screenHeight => MediaQuery.of(context).size.height;

  // Get screen's aspect ratio
  double get aspectRatio => MediaQuery.of(context).size.aspectRatio;

  // Get screen's orientation
  Orientation get orientation => MediaQuery.of(context).orientation;

  // Check if the screen is in portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  // Check if the screen is in landscape mode
  bool get isLandscape => orientation == Orientation.landscape;

  // Get status bar height
  double get statusBarHeight => MediaQuery.of(context).padding.top;

  // Get bottom navigation bar height
  double get bottomNavBarHeight => MediaQuery.of(context).padding.bottom;

  // Get a percentage of screen width
  double widthPercentage(double percent) => screenWidth * percent / 100;

  // Get a percentage of screen height
  double heightPercentage(double percent) => screenHeight * percent / 100;

  // Get a responsive font size based on screen width
  double get responsiveFontSize => screenWidth * 0.05;
}
