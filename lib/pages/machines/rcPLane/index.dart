import 'dart:math';
import 'dart:ui';
import 'package:ssss/pages/machines/rcPLane/permissionCheck.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../../logic/JoystickProvider2.dart';
import '../../../utils/appcolors.dart';
import '../../../utils/images.dart';

class PlanePage extends StatefulWidget {
  const PlanePage({super.key});

  @override
  State<PlanePage> createState() => _PlanePageState();
}

class _PlanePageState extends State<PlanePage> {
  int value = 0;
  bool isPressed = false;
  bool isBluPressed = false;

  @override
  void initState() {
    super.initState();
  }

  ///stick1 fun,var
  // Offset _joystickPosition = Offset(0, 1); // Joystick's ball initial position
  // double _joystickRadius = 100.0; // Radius of the joystick area
  // double _ballRadius = 30.0; // Radius of the joystick ball
  // Offset _joystickOffset =
  //     Offset(0, 0); // To track the joystick's offset position
  //
  // void _updateJoystickPosition(Offset details, Size size) {
  //   // Adjust for the joystick's offset
  //   final Offset adjustedDetails = details - _joystickOffset;
  //
  //   // Center of the joystick (where the ball starts)
  //   final Offset center = Offset(_joystickRadius, _joystickRadius);
  //
  //   // Calculate the offset from the center of the joystick
  //   Offset offset = adjustedDetails - center;
  //   final double distance = offset.distance;
  //
  //   // Constrain the movement within the joystick's radius
  //   if (distance > _joystickRadius - _ballRadius) {
  //     offset =
  //         Offset.fromDirection(offset.direction, _joystickRadius - _ballRadius);
  //   }
  //
  //   double normalizedY = offset.dy / (_joystickRadius - _ballRadius);
  //
  //   // Apply direction and level constraints (Ignore diagonal movements)
  //   setState(() {
  //     _joystickPosition = Offset(
  //         0, normalizedY.clamp(-1, 1)); // Constrain movement to vertical only
  //   });
  //
  //   _printDirectionAndLevel();
  // }
  //
  // void _resetJoystick() {
  //   setState(() {
  //     _joystickPosition = Offset(0, 1); // Reset to the center position
  //   });
  // }
  //
  // void _printDirectionAndLevel() {
  //   double dx = _joystickPosition.dx;
  //   double dy = _joystickPosition.dy;
  //
  //   String? direction;
  //   // int level = _getMovementLevel();
  //   int verticalLevel = _getVerticalLevel(dy);
  //   // Map joystick position to directions and assign the direction character
  //   if (dx == 0 && dy == 0) {
  //     direction = "S"; // Stop
  //     // level = 0;
  //   } else if (dy < 0 && dx.abs() < 0.5) {
  //     direction = "F"; // Forward
  //   } else if (dy > 0 && dx.abs() < 0.5) {
  //     direction = "B"; // Bottom
  //   } else if (dx > 0 && dy.abs() < 0.5) {
  //     direction = "R"; // Right
  //   } else if (dx < 0 && dy.abs() < 0.5) {
  //     direction = "L"; // Left
  //   } else if (dx > 0 && dy < 0) {
  //     direction = "FR"; // Forward-Right
  //   } else if (dx < 0 && dy < 0) {
  //     direction = "FL"; // Forward-Left
  //   } else if (dx > 0 && dy > 0) {
  //     direction = "BR"; // Bottom-Right
  //   } else if (dx < 0 && dy > 0) {
  //     direction = "BL"; // Bottom-Left
  //   }
  //
  //   // Send direction and speed only if not center (stop)
  //   if (direction != "S") {
  //     String command = "$direction";
  //     // sendFun1(command.codeUnits); // Convert string to ASCII values
  //   }
  //
  //   // print('Direction: $direction, Level: $level');
  //   print('value: $verticalLevel');
  // }
  //
  // int _getVerticalLevel(double dy) {
  //   return ((1 - dy) * 50)
  //       .round(); // Convert from -1 (bottom) to 1 (top) as 0 to 100%
  // }

