import 'dart:ui';
import 'package:ssss/pages/machines/rcCar/permissionCheck.dart';
import 'package:ssss/pages/machines/rcCar/scan.dart';
import 'package:ssss/pages/machines/rover/permissionCheck.dart';
import 'package:ssss/pages/machines/rover/suggestion_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../../../logic/JoystickProvider2.dart';
import '../../../main.dart';
import '../../../utils/appcolors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/helpermethods.dart';
import '../../../utils/images.dart';
import '../../extra/outlineglowborder.dart';

class RoverPage extends StatefulWidget {
  const RoverPage({super.key});

  @override
  State<RoverPage> createState() => _CarPageState();
}

class _CarPageState extends State<RoverPage> {
  TextEditingController _oavBoxController = TextEditingController();
  double _camerasliderValue = 0.0;
  double _drillersliderValue = 0.0;
  double _grippersliderValue = 0.0;
  double _arm1sliderValue = 0.0;
  double _arm2sliderValue = 0.0;
  double _suggestionHeight = 0.0;
  bool isBluePressed = false;
  bool isPressed = false;
  bool isSuggestionShow = false;

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    _suggestionHeight =  screenHeight*0.21;
    final joystickProvider = Provider.of<JoystickProvider2>(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/roverbg.png',
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
            child: SingleChildScrollView(
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
                    // Top left circular container with asset image
                    Positioned(
                      top: screenHeight * 0.04,
                      left: screenWidth * 0.022,
                      child: Container(
                          height: screenHeight * 0.124,
                          width: screenWidth * 0.06,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            color: isBluePressed
                                ? Colors.grey[300]
                                : Colors.white, // Changes color on press
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isBluePressed
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(2, 2),
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
                                                builder: (context) => roverPermissionPage(),
                                              ),
                                            );
                                },
                                  onTap: () {
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
                                    setState(() => isBluePressed =
                                        true); // Change state to pressed
                                  },
                                  onTapUp: (_) {
                                    setState(() => isBluePressed =
                                        false); // Change state back on release
                                  },
                                  onTapCancel: () {
                                    setState(() => isBluePressed =
                                        false); // Ensure button resets if tap is canceled
                                  },
                                  splashColor: AppColor.instanse
                                      .redSplashEffect, // Customize splash color
                                  borderRadius: BorderRadius.circular(10),
                                  child: Center(
                                      child: Image.asset(bluetoothOffIcon,height:screenHeight*0.11))))),
                    ),
                    // Top center text "RC Car"
                    Positioned(
                      // top: 20,
                      // left: screenWidth * 0.5 - 70, // Center horizontally
                      top: screenWidth * 0.027,
                      left: screenWidth * 0.41,
                      child: Text(
                        "Rover",
                        style: TextStyle(
                          // fontSize: 24,
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    //oav
                    Positioned(
                      bottom: screenWidth * 0.08,
                      right: screenWidth * 0.28,
                      child:  Column(
                        children: [
                          Container(
                            height: h*0.06,
                            width: w*0.15,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 5,
                                  offset: const Offset(3, 3),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 15,
                                  offset: const Offset(-1, -1),
                                ),
                              ],
                              color:
                              AppColor.instanse.blurColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 0.5,
                                  color: AppColor.instanse.colorWhite),
                            ),
                            child: TextFormField(
                              onFieldSubmitted: (String s){
                                setState(() {
                                  isSuggestionShow =false;
                                });
                              },
                              onTap: (){
                               setState(() {
                                 isSuggestionShow =true;
                               });
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 0,left: 15),
                                  border: InputBorder.none,
                                  hintText: "OAV",
                                  hintStyle: aa.hintStyle
                              ),
                              controller: _oavBoxController,
                              keyboardType: TextInputType.number,
                              style: aa.hintStyle,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    3), // Limit to 3 digits
                              ],
                              onChanged: (value) {
                                setState(() {
                                  isSuggestionShow =false;
                                });
                                // Validate the input
                                if (value.isNotEmpty) {
                                  final intValue = int.tryParse(value);
                                  if (intValue == null ||
                                      intValue < 1 ||
                                      intValue > 200) {
                                    // If value is not valid, clear the field or set to a valid value
                                    _oavBoxController.text = '';
                                    // Optionally, you can also set the cursor position
                                    _oavBoxController.selection =
                                        TextSelection.fromPosition(
                                            const TextPosition(offset: 0));
                                  }
                                }
                              },
                            ),
                          ),
                          heightGap(screenHeight * 0.02),
                          Container(
                            height: h*0.06,
                            width: w*0.15,
                            decoration: BoxDecoration(
                              boxShadow: [
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
                              color: AppColor.instanse.colorWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1,
                                  color: AppColor.instanse.colorWhite
                                      .withOpacity(0.6)),
                            ),
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
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
                                    setState(() => isPressed =
                                    true); // Change state to pressed
                                  },
                                  onTapUp: (_) {
                                    setState(() => isPressed =
                                    false); // Change state back on release
                                  },
                                  onTapCancel: () {
                                    setState(() => isPressed =
                                    false); // Ensure button resets if tap is canceled
                                  },
                                  splashColor: AppColor.instanse
                                      .redSplashEffect, //Customize splash color
                                  borderRadius: BorderRadius.circular(10),
                                  child: Center(
                                    child: Text(
                                        "SET",
                                        style: GoogleFonts.ubuntu(
                                            color: const Color.fromRGBO(
                                                163, 171, 183, 1),
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenWidth * 0.022)
                                    ),
                                  ),
                                )),
                          ),

                        ],
                      ),
                    ),
                    // 5 sliders
                    ///slider1 aligned
                    Positioned(
                      top: screenHeight * 0.275,
                      bottom: screenHeight * 0.025,
                      left: screenWidth * 0.055,
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
                      left: screenWidth * 0.0518,
                      top: 6,
                      height: screenHeight * 0.84,
                      width: screenWidth * 0.07,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 42.0,
                              thumbShape: const CustomSliderThumbShape(
                                  enabledThumbRadius: 14.0), // Custom thumb shape
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 0.0),
                              activeTrackColor: Colors.grey,
                              inactiveTrackColor: Colors.grey[800],
                              thumbColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              trackShape:
                                  CustomRoundedRectSliderTrackShape(radius: 8.0),
                            ),
                            child: Slider(
                              value: _camerasliderValue,
                              min: -90.0,
                              max: 90.0,
                              divisions: 181,
                              onChanged: (value) {
                                Vibration.vibrate();
                                setState(() {
                                  _camerasliderValue = value;
                                  print("camera");
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
                      left: screenWidth * 0.075,
                      child: Text(
                        '90',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.016,
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.075,
                      bottom: screenWidth * 0.024,
                      child: Text(
                        _camerasliderValue.toStringAsFixed(0),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.016,
                        ),
                      ),
                    ),
                    // Fixed text "Camera" in the center of the track
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2,
                      left: screenWidth * 0.076,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Camera',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: screenWidth * 0.012,
                          ),
                        ),
                      ),
                    ),

                    ///slider2 aligned
                    Positioned(
                      top: screenHeight * 0.275,
                      left: screenWidth * 0.16,
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
                      top: 6,
                      // bottom: 0,
                      left: screenWidth * 0.157,
                      height: screenHeight * 0.84,
                      width: screenWidth * 0.07,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 42.0,
                              thumbShape: CustomSliderThumbShape(
                                  enabledThumbRadius: 14.0), // Custom thumb shape
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 0.0),
                              activeTrackColor: Colors.grey,
                              inactiveTrackColor: Colors.grey[800],
                              thumbColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              trackShape:
                                  CustomRoundedRectSliderTrackShape1(radius: 8.0),
                            ),
                            child: Slider(
                              value: _drillersliderValue,
                              // value: _camerasliderValue,
                              min: 0.0,
                              max: 100.0,
                              divisions: 100,
                              onChanged: (value) {
                                Vibration.vibrate();
                                setState(() {
                                  _drillersliderValue = value;
                                  print("driller");
                                  print(value);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.178,
                      top: screenWidth * 0.15,
                      child: Text(
                        '100',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.016,
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.186,
                      bottom: screenWidth * 0.024,
                      child: Text(
                        _drillersliderValue.toStringAsFixed(0),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.016,
                        ),
                      ),
                    ),
                    // Fixed text "Driller" in the center of the track
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2,
                      left: screenWidth*0.183,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Driller',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: screenWidth * 0.012,
                          ),
                        ),
                      ),
                    ),

                    ///slider3
                    Positioned(
                      top: screenHeight * 0.275,
                      bottom: screenHeight * 0.025,
                      left: screenWidth * 0.267,
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
                      top: 6,
                      // bottom: 0,
                      left: screenWidth * 0.2633,
                      height: screenHeight * 0.84,
                      width: screenWidth * 0.07,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 42.0,
                              thumbShape: CustomSliderThumbShape(
                                  enabledThumbRadius: 14.0), // Custom thumb shape
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 0.0),
                              activeTrackColor: Colors.grey,
                              inactiveTrackColor: Colors.grey[800],
                              thumbColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              trackShape:
                                  CustomRoundedRectSliderTrackShape(radius: 8.0),
                            ),
                            child: Slider(
                              value: _grippersliderValue,
                              min: -90.0,
                              max: 90.0,
                              divisions: 181,
                              onChanged: (value) {
                                Vibration.vibrate();
                                setState(() {
                                  _grippersliderValue = value;
                                  print("gripper");
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
                      left: screenWidth * 0.29,
                      child: Text(
                        '90',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.016,
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.29,
                      bottom: screenWidth * 0.024,
                      child: Text(
                        _grippersliderValue.toStringAsFixed(0),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.016,
                        ),
                      ),
                    ),
                    // Fixed text "Gripper" in the center of the track
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2,
                      left: screenWidth*0.288,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Gripper',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: screenWidth * 0.012,
                          ),
                        ),
                      ),
                    ),

                    ///slider4
                    Positioned(
                      top: screenHeight * 0.275,
                      bottom: screenHeight * 0.025,
                      left: screenWidth * 0.37,
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
                      top: 6,
                      // bottom: 0,
                      left: screenWidth * 0.367,
                      height: screenHeight * 0.84,
                      width: screenWidth * 0.07,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 42.0,
                              thumbShape: CustomSliderThumbShape(
                                  enabledThumbRadius: 14.0), // Custom thumb shape
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 0.0),
                              activeTrackColor: Colors.grey,
                              inactiveTrackColor: Colors.grey[800],
                              thumbColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              trackShape:
                                  CustomRoundedRectSliderTrackShape(radius: 8.0),
                            ),
                            child: Slider(
                              value: _arm1sliderValue,
                              min: -90.0,
                              max: 90.0,
                              divisions: 181,
                              onChanged: (value) {
                                setState(() {
                                  Vibration.vibrate();
                                  _arm1sliderValue = value;
                                  print("_arm1sliderValue");
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
                      left: screenWidth * 0.39,
                      child: Text(
                        '90',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.016,
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.389,
                      bottom: screenWidth * 0.024,
                      child: Text(
                        _arm1sliderValue.toStringAsFixed(0),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.016,
                        ),
                      ),
                    ),
                    // Fixed text "Arm 1" in the center of the track
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2,
                      left: screenWidth*0.392,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Arm 1',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: screenWidth * 0.012,
                          ),
                        ),
                      ),
                    ),

                    ///slider5
                    Positioned(
                      top: screenHeight * 0.275,
                      bottom: screenHeight * 0.025,
                      left: screenWidth * 0.473,
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
                      top: 6,
                      // bottom: 0,
                      left: screenWidth * 0.47,
                      height: screenHeight * 0.84,
                      width: screenWidth * 0.07,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 42.0,
                              thumbShape: CustomSliderThumbShape(
                                  enabledThumbRadius: 14.0), // Custom thumb shape
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 0.0),
                              activeTrackColor: Colors.grey,
                              inactiveTrackColor: Colors.grey[800],
                              thumbColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              trackShape:
                                  CustomRoundedRectSliderTrackShape(radius: 8.0),
                            ),
                            child: Slider(
                              value: _arm2sliderValue,
                              min: -90.0,
                              max: 90.0,
                              divisions: 181,
                              onChanged: (value) {
                                Vibration.vibrate();
                                setState(() {
                                  _arm2sliderValue = value;
                                  print("_arm1sliderValue");
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
                      left: screenWidth * 0.493,
                      child: Text(
                        '90',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.016,
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.5,
                      bottom: screenWidth * 0.024,
                      child: Text(
                        _arm2sliderValue.toStringAsFixed(0),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.016,
                        ),
                      ),
                    ),
                    // Fixed text "Arm 2" in the center of the track
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2,

                      left: screenWidth * 0.495,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Arm 2',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: screenWidth * 0.012,
                          ),
                        ),
                      ),
                    ),

                    ///adjust code
                    Positioned(
                        top: 0,
                        bottom: screenHeight * 0.58,
                        right: screenWidth * 0.17,
                        left: screenWidth * 0.35,
                        child: Container(
                          color: Colors.transparent,
                        )),
                    // Top right two square containers with asset images
                    Positioned(
                      top: screenHeight * 0.04,
                      right: 16,
                      child: Row(
                        children: [
                          // Container(
                          //   height: screenHeight * 0.124,
                          //   width: screenWidth * 0.06,
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
                          //     border: Border.all(color: Colors.white, width: 1),
                          //     image: const DecorationImage(
                          //       image: AssetImage(
                          //           'assets/images/pair.png'), // Replace with your asset image
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          //   child: Material(
                          //       color: Colors.transparent,
                          //       child: InkWell(
                          //         onTap: () {
                          //           Vibration.vibrate();
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (context) => roverPermissionPage(),
                          //             ),
                          //           );
                          //         },
                          //         onTapDown: (_) {
                          //           setState(() => isPressed =
                          //               true); // Change state to pressed
                          //         },
                          //         onTapUp: (_) {
                          //           setState(() => isPressed =
                          //               false); // Change state back on release
                          //         },
                          //         onTapCancel: () {
                          //           setState(() => isPressed =
                          //               false); // Ensure button resets if tap is canceled
                          //         },
                          //         splashColor: AppColor.instanse
                          //             .redSplashEffect, //Customize splash color
                          //         borderRadius: BorderRadius.circular(10),
                          //       )),
                          // ),
                          const SizedBox(width: 8), // Spacing between images
                          Container(
                            height: screenHeight * 0.124,
                            width: screenWidth * 0.06,
                            decoration: BoxDecoration(
                              boxShadow: [
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 1),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/homearrow.png'), // Replace with your asset image
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Vibration.vibrate();
                                    Navigator.pop(context);
                                  },
                                  onTapDown: (_) {
                                    setState(() => isPressed =
                                        true); // Change state to pressed
                                  },
                                  onTapUp: (_) {
                                    setState(() => isPressed =
                                        false); // Change state back on release
                                  },
                                  onTapCancel: () {
                                    setState(() => isPressed =
                                        false); // Ensure button resets if tap is canceled
                                  },
                                  splashColor: AppColor.instanse
                                      .redSplashEffect, // Customize splash color
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ],
                      ),
                    ),
                    ///joystick
                    Positioned(
                      bottom: 20,
                      right: screenWidth * 0.03,
                      child: GestureDetector(

                        onPanUpdate: (details) {
                          Vibration.vibrate();
                          RenderBox renderBox =
                              context.findRenderObject() as RenderBox;
                          Size size = renderBox.size;
                          joystickProvider.updateJoystickPosition(
                              details.localPosition, size);
                        },
                        onPanEnd: (details) {
                          joystickProvider
                              .resetJoystick(); // Reset the ball position to the center when released
                        },
                        child: Container(
                          width: joystickProvider.joystickRadius * 1.85,
                          height: joystickProvider.joystickRadius * 1.85,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Colors.redAccent
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/joystickimg1.png'), // Replace with your local image asset path
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            alignment:
                                Alignment.center, // Center the child widgets
                            children: [
                              // Joystick ball
                              Align(
                                alignment: Alignment(
                                    joystickProvider.joystickPosition.dx,
                                    joystickProvider.joystickPosition.dy),
                                child: Container(
                                  width: joystickProvider.ballRadius * 3,
                                  height: joystickProvider.ballRadius * 3,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors
                                            .white, // White color towards the center
                                        Color.fromRGBO(81, 241, 105, 1),
                                      ],
                                      stops: [
                                        0.2,
                                        1.0
                                      ], // Define how much of the container is green
                                      center:
                                          Alignment.center, // Center the gradient
                                      radius: 1.0, // Set the gradient radius
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey.shade400, // Shadow color
                                        spreadRadius: 6, // Spread of the shadow
                                        blurRadius:
                                            5, // Blur effect for smooth transition
                                        offset: Offset(
                                            0, 0), // Position of the shadow
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          isSuggestionShow == true?
          Positioned(
            top: screenHeight*0.04,
              right: screenWidth*0.25,
              child: ObstacleValueCard()):SizedBox()
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
