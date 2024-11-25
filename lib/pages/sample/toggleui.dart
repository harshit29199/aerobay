import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int value = 0;
  int? nullableValue;
  bool positive = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme.merge(
              data: const IconThemeData(color: Colors.white),
              child: AnimatedToggleSwitch<int>.rolling(
                current: value,
                values: const [0, 1],
                onChanged: (i) {
                  setState(() => value = i);
                },
                style: const ToggleStyle(
                  indicatorColor: Colors.white,
                  borderColor: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1.5),
                    )
                  ],
                ),
                indicatorIconScale: sqrt2,
                iconBuilder: coloredRollingIconBuilder,
                borderWidth: 3.0,
                styleAnimationType: AnimationType.onHover,
                styleBuilder: (value) => ToggleStyle(
                  backgroundColor: colorBuilder(value),
                  // borderRadius: BorderRadius.circular(value * 10.0),
                  borderRadius: BorderRadius.circular(30.0),
                  indicatorBorderRadius: BorderRadius.circular(30.0),
                  // indicatorBorderRadius: BorderRadius.circular(value * 10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color colorBuilder(int value) => switch (value) {
    0 => Colors.redAccent,
    1 => Colors.green,
    _ => Colors.red,
  };

  Widget coloredRollingIconBuilder(int value, bool foreground) {
    final color = foreground ? colorBuilder(value) : null;
    return Icon(
      iconDataByValue(value),
      color: color,
    );
  }

  IconData iconDataByValue(int? value) => switch (value) {
    0 => Icons.wifi_sharp,
    1 => Icons.wifi_sharp,
    _ => Icons.lightbulb_outline_rounded,
  };
}