  ///try
  Offset _joystickPosition = Offset(0, 1); // Joystick's ball initial position
  double _joystickRadius = 100.0; // Radius of the joystick area
  double _ballRadius = 30.0; // Radius of the joystick ball

  void _updateJoystickPosition(Offset details, Size size) {
    // Adjust for the joystick's offset
    final Offset center = Offset(_joystickRadius, _joystickRadius);
    Offset offset = details - center;
    final double distance = offset.distance;

    // Constrain the movement within the joystick's radius
    if (distance > _joystickRadius - _ballRadius) {
      offset = Offset.fromDirection(offset.direction, _joystickRadius - _ballRadius);
    }

    // Determine the dominant movement direction (horizontal or vertical)
    double dx = offset.dx;
    double dy = offset.dy;

    if (dx.abs() > dy.abs()) {
      // Horizontal movement (left/right)
      offset = Offset(dx, 0);
    } else {
      // Vertical movement (up/down)
      offset = Offset(0, dy);
    }

    // Normalize the movement to -1 to 1 range
    double normalizedX = (offset.dx / (_joystickRadius - _ballRadius)).clamp(-1, 1);
    double normalizedY = (offset.dy / (_joystickRadius - _ballRadius)).clamp(-1, 1);

    // Map the normalized values to -90 to 90 range
    double horizontalValue = (normalizedX * 90).clamp(-90, 90);
    double verticalValue = (normalizedY * 90).clamp(-90, 90);

    setState(() {
      _joystickPosition = Offset(normalizedX, normalizedY);
    });

    _printDirectionAndValue(horizontalValue, verticalValue);
  }

  void _resetJoystick({required bool isHorizontalMovement}) {
    setState(() {
      if (isHorizontalMovement) {
        _joystickPosition = Offset(0, 0); // Reset to center for horizontal movement
      }
    });
  }

  void _onPanEnd() {
    // Check if the last movement was horizontal
    bool isHorizontalMovement = _joystickPosition.dx != 0 && _joystickPosition.dy == 0;
    _resetJoystick(isHorizontalMovement: isHorizontalMovement);
  }

  void _printDirectionAndValue(double horizontalValue, double verticalValue) {
    if (horizontalValue > 0) {
      print('R${horizontalValue.toStringAsFixed(0)}'); // Right direction
    } else if (horizontalValue < 0) {
      print('L${horizontalValue.toStringAsFixed(0)}'); // Left direction
    } else if (verticalValue > 0) {
      print('D${verticalValue.toStringAsFixed(0)}'); // Down direction
    } else if (verticalValue < 0) {
      print('U${verticalValue.toStringAsFixed(0)}'); // Up direction
    } else {
      print('Center'); // Joystick at center
    }
  }



  ///stick2 fun,var
  // Offset _joystickPosition1 = Offset(0, 0); // Joystick's ball initial position
  // double _joystickRadius1 = 100.0; // Radius of the joystick area
  // double _ballRadius1 = 30.0; // Radius of the joystick ball
  // Offset _joystickOffset1 =
  //     Offset(0, 0); // To track the joystick's offset position
  //
  // void _updateJoystickPosition1(Offset details, Size size) {
  //   // Adjust for the joystick's offset
  //   final Offset adjustedDetails = details - _joystickOffset1;
  //
  //   // Center of the joystick (where the ball starts)
  //   final Offset center = Offset(_joystickRadius1, _joystickRadius1);
  //
  //   // Calculate the offset from the center of the joystick
  //   Offset offset = adjustedDetails - center;
  //   final double distance = offset.distance;
  //
  //   // Constrain the movement within the joystick's radius
  //   if (distance > _joystickRadius1 - _ballRadius1) {
  //     offset = Offset.fromDirection(
  //         offset.direction, _joystickRadius1 - _ballRadius1);
  //   }
  //
  //   // Only handle horizontal movement by setting y to 0 and normalizing x-axis movement
  //   double normalizedX = offset.dx / (_joystickRadius1 - _ballRadius1);
  //   double horizontalPosition =
  //       (normalizedX * 90).clamp(-90, 90); // Map to -90 to 90 range
  //
  //   setState(() {
  //     _joystickPosition1 = Offset(
  //         horizontalPosition / 90, 0); // Normalized value for UI, y set to 0
  //   });
  //
  //   _printHorizontalPosition(
  //       horizontalPosition); // Print only the horizontal position
  // }
  //
  // void _resetJoystick1() {
  //   setState(() {
  //     _joystickPosition1 = Offset(0, 0); // Reset to the center position
  //   });
  // }
  //
  // void _printHorizontalPosition(double horizontalPosition) {
  //   print(horizontalPosition
  //       .toStringAsFixed(0)); // Print value from -90 to 90 as integer
  // }
  ///try
  Offset _joystickPosition1 = Offset(0, 0); // Joystick's ball initial position
  double _joystickRadius1 = 100.0; // Radius of the joystick area
  double _ballRadius1 = 30.0; // Radius of the joystick ball

