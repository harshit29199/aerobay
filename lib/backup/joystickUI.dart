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
        body: const Page(),
      ),
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JoystickExample()),
              );
            },
            label: 'Joystick',
          ),
          // Button(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => const JoystickAreaExample()),
          //     );
          //   },
          //   label: 'Joystick Area',
          // ),
          // Button(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => const SquareJoystickExample()),
          //     );
          //   },
          //   label: 'Square Joystick',
          // ),
          // Button(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => const JoystickCustomizationExample()),
          //     );
          //   },
          //   label: 'Customization',
          // ),
        ],
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
  JoystickMode _joystickMode = JoystickMode.all;
  final double step = 10.0;
  String _level = "Level: None"; // Variable to hold the current level

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
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



class JoystickCustomizationExample extends StatefulWidget {
  const JoystickCustomizationExample({super.key});

  @override
  State<JoystickCustomizationExample> createState() =>
      _JoystickCustomizationExampleState();
}

class _JoystickCustomizationExampleState
    extends State<JoystickCustomizationExample> {
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;
  bool drawArrows = true;
  bool includeInitialAnimation = true;
  bool enableArrowAnimation = false;
  bool isBlueJoystick = false;
  bool withOuterCircle = false;
  Key key = UniqueKey();

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  void _updateDrawArrows() {
    setState(() {
      drawArrows = !drawArrows;
    });
  }

  void _updateInitialAnimation() {
    setState(() {
      includeInitialAnimation = !includeInitialAnimation;
      key = UniqueKey();
    });
  }

  void _updateBlueJoystick() {
    setState(() {
      isBlueJoystick = !isBlueJoystick;
    });
  }

  void _updateArrowAnimation() {
    setState(() {
      enableArrowAnimation = !enableArrowAnimation;
    });
  }

  void _updateBorderCircle() {
    setState(() {
      withOuterCircle = !withOuterCircle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Customization'),
        actions: [
          JoystickModeDropdown(
            mode: _joystickMode,
            onChanged: (JoystickMode value) {
              setState(() {
                _joystickMode = value;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Ball(_x, _y),
            Align(
              alignment: const Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Joystick(
                    includeInitialAnimation: includeInitialAnimation,
                    key: key,
                    base: JoystickBase(
                      decoration: JoystickBaseDecoration(
                        color: isBlueJoystick
                            ? Colors.lightBlue.shade600
                            : Colors.black,
                        drawArrows: drawArrows,
                        drawOuterCircle: withOuterCircle,
                      ),
                      arrowsDecoration: JoystickArrowsDecoration(
                        color: isBlueJoystick
                            ? Colors.grey.shade200
                            : Colors.grey.shade400,
                        enableAnimation: enableArrowAnimation,
                      ),
                      mode: _joystickMode,
                    ),
                    stick: JoystickStick(
                      decoration: JoystickStickDecoration(
                          color: isBlueJoystick
                              ? Colors.blue.shade600
                              : Colors.blue.shade700),
                    ),
                    mode: _joystickMode,
                    listener: (details) {
                      setState(() {
                        _x = _x + step * details.x;
                        _y = _y + step * details.y;
                      });
                    },
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          label: 'Initial Animation: $includeInitialAnimation',
                          onPressed: _updateInitialAnimation,
                        ),
                        Button(
                          label: 'Draw Arrows: $drawArrows',
                          onPressed: _updateDrawArrows,
                        ),
                        Button(
                          label: 'Draw Outer Circle: $withOuterCircle',
                          onPressed: _updateBorderCircle,
                        ),
                        Button(
                          label:
                          'Joystick Color: ${isBlueJoystick ? 'Blue' : 'Black'}',
                          onPressed: _updateBlueJoystick,
                        ),
                        Button(
                          label: 'Animated Arrows : $enableArrowAnimation',
                          onPressed: _updateArrowAnimation,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JoystickAreaExample extends StatefulWidget {
  const JoystickAreaExample({super.key});

  @override
  State<JoystickAreaExample> createState() => _JoystickAreaExampleState();
}

class _JoystickAreaExampleState extends State<JoystickAreaExample> {
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Joystick Area'),
        actions: [
          JoystickModeDropdown(
            mode: _joystickMode,
            onChanged: (JoystickMode value) {
              setState(() {
                _joystickMode = value;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: JoystickArea(
          mode: _joystickMode,
          initialJoystickAlignment: const Alignment(0, 0.8),
          listener: (details) {
            setState(() {
              _x = _x + step * details.x;
              _y = _y + step * details.y;
            });
          },
          child: Stack(
            children: [
              Ball(_x, _y),
            ],
          ),
        ),
      ),
    );
  }
}

class SquareJoystickExample extends StatefulWidget {
  const SquareJoystickExample({super.key});

  @override
  State<SquareJoystickExample> createState() => _SquareJoystickExampleState();
}

class _SquareJoystickExampleState extends State<SquareJoystickExample> {
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Square Joystick'),
        actions: [
          JoystickModeDropdown(
            mode: _joystickMode,
            onChanged: (JoystickMode value) {
              setState(() {
                _joystickMode = value;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Ball(_x, _y),
            Align(
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                mode: _joystickMode,
                base: JoystickSquareBase(
                  mode: _joystickMode,
                ),
                stickOffsetCalculator: const RectangleStickOffsetCalculator(),
                listener: (details) {
                  setState(() {
                    _x = _x + step * details.x;
                    _y = _y + step * details.y;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JoystickModeDropdown extends StatelessWidget {
  final JoystickMode mode;
  final ValueChanged<JoystickMode> onChanged;

  const JoystickModeDropdown(
      {super.key, required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: FittedBox(
          child: DropdownButton(
            value: mode,
            onChanged: (v) {
              onChanged(v as JoystickMode);
            },
            items: const [
              DropdownMenuItem(
                  value: JoystickMode.all, child: Text('All Directions')),
              DropdownMenuItem(
                  value: JoystickMode.horizontalAndVertical,
                  child: Text('Vertical And Horizontal')),
              DropdownMenuItem(
                  value: JoystickMode.horizontal, child: Text('Horizontal')),
              DropdownMenuItem(
                  value: JoystickMode.vertical, child: Text('Vertical')),
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const Button({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class Ball extends StatelessWidget {
  final double x;
  final double y;

  const Ball(this.x, this.y, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: ballSize,
        height: ballSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
      ),
    );
  }
}