import 'package:flutter/material.dart';

class JoystickProvider2 extends ChangeNotifier {
  Offset _joystickPosition = Offset(0, 0); // Initial position at the center
  double _joystickRadius = 100.0; // Radius of the joystick area
  double _ballRadius = 30.0; // Radius of the joystick ball

  Offset _joystickOffset = Offset(0, 0); // To track the joystick's offset position

  // Getter to expose joystick position
  Offset get joystickPosition => _joystickPosition;

  // Getter to expose joystick radius
  double get joystickRadius => _joystickRadius;

  // Getter to expose ball radius
  double get ballRadius => _ballRadius;

  // Function to update joystick's actual position based on its location on the screen
  void updateJoystickOffset(Offset offset) {
    _joystickOffset = offset;
  }

  // Function to update the joystick ball position (free movement)
  // Function to update the joystick ball position (free movement)
  void updateJoystickPosition(Offset details, Size size) {
    // Adjust for the joystick's offset
    final Offset adjustedDetails = details - _joystickOffset;
    print("height${size.height}");
    print("width${size.width}");
    print("dx${details.dx}");
    print("dy${details.dy}");
    // print(details.direction);

    // Center of the joystick (where the ball starts)
    final Offset center = Offset(_joystickRadius, _joystickRadius);

    // Calculate the offset from the center of the joystick
    Offset offset = adjustedDetails - center;
    final double distance = offset.distance;

    // Constrain the movement within the joystick's radius
    if (distance > _joystickRadius - _ballRadius) {
      offset = Offset.fromDirection(offset.direction, _joystickRadius - _ballRadius);
    }

    // Convert to a normalized position (-1 to 1) for both X and Y
    _joystickPosition = Offset(
      offset.dx / (_joystickRadius - _ballRadius),
      offset.dy / (_joystickRadius - _ballRadius),
    );

    // Update the ball's position within the joystick area
    // Ensure that the ball is correctly positioned based on the offset
    Offset newBallPosition = center + offset;

    // Adjust the joystick position if the ball is out of bounds
    if (distance > _joystickRadius - _ballRadius) {
      newBallPosition = center + Offset.fromDirection(offset.direction, _joystickRadius - _ballRadius);
    }

    // Notify listeners to update the UI
    notifyListeners(); // Notify UI to update
    _printDirectionAndLevel();
  }


  // Reset joystick ball to the center
  void resetJoystick() {
    _joystickPosition = Offset(0, 0); // Reset to the center position
    notifyListeners(); // Notify UI to update
  }

  void _printDirectionAndLevel() {
    double dx = _joystickPosition.dx;
    double dy = _joystickPosition.dy;

    String? direction;
    int level = _getMovementLevel();

    if (dx == 0 && dy == 0) {
      direction = "Center";
      level = 0;
    } else if (dy < 0 && dx.abs() < 0.5) {
      direction = "Top";
    } else if (dy > 0 && dx.abs() < 0.5) {
      direction = "Bottom";
    } else if (dx > 0 && dy.abs() < 0.5) {
      direction = "Right";
    } else if (dx < 0 && dy.abs() < 0.5) {
      direction = "Left";
    } else if (dx > 0 && dy < 0) {
      direction = "Top-Right";
    } else if (dx < 0 && dy < 0) {
      direction = "Top-Left";
    } else if (dx > 0 && dy > 0) {
      direction = "Bottom-Right";
    } else if (dx < 0 && dy > 0) {
      direction = "Bottom-Left";
    }

    print('Direction: $direction, Level: $level');
  }

  // Function to calculate the movement level (1 to 5)
  int _getMovementLevel() {
    double distance = _joystickPosition.distance;

    // Calculate the percentage of movement from the center (0 to 1)
    double normalizedDistance = distance / 1.0;

    // Convert to levels (1 to 5), where 0-20% is level 1, 80-100% is level 5
    if (normalizedDistance <= 0.2) {
      return 1;
    } else if (normalizedDistance <= 0.4) {
      return 2;
    } else if (normalizedDistance <= 0.6) {
      return 3;
    } else if (normalizedDistance <= 0.8) {
      return 4;
    } else {
      return 5;
    }
  }
}
