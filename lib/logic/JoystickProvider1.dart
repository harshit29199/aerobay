import 'package:flutter/material.dart';

class JoystickProvider1 extends ChangeNotifier {
  Offset _joystickPosition = Offset(0, 0); // Initial position at the center (X = 0, Y = 0)
  double _joystickRadius = 100.0; // Radius of the joystick area
  double _ballRadius = 30.0; // Radius of the joystick ball

  // Getter to expose joystick position
  Offset get joystickPosition => _joystickPosition;

  // Getter to expose joystick radius
  double get joystickRadius => _joystickRadius;

  // Getter to expose ball radius
  double get ballRadius => _ballRadius;

  // Function to update the joystick ball position (horizontal only)
  void updateJoystickPosition(Offset details, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2); // Center of joystick
    Offset offset = details - center; // Offset from the center

    // Constrain the movement to the horizontal axis within joystick's radius
    if (offset.dx.abs() > _joystickRadius - _ballRadius) {
      offset = Offset(offset.dx.sign * (_joystickRadius - _ballRadius), 0); // Limit horizontal movement
    }

    // Update joystick position only for horizontal movement
    _joystickPosition = Offset(
      offset.dx / (_joystickRadius - _ballRadius),
      0, // Keep Y-axis position constant (no vertical movement)
    );

    notifyListeners(); // Notify UI to update
    _printHorizontalPercentage();
  }

  // Function to print percentage (0 to 100) based on horizontal joystick position
  void _printHorizontalPercentage() {
    // Convert the horizontal position from (-1 to 1) range to (0 to 100) range
    double percentage = (_joystickPosition.dx + 1) * 50;
    print('Horizontal position percentage: ${percentage.round()}');
  }

  // Reset joystick ball to the center
  void resetJoystick() {
    _joystickPosition = Offset(0, 0); // Reset to the center position
    notifyListeners(); // Notify UI to update
  }
}
