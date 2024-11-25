import 'package:flutter/material.dart';

class JoystickProvider extends ChangeNotifier {
  Offset _joystickPosition = Offset(0, 1); // Initial position at the bottom (Y = 1)
  double _joystickRadius = 100.0; // Radius of the joystick area
  double _ballRadius = 30.0; // Radius of the joystick ball

  // Getter to expose joystick position
  Offset get joystickPosition => _joystickPosition;

  // Getter to expose joystick radius
  double get joystickRadius => _joystickRadius;

  // Getter to expose ball radius
  double get ballRadius => _ballRadius;

  // Function to update the joystick ball position
  void updateJoystickPosition(Offset details, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2); // Center of joystick
    Offset offset = details - center; // Offset from the center
    final double distance = offset.distance;

    // Constrain the movement to the joystick's radius
    if (distance > _joystickRadius - _ballRadius) {
      offset = Offset.fromDirection(offset.direction, _joystickRadius - _ballRadius);
    }

    // Convert to a normalized position (-1 to 1) and update only vertical movement
    _joystickPosition = Offset(
      0, // Ignore horizontal movement for percentage calculation
      offset.dy / (_joystickRadius - _ballRadius),
    );

    notifyListeners(); // Notify UI to update
    _printVerticalPercentage();
  }

  // Function to print percentage (0 to 100) based on vertical joystick position
  void _printVerticalPercentage() {
    // Adjusting the range from 1 (bottom) to -1 (top)
    if (_joystickPosition.dy <= 1 && _joystickPosition.dy >= -1) {
      double percentage = (1 - _joystickPosition.dy) * 50;
      percentage = percentage.clamp(0, 100); // Ensure the value is between 0 and 100
      print('Vertical position percentage: ${percentage.round()}');
    }
  }

  // Reset joystick ball to the bottom
  void resetJoystick() {
    _joystickPosition = Offset(0, 1); // Reset to the bottom position
    notifyListeners(); // Notify UI to update
  }
}
