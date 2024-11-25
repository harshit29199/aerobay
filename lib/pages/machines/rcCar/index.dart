import 'dart:ui';
import 'package:ssss/pages/machines/rcCar/permissionCheck.dart';
import 'package:ssss/utils/helpermethods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../../logic/JoystickProvider2.dart';
import '../../../main.dart';
import '../../../utils/appcolors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/images.dart';
import '../rover/suggestion_box.dart';

class CarPage extends StatefulWidget {
  const CarPage({super.key});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  bool isSuggestionShow = false;

  final TextEditingController _oavBoxController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    bool isPressed = false;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final joystickProvider = Provider.of<JoystickProvider2>(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/img.png',
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
                padding: const EdgeInsets.all(8.0),
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
                            color: isPressed
                                ? Colors.grey[300]
                                : Colors.white, // Changes color on press
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isPressed
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
                                      builder: (context) =>
                                          carPermissionPage(),
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
                                  child: Center(
                                      child: Image.asset(bluetoothOffIcon,height:screenHeight*0.11),)))),
                    ),
                    Row(
                      children: [

                      ],
                    ),
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
                          //
                          //         onTap: () {
                          //           Vibration.vibrate();
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (context) =>
                          //                   carPermissionPage(),
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
                    // Top center text "RC Car"
                    Positioned(
                      top: 20,
                      left: screenWidth * 0.5 - 70, // Center horizontally
                      child: const Text(
                        "RC Car",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Bottom center container with 3 images on left and 1 on right
                    Positioned(
                      bottom: 20,
                      left: screenWidth * 0.05,
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: screenHeight * 0.145,
                                width: screenWidth * 0.071,
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
                                ),
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          Vibration.vibrate();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                                            .redSplashEffect, // Customize splash color
                                        borderRadius: BorderRadius.circular(10),
                                        child: Center(
                                            child: Image.asset(
                                              'assets/images/music.png',
                                              height: screenHeight * 0.08,
                                            )))),
                              ),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              //L Text Button
                              Container(
                                height: screenHeight * 0.145,
                                width: screenWidth * 0.071,
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
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(
                                        10), // Apply radius to the top-left corner
                                    bottomLeft: Radius.circular(
                                        10), // Apply radius to the bottom-left corner
                                  ),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                ),
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          Vibration.vibrate();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.35,
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
                                            .redSplashEffect, // Customize splash color
                                        borderRadius: BorderRadius.circular(10),
                                        child: Center(
                                            child: Text(
                                          'L',
                                          style: GoogleFonts.ubuntu(
                                              color: const Color.fromRGBO(
                                                  163, 171, 183, 1),
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenWidth * 0.035),
                                        )))),
                              ),
                              Container(
                                height: screenHeight * 0.145,
                                width: screenWidth * 0.071,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                ),
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          Vibration.vibrate();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.35,
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
                                            .redSplashEffect, // Customize splash color
                                        borderRadius: BorderRadius.circular(10),
                                        child: Center(
                                            child: Text(
                                          'H',
                                          style: GoogleFonts.ubuntu(
                                              color: const Color.fromRGBO(
                                                  163, 171, 183, 1),
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenWidth * 0.035),
                                        )))),
                              ),
                              Container(
                                height: screenHeight * 0.145,
                                width: screenWidth * 0.071,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: const Offset(12, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(
                                        10), // Apply radius to the top-left corner
                                    bottomRight: Radius.circular(
                                        10), // Apply radius to the bottom-left corner
                                  ),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                ),
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          Vibration.vibrate();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.35,
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
                                            .redSplashEffect, // Customize splash color
                                        borderRadius: BorderRadius.circular(10),
                                        child: Center(
                                            child: Text(
                                          'R',
                                          style: GoogleFonts.ubuntu(
                                              color: const Color.fromRGBO(
                                                  163, 171, 183, 1),
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenWidth * 0.035),
                                        )))),
                              ),
                              widthGap(screenWidth * 0.01),
                              Container(
                                height: screenHeight * 0.145,
                                width: screenWidth * 0.071,
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
                                  onTapOutside: (PointerDownEvent){
                                    isSuggestionShow =false;
                                  },
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
                                      contentPadding:  EdgeInsets.only(top: screenHeight*0.015,left: screenWidth*0.019),
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
                              widthGap(screenWidth * 0.01),
                              Container(
                                height: screenHeight * 0.145,
                                width: screenWidth * 0.071,
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
                          // Single asset image on the right


                        ],
                      ),
                    ),

                    ///joystick
                    Positioned(
                      bottom: 20,
                      right: screenWidth * 0.06,
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
                          decoration: const BoxDecoration(
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
                                    gradient: const RadialGradient(
                                      colors: [
                                        Colors
                                            .white, // White color towards the center
                                        Color.fromRGBO(255, 234, 5, 0.8),
                                      ],
                                      stops: [
                                        0.25,
                                        1.0
                                      ], // Define how much of the container is green
                                      center: Alignment
                                          .center, // Center the gradient
                                      radius: 1.0, // Set the gradient radius
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors
                                            .grey.shade400, // Shadow color
                                        spreadRadius: 6, // Spread of the shadow
                                        blurRadius:
                                            5, // Blur effect for smooth transition
                                        offset: const Offset(
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
                    ),
                    isSuggestionShow == true?
                    Positioned(
                        top: screenHeight*0.38,
                        right: screenWidth*0.43,
                        child: ObstacleValueCard()):SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