  void _updateJoystickPosition1(Offset details, Size size) {
    // Adjust for the joystick's offset
    final Offset center = Offset(_joystickRadius1, _joystickRadius1);
    final Offset offset = details - center;
    final double distance = offset.distance;

    // Restrict movement to the joystick's radius
    Offset constrainedOffset = offset;
    if (distance > _joystickRadius1 - _ballRadius1) {
      constrainedOffset = Offset.fromDirection(
          offset.direction, _joystickRadius1 - _ballRadius1);
    }

    // Calculate the primary movement direction
    double dx = constrainedOffset.dx;
    double dy = constrainedOffset.dy;

    if (dx.abs() > dy.abs()) {
      // Horizontal movement (left/right)
      constrainedOffset = Offset(dx, 0);
    } else {
      // Vertical movement (up/down)
      constrainedOffset = Offset(0, dy);
    }

    // Normalize to -1 to 1 range and map to -90 to 90 range
    double normalizedX =
    (constrainedOffset.dx / (_joystickRadius1 - _ballRadius1)).clamp(-1, 1);
    double normalizedY =
    (constrainedOffset.dy / (_joystickRadius1 - _ballRadius1)).clamp(-1, 1);

    double horizontalValue = (normalizedX * 90).clamp(-90, 90);
    double verticalValue = (normalizedY * 90).clamp(-90, 90);

    setState(() {
      _joystickPosition1 = Offset(normalizedX, normalizedY);
    });

    // Print the direction and value
    _printMovementDirection(horizontalValue, verticalValue);
  }

  void _resetJoystick1() {
    setState(() {
      _joystickPosition1 = Offset(0, 0); // Reset to the center position
    });
  }

