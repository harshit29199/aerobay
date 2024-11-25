///old code

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'dart:math';

const ballSize = 20.0;
const step = 10.0;

class JoystickExampleApp extends StatelessWidget {
  const JoystickExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Joystick Example'),
        ),
        // body: const Page(),
        body: const JoystickExample(),
      ),
    );
  }
}

class JoystickExample extends StatefulWidget {
  const JoystickExample({super.key});

  @override
  State<JoystickExample> createState() => _JoystickExampleState();
}

class _JoystickExampleState extends State<JoystickExample> {
  double _x = 100;
  double _y = 100;
  final JoystickMode _joystickMode = JoystickMode.all;
  final double step = 10.0;
  String _level = "Level: None"; // Variable to hold the current level

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    _y = MediaQuery.of(context).size.height / 2 + ballSize * 3; // Initial bottom position
    super.didChangeDependencies();
  }

  // Function to get direction based on angle and calculate level
  String _getDirectionAndLevel(double x, double y) {
    double angle = atan2(y, x); // Get angle in radians
    double degrees = angle * 180 / pi; // Convert radians to degrees

    if (degrees < 0) {
      degrees += 360; // Make sure angle is between 0 and 360
    }

    // Calculate distance
    double distance = sqrt(x * x + y * y);
    int level = 0;

    // Determine level based on distance (you can adjust the thresholds)
    if (distance > 0.8) {
      level = 5;
    } else if (distance > 0.6) {
      level = 4;
    } else if (distance > 0.4) {
      level = 3;
    } else if (distance > 0.2) {
      level = 2;
    } else if (distance > 0.0) {
      level = 1;
    }

    String direction;

    if (degrees >= 337.5 || degrees < 22.5) {
      direction = "Right";
    } else if (degrees >= 22.5 && degrees < 67.5) {
      direction = "Bottom Right";
    } else if (degrees >= 67.5 && degrees < 112.5) {
      direction = "Bottom";
    } else if (degrees >= 112.5 && degrees < 157.5) {
      direction = "Bottom Left";
    } else if (degrees >= 157.5 && degrees < 202.5) {
      direction = "Left";
    } else if (degrees >= 202.5 && degrees < 247.5) {
      direction = "Top Left";
    } else if (degrees >= 247.5 && degrees < 292.5) {
      direction = "Top";
    } else {
      direction = "Top Right";
    }

    // Update level text
    _level = "Direction: $direction, Level: $level";
    print(_level); // Print current level

    return direction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Joystick'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                includeInitialAnimation: false,
                mode: _joystickMode,
                listener: (details) {
                  setState(() {
                    // Calculate new position
                    _x = _x + step * details.x;
                    _y = _y + step * details.y;

                    // Get and print direction and level
                    _getDirectionAndLevel(details.x, details.y);
                  });
                },
                onStickDragEnd: () {
                  setState(() {
                    // Reset position to the bottom
                    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
                    _y = MediaQuery.of(context).size.height / 2 + ballSize * 3;
                  });
                },
              ),
            ),
            // Display the current direction and level on the screen
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                _level,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
///new code for rc plane1

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../logic/JoystickProvider.dart';
//
// class JoystickWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final joystickProvider = Provider.of<JoystickProvider>(context);
//
//     return Center(
//       child: GestureDetector(
//         onPanUpdate: (details) {
//           RenderBox renderBox = context.findRenderObject() as RenderBox;
//           Size size = renderBox.size;
//           joystickProvider.updateJoystickPosition(details.globalPosition, size);
//         },
//         onPanEnd: (details) {
//           print('Vertical position percentage: ${0}');
//           joystickProvider.resetJoystick(); // Reset the ball position to the bottom when released
//         },
//         child: Container(
//           width: joystickProvider.joystickRadius * 2, // Use the public getter
//           height: joystickProvider.joystickRadius * 2, // Use the public getter
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.grey[600], // Joystick background color
//           ),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Joystick ball
//               Align(
//                 alignment: Alignment(joystickProvider.joystickPosition.dx, joystickProvider.joystickPosition.dy),
//                 child: Container(
//                   width: joystickProvider.ballRadius * 2, // Use the public getter
//                   height: joystickProvider.ballRadius * 2, // Use the public getter
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.blue, // Joystick ball color
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






