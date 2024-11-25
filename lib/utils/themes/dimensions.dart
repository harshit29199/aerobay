// height and width of screen .................

// double w = 392.0;
// double h = 816.0;

import 'package:flutter/material.dart';

class ResponsiveSize {
  static double width(BuildContext context) => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;
}

// Usage:
// double w = ResponsiveSize.width(context);
// double h = ResponsiveSize.height(context);

// lattitude and longitude.......................
double lattitudeValue = 0.0;
double longitudeValue = 0.0;