  void _printMovementDirection(double horizontalValue, double verticalValue) {
    if (horizontalValue > 0) {
      print('R${horizontalValue.toStringAsFixed(0)}'); // Right direction
    } else if (horizontalValue < 0) {
      print('L${horizontalValue.toStringAsFixed(0)}'); // Left direction
    } else if (verticalValue > 0) {
      print('B${verticalValue.toStringAsFixed(0)}'); // Down direction
    } else if (verticalValue < 0) {
      print('T${verticalValue.toStringAsFixed(0)}'); // Up direction
    } else {
      print('Center'); // Joystick at the center
    }
  }




  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // final joystickProvider = Provider.of<JoystickProvider2>(context);
    // final joystickProvider1 = Provider.of<JoystickProvider2>(context);
    final joystickProvider = Provider.of<JoystickProvider2>(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/planebg.png',
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
              padding: EdgeInsets.all(8.0),
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
                          color: isBluPressed
                              ? Colors.grey[300]
                              : Colors.white, // Changes color on press
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isBluPressed
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.3), // Dark shadow for pressed effect
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        4, 4), // Simulate a lift effect
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.1), // Light shadow for subtle 3D depth
                                    spreadRadius: 1,
                                    blurRadius: 15,
                                    offset: const Offset(-2, -2),
                                  ),
                                ]
                              : [
                                  // Shadow for unpressed state
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(4, 4),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 1,
                                    blurRadius: 15,
                                    offset: const Offset(-2, -2),
                                  ),
                                ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onLongPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => planePermissionPage(),
                                ),
                              );
                            },
                            onTap: () {
                              Vibration.vibrate(duration: 140);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.35,
                                      vertical: 3),
                                  elevation: 2.0,
                                  backgroundColor: Colors.red,
                                  content: const Text(
                                      'Please pair to the device first'),
                                ),
                              );
                            },
                            onTapDown: (_) {
                              setState(() => isBluPressed =
                                  true); // Change state to pressed
                            },
                            onTapUp: (_) {
                              setState(() => isBluPressed =
                                  false); // Change state back on release
                            },
                            onTapCancel: () {
                              setState(() => isBluPressed =
                                  false); // Ensure button resets if tap is canceled
                            },
                            splashColor: AppColor.instanse
                                .redSplashEffect, // Customize splash color
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: Image.asset(bluetoothOffIcon,
                                  height: screenHeight * 0.11),
                            ),
                          ),
                        ),
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
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(color: Colors.white, width: 1),
                        //     image: const DecorationImage(
                        //       image: AssetImage(
                        //           'assets/images/pair.png'), // Replace with your asset image
                        //       fit: BoxFit.cover,
                        //     ),
                        //     boxShadow: [
                        //       // Shadow for unpressed state
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
                        //   ),
                        //   child: Material(
                        //       color: Colors.transparent,
                        //       child: InkWell(
                        //         onTap: () {
                        //           Vibration.vibrate();
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) =>
                        //                   planePermissionPage(),
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
                        // const SizedBox(width: 8), // Spacing between images
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
                  // Top center text "RC Plane"
                  Positioned(
                    top: 20,
                    left: screenWidth * 0.5 - 70, // Center horizontally
                    child: Text(
                      "RC Plane",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ///joystick 1
                  Positioned(
                    bottom: 20,
                    left: screenWidth * 0.04,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        Vibration.vibrate();
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Size size = renderBox.size;
                        _updateJoystickPosition(details.localPosition, size);
                      },
                      onPanEnd: (details) {
                        print('value:0');
                        _onPanEnd();
                        // _resetJoystick(); // Reset the ball position to the center when released
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
                                  _joystickPosition.dx, _joystickPosition.dy),
                              child: Container(
                                width: joystickProvider.ballRadius * 3,
                                height: joystickProvider.ballRadius * 3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors
                                          .white, // White color towards the center
                                      Color.fromRGBO(255, 51, 5, 0.8),
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
                  ),

                  ///joystick 2
                  Positioned(
                    bottom: 20,
                    right: screenWidth * 0.04,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        Vibration.vibrate();
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Size size = renderBox.size;
                        _updateJoystickPosition1(details.localPosition, size);
                      },
                      onPanEnd: (details) {
                        print('0');
                        _resetJoystick1(); // Reset the ball position to the center when released
                      },
                      child: Container(
                        width: _joystickRadius1 * 1.85,
                        height: _joystickRadius1 * 1.85,
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
                                  _joystickPosition1.dx, _joystickPosition1.dy),
                              child: Container(
                                width: joystickProvider.ballRadius * 3,
                                height: joystickProvider.ballRadius * 3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const RadialGradient(
                                    colors: [
                                      Colors
                                          .white, // White color towards the center
                                      Color.fromRGBO(0, 59, 255, 0.8),
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
                  ),

                  ///switch
                  Positioned(
                    bottom: 20,
                    left: screenWidth * 0.4,
                    child: Transform.scale(
                      scale: 0.9,
                      child: IconTheme.merge(
                        data: const IconThemeData(color: Colors.white),
                        child: AnimatedToggleSwitch<int>.rolling(
                          current: value,
                          values: const [0, 1],
                          onChanged: (i) {
                            Vibration.vibrate();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.35,
                                      vertical: 3),
                                  elevation: 2.0,
                                  backgroundColor: Colors.red,
                                  content: const Text(
                                      'Please connect to the device first')),
                            );
                            print(i.toString());
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
        0 => Icons.power_settings_new,
        1 => Icons.power_settings_new,
        _ => Icons.lightbulb_outline_rounded,
      };
}
