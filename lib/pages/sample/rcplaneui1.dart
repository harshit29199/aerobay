import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/JoystickProvider.dart';

class JoystickWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final joystickProvider = Provider.of<JoystickProvider>(context);

    return Center(
      child: GestureDetector(
        onPanUpdate: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Size size = renderBox.size;
          joystickProvider.updateJoystickPosition(details.globalPosition, size);
        },
        onPanEnd: (details) {
          print('Vertical position percentage: ${0}');
          joystickProvider.resetJoystick(); // Reset the ball position to the bottom when released
        },
        child: Container(
          width: joystickProvider.joystickRadius * 2, // Use the public getter
          height: joystickProvider.joystickRadius * 2, // Use the public getter
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[600], // Joystick background color
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Joystick ball
              Align(
                alignment: Alignment(joystickProvider.joystickPosition.dx, joystickProvider.joystickPosition.dy),
                child: Container(
                  width: joystickProvider.ballRadius * 2, // Use the public getter
                  height: joystickProvider.ballRadius * 2, // Use the public getter
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue, // Joystick ball color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}