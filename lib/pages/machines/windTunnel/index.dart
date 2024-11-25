import 'dart:ui';
import 'package:ssss/pages/machines/windTunnel/permissionCheck.dart';
import 'package:ssss/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../../../logic/JoystickProvider2.dart';
import '../../../main.dart';
import '../../../utils/appcolors.dart';
import '../../../utils/helpermethods.dart';
import '../../extra/outlineborder.dart';
import '../../extra/outlineglowborder.dart';


class WindPage extends StatefulWidget {
  const WindPage({super.key});

  @override
  State<WindPage> createState() => _CarPageState();
}

class _CarPageState extends State<WindPage> {
  TextEditingController _oavBoxController = TextEditingController();
  double _aoasliderValue = 0.0;
  double _suctionsliderValue = 0.0;
  double _airflowsliderValue = 0.0;
  double _axisysliderValue = 0.0;
  double _axisxsliderValue = 0.0;
  double _axialmotionsliderValue = 0.0;
  bool isPressed = false;
  bool isPressed1 = false;
  bool isPressed2 = false;
  bool isPressed3 = false;
  bool isPressed4 = false;
  bool isPressed5 = false;
  bool isPressed6 = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final joystickProvider = Provider.of<JoystickProvider2>(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/windbg.png',
              fit: BoxFit.cover,
            ),
          ),
          // BackdropFilter for the blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              color: Colors.black.withOpacity(0.1), // Optional: Overlay color
            ),
          ),
          // Centered container with rounded rectangle
          Center(
            child: Container(
              // padding: EdgeInsets.all(8.0),
              ///align issue
              padding: EdgeInsets.all(screenHeight * 0.022),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                border:
                Border.all(color: Colors.white, width: 1), // White border
              ),
              width: screenWidth * 0.94, // Width of the container
              height: screenHeight * 0.9, // Height of the container
              child: Stack(
                children: [
                  // Top center text "RC Car"
                  Positioned(
                    // top: 20,
                    // left: screenWidth * 0.5 - 70, // Center horizontally
                    top: screenWidth * 0.027,
                    left: screenWidth * 0.37,
                    child: Text(
                      "Wind Tunnel",
                      style: TextStyle(
                        // fontSize: 24,
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // 5 sliders
                  ///slider1 aligned
                  Positioned(
                    top: screenHeight * 0.269,
                    // bottom: 10,
                    ///align issue
                    bottom: screenHeight * 0.025,
                    left: screenWidth * 0.023,
                    child: UnicornOutlineButtonGlow(
                      radius: 10,
                      strokeWidth: 4,
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(36, 187, 68, 0.2),
                          Color.fromRGBO(24, 184, 196, 1),
                          Color.fromRGBO(36, 187, 68, 0.2),
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: screenHeight * 0.7,
                        width: screenWidth * 0.064,
                      ),
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.827,
                    top: 0,
                    height: screenHeight * 0.86,
                    width: screenWidth * 0.07,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.024),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 42.0,
                            thumbShape: const CustomSliderThumbShape(
                                enabledThumbRadius:
                                14.0), // Custom thumb shape
                            overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 0.0),
                            activeTrackColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            trackShape: CustomRoundedRectSliderTrackShape(
                                radius: 8.0),
                          ),
                          child: Slider(
                            value: _aoasliderValue,
                            min: -90.0,
                            max: 90.0,
                            divisions: 181,
                            onChanged: (value) {
                              Vibration.vibrate();
                              setState(() {
                                _aoasliderValue = value;
                                print("angle of attack");
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    // child: Container(color: Colors.red,),
                  ),
                  Positioned(
                    top: screenWidth * 0.15,
                    left: screenWidth * 0.045,
                    child: Text(
                      '90',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.045,
                    bottom: screenWidth * 0.024,
                    child: Text(
                      _aoasliderValue.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  // Fixed text "Camera" in the center of the track
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.4,
                    left: screenWidth * 0.09,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Angle of Attack',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  ///slider2 aligned
                  Positioned(
                    top: screenHeight * 0.269,
                    left: screenWidth * 0.13,
                    bottom: screenHeight * 0.025,
                    child: UnicornOutlineButtonGlow(
                      radius: 10,
                      strokeWidth: 4,
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(36, 187, 68, 0.2),
                          Color.fromRGBO(24, 184, 196, 1),
                          Color.fromRGBO(36, 187, 68, 0.2),
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: screenHeight * 0.7,
                        width: screenWidth * 0.064,
                      ),
                    ),
                  ),
                  Positioned(
                    // right: 0,
                    top: screenWidth * 0,
                    // bottom: 0,
                    left: screenWidth * 0.132,
                    height: screenHeight * 0.86,
                    width: screenWidth * 0.06,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.024),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 42.0,
                            thumbShape: const CustomSliderThumbShape(
                                enabledThumbRadius: 14.0), // Custom thumb shape
                            overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 0.0),
                            activeTrackColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            trackShape:
                            CustomRoundedRectSliderTrackShape(radius: 8.0),
                          ),
                          child: Slider(
                            value: _axialmotionsliderValue,
                            min: -90.0,
                            max: 90.0,
                            divisions: 181,
                            onChanged: (value) {
                              Vibration.vibrate();
                              setState(() {
                                _axialmotionsliderValue = value;
                                print("axial motion");
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.15,
                    top: screenWidth * 0.15,
                    child: Text(
                      '90',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.15,
                    bottom: screenWidth * 0.024,
                    child: Text(
                      _axialmotionsliderValue.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  // Fixed text "Driller" in the center of the track
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.3,
                    left: screenWidth * 0.2,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Axial Motion',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  ///slider3 aligned
                  Positioned(
                    top: screenHeight * 0.269,
                    left: screenWidth * 0.24,
                    bottom: screenHeight * 0.025,
                    child: UnicornOutlineButtonGlow(
                      radius: 10,
                      strokeWidth: 4,
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(36, 187, 68, 0.2),
                          Color.fromRGBO(24, 184, 196, 1),
                          Color.fromRGBO(36, 187, 68, 0.2),
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: screenHeight * 0.7,
                        width: screenWidth * 0.064,
                      ),
                    ),
                  ),
                  Positioned(
                    // right: 0,
                    top: screenWidth * 0,
                    // bottom: 0,
                    left: screenWidth * 0.237,
                    height: screenHeight * 0.86,
                    width: screenWidth * 0.07,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.024),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 42.0,
                            thumbShape: const CustomSliderThumbShape(
                                enabledThumbRadius: 14.0), // Custom thumb shape
                            overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 0.0),
                            activeTrackColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            trackShape:
                            CustomRoundedRectSliderTrackShape(radius: 8.0),
                          ),
                          child: Slider(
                            value: _axisxsliderValue,
                            min: -90.0,
                            max: 90.0,
                            divisions: 181,
                            onChanged: (value) {
                              Vibration.vibrate();
                              setState(() {
                                _axisxsliderValue = value;
                                print("axis x");
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.262,
                    top: screenWidth * 0.15,
                    child: Text(
                      '90',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.26,
                    bottom: screenWidth * 0.024,
                    child: Text(
                      _axisxsliderValue.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  // Fixed text "Driller" in the center of the track
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.1,
                    left: screenWidth * 0.31,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Axis X',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  ///slider4
                  Positioned(
                    top: screenHeight * 0.269,
                    bottom: screenHeight * 0.025,
                    left: screenWidth * 0.595,
                    child: UnicornOutlineButtonGlow(
                      radius: 10,
                      strokeWidth: 4,
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(36, 187, 68, 0.2),
                          Color.fromRGBO(24, 184, 196, 1),
                          Color.fromRGBO(36, 187, 68, 0.2),
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: screenHeight * 0.7,
                        width: screenWidth * 0.064,
                      ),
                    ),
                  ),
                  Positioned(
                    // right: 0,
                    top: screenWidth * 0,
                    // bottom: 0,
                    left: screenWidth * 0.592,
                    height: screenHeight * 0.86,
                    width: screenWidth * 0.07,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.024),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 42.0,
                            thumbShape: const CustomSliderThumbShape(
                                enabledThumbRadius: 14.0), // Custom thumb shape
                            overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 0.0),
                            activeTrackColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            trackShape:
                            CustomRoundedRectSliderTrackShape(radius: 8.0),
                          ),
                          child: Slider(
                            value: _axisysliderValue,
                            min: -90.0,
                            max: 90.0,
                            divisions: 181,
                            onChanged: (value) {
                              Vibration.vibrate();
                              setState(() {
                                _axisysliderValue = value;
                                print("axisy");
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenWidth * 0.15,
                    left: screenWidth * 0.616,
                    child: Text(
                      '90',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.618,
                    bottom: screenWidth * 0.024,
                    child: Text(
                      _axisysliderValue.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  // Fixed text "Gripper" in the center of the track
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2,
                    left: MediaQuery.of(context).size.width / 1.5,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Axis Y',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  ///slider5
                  Positioned(
                    top: screenHeight * 0.269,
                    bottom: screenHeight * 0.025,
                    left: screenWidth * 0.71,
                    child: UnicornOutlineButtonGlow(
                      radius: 10,
                      strokeWidth: 4,
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(36, 187, 68, 0.2),
                          Color.fromRGBO(24, 184, 196, 1),
                          Color.fromRGBO(36, 187, 68, 0.2),
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: screenHeight * 0.7,
                        width: screenWidth * 0.064,
                      ),
                    ),
                  ),
                  Positioned(
                    // right: 0,
                    top: screenWidth * 0,
                    // bottom: 0,
                    left: screenWidth * 0.707,
                    height: screenHeight * 0.86,
                    width: screenWidth * 0.07,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.024),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 42.0,
                            thumbShape: const CustomSliderThumbShape(
                                enabledThumbRadius: 14.0), // Custom thumb shape
                            overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 0.0),
                            activeTrackColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            trackShape:
                            CustomRoundedRectSliderTrackShape1(radius: 8.0),
                          ),
                          child: Slider(
                            value: _airflowsliderValue,
                            // value: _camerasliderValue,
                            min: 0.0,
                            max: 100.0,
                            divisions: 100,
                            onChanged: (value) {
                              Vibration.vibrate();
                              setState(() {
                                _airflowsliderValue = value;
                                print("airflow");
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenWidth * 0.15,
                    left: screenWidth * 0.728,
                    child: Text(
                      '100',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.735,
                    bottom: screenWidth * 0.024,
                    child: Text(
                      _airflowsliderValue.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  // Fixed text "Arm 1" in the center of the track
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.1,
                    left: MediaQuery.of(context).size.width / 1.28,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Air Flow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  ///slider6
                  Positioned(
                    top: screenHeight * 0.269,
                    bottom: screenHeight * 0.025,
                    left: screenWidth * 0.82,
                    child: UnicornOutlineButtonGlow(
                      radius: 10,
                      strokeWidth: 4,
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(36, 187, 68, 0.2),
                          Color.fromRGBO(24, 184, 196, 1),
                          Color.fromRGBO(36, 187, 68, 0.2),
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: screenHeight * 0.7,
                        width: screenWidth * 0.064,
                      ),
                    ),
                  ),
                  Positioned(
                    // right: 0,
                    top: screenWidth * 0,
                    // bottom: 0,
                    left: screenWidth * 0.817,
                    height: screenHeight * 0.86,
                    width: screenWidth * 0.07,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.024),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 42.0,
                            thumbShape: const CustomSliderThumbShape(
                                enabledThumbRadius: 14.0), // Custom thumb shape
                            overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 0.0),
                            activeTrackColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            trackShape:
                            CustomRoundedRectSliderTrackShape1(radius: 8.0),
                          ),
                          child: Slider(
                            value: _suctionsliderValue,
                            // value: _camerasliderValue,
                            min: 0.0,
                            max: 100.0,
                            divisions: 100,
                            onChanged: (value) {
                              // Vibration.vibrate(duration: 15, amplitude: 8);
                              Vibration.vibrate();
                              setState(() {
                                _suctionsliderValue = value;
                                print("suction");
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenWidth * 0.15,
                    left: screenWidth * 0.837,
                    child: Text(
                      '100',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.843,
                    bottom: screenWidth * 0.024,
                    child: Text(
                      _suctionsliderValue.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.016,
                      ),
                    ),
                  ),
                  // Fixed text "Arm 2" in the center of the track
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.1,
                    // left: MediaQuery.of(context).size.width / 1,
                    right: screenWidth * 0.0008,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Suction',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  ///adjust code
                  Positioned(
                      top: 0,
                      bottom: screenHeight * 0.58,
                      right: screenWidth * 0.02,
                      left:screenWidth * 0.02 ,
                      child: Container(
                        color: Colors.transparent,
                      )
                  ),
                  /// Top right two square containers with asset images
                  Positioned(
                    // top: 16,
                    // right: 16,
                    top: screenHeight * 0.04,
                    right: screenHeight * 0.04,
                    child: Row(
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => carPermissionPage(),
                        //       ),
                        //     );
                        //   },
                        //   child: Container(
                        //     height: screenHeight * 0.14,
                        //     width: screenHeight * 0.14,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(10),
                        //       border: Border.all(color: Colors.white, width: 1),
                        //       image: DecorationImage(
                        //         image: AssetImage(
                        //             'assets/images/pair.png'), // Replace with your asset image
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   height: screenHeight * 0.14,
                        //   width: screenWidth * 0.065,
                        //   decoration: BoxDecoration(
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.5),
                        //         spreadRadius: 1,
                        //         blurRadius: 8,
                        //         offset: const Offset(3, 3),
                        //       ),
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.05),
                        //         spreadRadius: 1,
                        //         blurRadius: 15,
                        //         offset: const Offset(-1, -1),
                        //       ),
                        //     ],
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(10),
                        //     border:
                        //     Border.all(color: Colors.white, width: 1),
                        //     image: const DecorationImage(
                        //       image: AssetImage(
                        //           'assets/images/pair.png'), // Replace with your asset image
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        //   child: Material(
                        //       color: Colors.transparent,
                        //       child: InkWell(
                        //         onTap: (){
                        //           Vibration.vibrate(duration: 140);
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => windPermissionPage(),
                        //             ),
                        //           );
                        //         },
                        //         onTapDown: (_) {
                        //           setState(() => isPressed2 = true); // Change state to pressed
                        //         },
                        //         onTapUp: (_) {
                        //           setState(() => isPressed2 = false); // Change state back on release
                        //         },
                        //         onTapCancel: () {
                        //           setState(() => isPressed2 = false); // Ensure button resets if tap is canceled
                        //         },
                        //         splashColor: AppColor.instanse
                        //             .redSplashEffect, //Customize splash color
                        //         borderRadius: BorderRadius.circular(10),
                        //       )
                        //   ),
                        // ),
                        SizedBox(
                            width:
                            screenHeight * 0.03), // Spacing between images
                        Container(
                          height: screenHeight * 0.14,
                          width: screenHeight * 0.14,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            color: isPressed1 ? Colors.grey[300] : Colors.white, // Changes color on press
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isPressed1 // Adds shadow to simulate press effect
                                ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(2, 2),
                              )
                            ]
                                : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(3, 3),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: const Offset(-1, -1),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                                Vibration.vibrate();
                              },
                              onTapDown: (_) {
                                setState(() => isPressed1 = true); // Change state to pressed
                              },
                              onTapUp: (_) {
                                setState(() => isPressed1 = false); // Change state back on release
                              },
                              onTapCancel: () {
                                setState(() => isPressed1 = false); // Ensure button resets if tap is canceled
                              },
                              splashColor: Colors.redAccent.withOpacity(0.3), // Customize splash color
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Image.asset("assets/images/homearrow.png"),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  /// Top left circular container with asset image
                  Positioned(
                      top: screenHeight * 0.04,
                      left: screenHeight * 0.04,
                      child: Container(
                        height: screenHeight * 0.14,
                        width: screenHeight * 0.14,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          color: isPressed ? Colors.grey[300] : Colors.white, // Changes color on press
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isPressed // Adds shadow to simulate press effect
                              ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(2, 2),
                            )
                          ]
                              : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(3, 3),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: const Offset(-1, -1),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onLongPress: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => windPermissionPage(),
                                ),
                              );
                            },
                            onTap: (){
                              Vibration.vibrate();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.35,
                                        vertical: 3),
                                    elevation: 2.0,
                                    backgroundColor: Colors.red,
                                    content: const Text(
                                        'Please pair to the device first')),
                              );
                            },
                            onTapDown: (_) {
                              setState(() => isPressed = true); // Change state to pressed
                            },
                            onTapUp: (_) {
                              setState(() => isPressed = false); // Change state back on release
                            },
                            onTapCancel: () {
                              setState(() => isPressed = false); // Ensure button resets if tap is canceled
                            },
                            splashColor: Colors.redAccent.withOpacity(0.3), // Customize splash color
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: Image.asset(bluetoothOffIcon,height:screenHeight*0.11),
                            ),
                          ),
                        ),
                      )
                  ),
                  /// center container with 4 button
                  Positioned(
                    top: screenHeight * 0.3,
                    left: screenHeight * 0.73,
                    child: UnicornOutlineButton(
                      radius: 16,
                      strokeWidth: 4,
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.7,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          AppColor.instanse.newGradient,
                        ],
                        stops: const [0.5, 0.6, 1.0],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(7),
                        padding: const EdgeInsets.all(5),
                        // height: screenHeight * 0.55,
                        height: screenHeight * 0.455,
                        // width: screenWidth * 0.26,
                        width: screenWidth * 0.215,
                        decoration: BoxDecoration(
                            color: AppColor.instanse.borderWhite.withOpacity(0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: screenHeight * 0.19,
                                  width: screenWidth * 0.09,
                                  decoration: BoxDecoration(
                                    // color: AppColor.instanse.newWhite,
                                    // borderRadius: BorderRadius.circular(10),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.1),
                                    //     offset: const Offset(5, 5),
                                    //     blurRadius: 8,
                                    //     spreadRadius: 1,
                                    //   ),
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.1),
                                    //     offset: const Offset(5, 5),
                                    //     blurRadius: 8,
                                    //     spreadRadius: 1,
                                    //   ),
                                    // ],
                                    ///
                                    border: Border.all(color: Colors.white, width: 1),
                                    color: isPressed4 ? Colors.grey[300] : Colors.white, // Changes color on press
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isPressed4 // Adds shadow to simulate press effect
                                        ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(2, 2),
                                      )
                                    ]
                                        : [],
                                  ),
                                  child: InkWell(
                                    onTap: (){
                                      Vibration.vibrate();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.35,
                                                vertical: 3),
                                            elevation: 2.0,
                                            backgroundColor: Colors.red,
                                            content: const Text(
                                                'Please pair to the device first')),
                                      );
                                    },
                                    onTapDown: (_) {
                                      setState(() => isPressed4 = true); // Change state to pressed
                                    },
                                    onTapUp: (_) {
                                      setState(() => isPressed4 = false); // Change state back on release
                                    },
                                    onTapCancel: () {
                                      setState(() => isPressed4 = false); // Ensure button resets if tap is canceled
                                    },
                                    splashColor: Colors.redAccent.withOpacity(0.3), // Customize splash color
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/led.png",
                                          height: screenHeight * 0.085,
                                        ),
                                        heightGap(screenHeight * 0.01),
                                        Text(
                                          "LED",
                                          style: aa.innerUiStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.19,
                                  width: screenWidth * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 1),
                                    color: isPressed5 ? Colors.grey[300] : Colors.white, // Changes color on press
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isPressed5 // Adds shadow to simulate press effect
                                        ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(2, 2),
                                      )
                                    ]
                                        : [],
                                  ),
                                  child: InkWell(
                                    onTap: (){
                                      Vibration.vibrate();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.35,
                                                vertical: 3),
                                            elevation: 2.0,
                                            backgroundColor: Colors.red,
                                            content: const Text(
                                                'Please pair to the device first')),
                                      );
                                    },
                                    onTapDown: (_) {
                                      setState(() => isPressed5 = true); // Change state to pressed
                                    },
                                    onTapUp: (_) {
                                      setState(() => isPressed5 = false); // Change state back on release
                                    },
                                    onTapCancel: () {
                                      setState(() => isPressed5 = false); // Ensure button resets if tap is canceled
                                    },
                                    splashColor: Colors.redAccent.withOpacity(0.3),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/mist.png",
                                          height: screenHeight * 0.085,
                                        ),
                                        heightGap(screenHeight * 0.01),
                                        Text(
                                          "MIST 1",
                                          style: aa.innerUiStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: screenHeight * 0.19,
                                  width: screenWidth * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 1),
                                    color: isPressed6 ? Colors.grey[300] : Colors.white, // Changes color on press
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isPressed6 // Adds shadow to simulate press effect
                                        ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(2, 2),
                                      )
                                    ]
                                        : [],
                                  ),
                                  child: InkWell(
                                    onTap: (){
                                      Vibration.vibrate();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.35,
                                                vertical: 3),
                                            elevation: 2.0,
                                            backgroundColor: Colors.red,
                                            content: const Text(
                                                'Please pair to the device first')),
                                      );
                                    },
                                    onTapDown: (_) {
                                      setState(() => isPressed6 = true); // Change state to pressed
                                    },
                                    onTapUp: (_) {
                                      setState(() => isPressed6 = false); // Change state back on release
                                    },
                                    onTapCancel: () {
                                      setState(() => isPressed6 = false); // Ensure button resets if tap is canceled
                                    },
                                    splashColor: Colors.redAccent.withOpacity(0.3),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/mist.png",
                                            height: screenHeight * 0.085),
                                        heightGap(screenHeight * 0.01),
                                        Text(
                                          "MIST 2",
                                          style: aa.innerUiStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.19,
                                  width: screenWidth * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 1),
                                    color: isPressed3 ? Colors.grey[300] : Colors.white, // Changes color on press
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isPressed3 // Adds shadow to simulate press effect
                                        ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(2, 2),
                                      )
                                    ]
                                        : [],
                                  ),
                                  child: InkWell(
                                    onTap: (){
                                      Vibration.vibrate();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.35,
                                                vertical: 3),
                                            elevation: 2.0,
                                            backgroundColor: Colors.red,
                                            content: const Text(
                                                'Please pair to the device first')),
                                      );
                                    },
                                    onTapDown: (_) {
                                      setState(() => isPressed3 = true); // Change state to pressed
                                    },
                                    onTapUp: (_) {
                                      setState(() => isPressed3 = false); // Change state back on release
                                    },
                                    onTapCancel: () {
                                      setState(() => isPressed3 = false); // Ensure button resets if tap is canceled
                                    },
                                    splashColor: Colors.redAccent.withOpacity(0.3),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/mist.png",
                                          height: screenHeight * 0.085,
                                        ),
                                        heightGap(screenHeight * 0.01),
                                        Text(
                                          "MIST 3",
                                          style: aa.innerUiStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRoundedRectSliderTrackShape extends SliderTrackShape {
  final double radius;

  CustomRoundedRectSliderTrackShape({required this.radius});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset? offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset!.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 95;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset thumbCenter,
        bool isEnabled = false,
        bool isDiscrete = false,
        Offset? secondaryOffset,
        required TextDirection textDirection,
      }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activeTrackPaint = Paint()
      ..color = sliderTheme.activeTrackColor!;
    final Paint inactiveTrackPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;

    // Draw the inactive track with rounded corners
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(radius)),
      inactiveTrackPaint,
    );

    // Draw the active track (from center to thumb position)
    final double centerX = trackRect.left + (trackRect.width / 2);
    final Rect activeTrackRect = Rect.fromLTRB(
      centerX,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeTrackRect, Radius.circular(radius)),
      activeTrackPaint,
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  final double enabledThumbRadius;

  const CustomSliderThumbShape({required this.enabledThumbRadius});

  @override
  Size getPreferredSize(bool isDiscrete, bool isEnabled) {
    return Size(enabledThumbRadius * 2, enabledThumbRadius * 2);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double textScaleFactor,
        required double value,
        required RenderBox parentBox,
        required Size sizeWithOverflow,
      }) {
    final Paint paint = Paint()..color = sliderTheme.activeTrackColor!;

    // Draw round rectangle shape for the thumb
    final Rect thumbRect = Rect.fromCenter(
        center: center,
        width: enabledThumbRadius * 2,
        height: enabledThumbRadius);
    // context.canvas.drawRRect(
    //   RRect.fromRectAndRadius(thumbRect, Radius.circular(enabledThumbRadius)),
    //   paint,
    // );
  }
}

class CustomRoundedRectSliderTrackShape1 extends SliderTrackShape {
  final double radius;

  CustomRoundedRectSliderTrackShape1({required this.radius});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset? offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset!.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 95;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset thumbCenter,
        bool isEnabled = false,
        bool isDiscrete = false,
        Offset? secondaryOffset,
        required TextDirection textDirection,
      }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activeTrackPaint = Paint()
      ..color = sliderTheme.activeTrackColor!;
    final Paint inactiveTrackPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;

    // Draw the inactive track with rounded corners
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(radius)),
      inactiveTrackPaint,
    );

    // Draw the active track (left side of the thumb) with rounded corners
    final Rect activeTrackRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeTrackRect, Radius.circular(radius)),
      activeTrackPaint,
    );
  }
}

class CustomSliderThumbShape1 extends SliderComponentShape {
  final double enabledThumbRadius;

  const CustomSliderThumbShape1({required this.enabledThumbRadius});

  @override
  Size getPreferredSize(bool isDiscrete, bool isEnabled) {
    return Size(enabledThumbRadius * 2, enabledThumbRadius * 2);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double textScaleFactor,
        required double value,
        required RenderBox parentBox,
        required Size sizeWithOverflow,
      }) {
    // Remove thumb drawing
  }
}
