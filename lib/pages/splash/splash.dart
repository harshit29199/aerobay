import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../main.dart';
import '../../utils/appcolors.dart';
import '../../utils/images.dart';
import '../authorization/login.dart';
import '../home.dart';
import '../sample/joystickUI.dart';
import 'VideoWidget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 3;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var duration = Duration(seconds: splashDelay);
    return Timer(duration, checkFirstSeen);
  }

  Future checkFirstSeen() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check the shared preference value
    bool isFirstSeen = prefs.getBool('isLoggedIn') ?? false;
    String username = prefs.getString('aerobayUsername') ?? '';
    // Navigate based on the shared preference value
    if (isFirstSeen) {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) => HomePage(
                username: username,
                loggedin: isFirstSeen)), // Navigate to HomePage if logged in
      );
    } else {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                const LoginPage()), // Navigate to LoginPage if not logged in
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.instanse.bgColor, AppColor.instanse.bgOther],
          stops: const [0.1, 0.28],
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomLeft,
          tileMode: TileMode.repeated,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.instanse.borderWhite.withOpacity(0.12),
            border: Border.all(width: 1, color: AppColor.instanse.borderWhite),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Spacer for centering the image
              const Spacer(),
              // Center the image
              Image.asset(
                appfulllogo,
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.22,
              ),
              Spacer(),
              // Divider line
              Container(
                width: MediaQuery.of(context).size.width * 3,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColor.instanse.colorWhite,
                      Colors.transparent,
                    ],
                    end: Alignment.centerRight,
                    begin: Alignment.centerLeft,
                    tileMode: TileMode.repeated,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Gap between divider and text
              // Text below the image
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Note: ", style: aa.smallTextStyleBold),
                  Text(
                    "The enabled function of a machine continues to work even after exiting it",
                    style: aa.smallTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 20), // Bottom spacing
            ],
          ),
        ),
      ),
    );
  }
}
