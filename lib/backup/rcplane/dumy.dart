// // import 'package:color_picker_camera/color_picker_camera.dart';
//
// import 'dart:math';
// import 'dart:ui';
// import 'package:ssss/pages/machines/rcCar/permissionCheck.dart';
// import 'package:ssss/pages/machines/rcPLane/permissionCheck.dart';
// import 'package:animated_toggle_switch/animated_toggle_switch.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vibration/vibration.dart';
//
// import '../../../logic/JoystickProvider2.dart';
// import '../../../utils/appcolors.dart';
// import '../../../utils/images.dart';
// import '../../../utils/theme.dart';
// import '../../home.dart';
// import '../../src/ble/ble_device_connector.dart';
// import '../../src/ble/ble_device_interactor.dart';
// import '../../src/ble/ble_logger.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:ui' as ui;
// import 'dart:async';
// import 'dart:typed_data';
// import 'package:clay_containers/widgets/clay_container.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:functional_data/functional_data.dart';
// import 'package:provider/provider.dart';
//
// class dummy extends StatelessWidget {
//   dummy({
//     required this.characteristic,
//     required this.deviceConnector,
//     required this.connectionStatus,
//     required this.characteristic1,
//     Key? key,
//   }) : super(key: key);
//   final QualifiedCharacteristic characteristic;
//   final QualifiedCharacteristic characteristic1;
//   final BleDeviceConnector deviceConnector;
//   DeviceConnectionState connectionStatus;
//
//   ///update include bledeviceconnector
//
//   @override
//   Widget build(BuildContext context) => Consumer4<ConnectionStateUpdate,
//       BleDeviceInteractor, BleLogger, BleDeviceConnector>(
//       builder:
//           (_, connectionStateUpdate, interactor, logger, deviceConnector, __) =>
//           dummy1(
//             connectionStatus: connectionStateUpdate.connectionState,
//             characteristic: characteristic,
//             characteristic1: characteristic1,
//             // deviceConnector: deviceConnector,
//             deviceConnector: deviceConnector,
//             readCharacteristic: interactor.readCharacteristic,
//             writeWithResponse: interactor.writeCharacterisiticWithResponse,
//             subscribeToCharacteristic: interactor.subScribeToCharacteristic,
//             discoverServices: interactor.discoverServices,
//             // subscribeToCharacteristic: subscribeToCharacteristic,
//             writeWithoutResponse:
//             interactor.writeCharacterisiticWithoutResponse,
//             messages: logger.messages,
//           ));
// }
//
// class dummy1 extends StatefulWidget {
//   const dummy1({
//     Key? key,
//     required this.characteristic,
//     required this.characteristic1,
//     required this.deviceConnector,
//     required this.connectionStatus,
//     required this.readCharacteristic,
//     required this.writeWithResponse,
//     required this.subscribeToCharacteristic,
//     required this.discoverServices,
//     required this.writeWithoutResponse,
//     required this.messages,
//   }) : super(key: key);
//
//   final QualifiedCharacteristic characteristic;
//   final List<String> messages;
//   final QualifiedCharacteristic characteristic1;
//   final BleDeviceConnector deviceConnector;
//   final DeviceConnectionState connectionStatus;
//   final Future<List<int>> Function(QualifiedCharacteristic characteristic)
//   readCharacteristic;
//   final Future<void> Function(
//       QualifiedCharacteristic characteristic, List<int> value)
//   writeWithResponse;
//
//   final Stream<List<int>> Function(QualifiedCharacteristic characteristic)
//   subscribeToCharacteristic;
//   final Future<List<DiscoveredService>> Function(String str) discoverServices;
//
//   final Future<void> Function(
//       QualifiedCharacteristic characteristic, List<int> value)
//   writeWithoutResponse;
//
//   @override
//   State<dummy1> createState() => _dummy1State(
//       this.characteristic,
//       this.readCharacteristic,
//       this.writeWithResponse,
//       this.subscribeToCharacteristic,
//       this.writeWithoutResponse);
// }
//
// class _dummy1State extends State<dummy1> {
//   QualifiedCharacteristic characteristic;
//   Future<List<int>> Function(QualifiedCharacteristic characteristic)
//   readCharacteristic;
//   Future<void> Function(QualifiedCharacteristic characteristic, List<int> value)
//   writeWithResponse;
//
//   Stream<List<int>> Function(QualifiedCharacteristic characteristic)
//   subscribeToCharacteristic;
//
//   Future<void> Function(QualifiedCharacteristic characteristic, List<int> value)
//   writeWithoutResponse;
//
//   _dummy1State(
//       this.characteristic,
//       this.readCharacteristic,
//       this.writeWithResponse,
//       this.subscribeToCharacteristic,
//       this.writeWithoutResponse);
//
//   List<String> Deviceidlist = [];
//   List<String> Devicenamelist = [];
//   List<String> DiscoverServices = [];
//   List<String> Hwdevicenamelist = [];
//   int value = 0;
//   void getid() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     final List<String> deviceidlist =
//     preferences.getStringList('onlyneon_deviceidlist')!;
//     final List<String> devicenamelist =
//     preferences.getStringList('onlyneon_devicenamelist')!;
//     final List<String> discoverServices =
//     preferences.getStringList('onlyneon_dslist')!;
//
//     ///
//     final List<String> hwdevicenamelist =
//     preferences.getStringList('onlyneon_hwdevicenamelist')!;
//     setState(() {
//       Devicenamelist = devicenamelist;
//
//       /// arrange in alphabetic order
//       // Devicenamelist.sort();
//       Deviceidlist = deviceidlist;
//       DiscoverServices = discoverServices;
//       Hwdevicenamelist = hwdevicenamelist;
//       var a = preferences.getString("onlyneon_currentdevice");
//       if (a != null && a.isNotEmpty) {
//         _selectedItem = a.toString();
//         Fluttertoast.showToast(msg: _selectedItem);
//       }
//       if (Devicenamelist.isNotEmpty) {
//         if (_selectedItem.isEmpty) {
//           _selectedItem = Devicenamelist[0];
//         }
//       } else {
//         // Fluttertoast.showToast(msg: "no device");
//         _selectedItem = "No device";
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       getid();
//     });
//     super.initState();
//     savedDevice();
//     subscribeCharacteristic();
//     // List<int> code = [82, 10]; //neon code
//     // writeCharacteristicWithResponse1(code);
//   }
//
//   void savedDevice() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setString('rcPlane', widget.characteristic.deviceId);
//   }
//
//   late StreamSubscription<List<int>> subscribeStream;
//   String strr1 = "";
//   List<String> result = [];
//   String str = "";
//   String str1 = "";
//
//   Future<void> subscribeCharacteristic() async {
//     subscribeStream = subscribeToCharacteristic(widget.characteristic1).listen(
//           (event) {
//         print("event");
//         print(event);
//         setState(() {
//           for (int i = 0; i < event.length; i++) {
//             print(String.fromCharCode(event[i]));
//             strr1 = strr1 + String.fromCharCode(event[i]);
//           }
//         });
//
//         setState(() {
//           print(strr1);
//           // Fluttertoast.showToast(msg: strr1);
//           print(strr1.length);
//           // if (strr1.length > 0) {
//           ///x,1,100,100
//           if (strr1.length == 11 ||
//               strr1.length == 10 ||
//               strr1.length == 9 ||
//               strr1.length == 8 ||
//               strr1.length == 7) {
//             result = strr1.split(',');
//             if (result.length == 4) {
//               print(result[0]);
//               print(result[1]);
//               print(result[2]);
//               // power status
//               if (result[1] == "1") {
//               } else if (result[1] == "0") {}
//               // brightness status
//               print(result[2]);
//               // Future.delayed(const Duration(seconds: 1), () async {
//               ///working
//
//               // initvalue1=double.parse(result[2])* 12.5;
//               // });
//
//               // speed status
//               print(result[3]);
//               // Future.delayed(const Duration(seconds: 1), () async {
//               //   initvalue=double.parse(result[3]);
//               ///working
//               // });
//               strr1 = "";
//             }
//           }
//         });
//       },
//     );
//     // subscribeStream.cancel();
//     // setState(() {
//     //   subscribeOutput = 'Notification set';
//     // });
//   }
//
//   writeCharacteristicWithResponse1(List<int> code) {
//     // senddata(model,androidver,widget.messages.last);
//     widget.writeWithResponse(widget.characteristic, code);
//   }
//
//   List<int> stickcode = [];
//
//   void writeCharacteristicWithResponseb(List<int> code) {
//     if (stickcode.isEmpty || stickcode.toString() != code.toString()) {
//       // Update stickcode with the new command
//       setState(() {
//         stickcode = code;
//       });
//       // Send the command to the characteristic
//       widget.writeWithResponse(widget.characteristic, code);
//     }
//   }
//
//   List<int> speedcode = [];
//
//   writeCharacteristicWithResponsespd(List<int> code) {
//     // senddata(model,androidver,widget.messages.last);
//     if (speedcode.isEmpty == true) {
//       setState(() {
//         speedcode = code;
//       });
//       widget.writeWithResponse(widget.characteristic, code);
//     } else if (speedcode.toString() == code.toString()) {
//     } else {
//       setState(() {
//         speedcode = code;
//       });
//       widget.writeWithResponse(widget.characteristic, code);
//     }
//   }
//
//   @override
//   void dispose() {
//     subscribeStream?.cancel();
//     super.dispose();
//   }
//
//   ///
//
//   Color _getColorFromHex(String hexColor) {
//     hexColor = hexColor.replaceAll("#", "");
//     if (hexColor.length == 6) {
//       hexColor = "FF" + hexColor;
//     }
//     return Color(int.parse("0x$hexColor"));
//   }
//
//   _onLogout() {
//     widget.deviceConnector.disconnect(widget.characteristic.deviceId);
//     Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (BuildContext context) => HomePage(
//           username: '',
//           loggedin: true,
//         )));
//   }
//
//   bool _isVisible = false;
//   Color _currentColor = Colors.blue;
//   bool _isRcVisible = false;
//   bool isPressed = false;
//   bool isBluPressed = false;
//   String? textRcValue;
//   TextEditingController _oavBoxController = TextEditingController();
//   TextEditingController _textRcFieldController = TextEditingController();
//
//   String fixedcolorstat = "true";
//
//   pandelay1() {
//     Future.delayed(const Duration(milliseconds: 300), () {
// // Here you can write your code
//
//       setState(() {
//         fixedcolorstat = "true";
//       });
//     });
//   }
//
//   Color? cp;
//
//   bool stat = false;
//
//   bool lightTheme = true;
//   Color currentColor = Colors.amber;
//   Color color11 = Colors.red;
//
//   Color statcolor = Colors.green;
//
//   String _selectedItem = '';
//
//   switchd(int found) async {
//     // Fluttertoast.showToast(msg: found.toString());
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.setString(
//         "onlyneon_currentdevice", Devicenamelist[found]);
//     final List<DiscoveredService> discoveredServices =
//     await widget.discoverServices(Deviceidlist[found]);
//
//     // Fluttertoast.showToast(msg: discoveredServices.toString());
//     // final result = await widget.discoverServices(Deviceidlist[found]);
//     // Fluttertoast.showToast(msg: discoveredServices.toString());
//     int i = 0;
//     if (discoveredServices.length > 1) {
//       while (i < discoveredServices.length) {
//         if (i == 2) {
//           DiscoveredService service = discoveredServices[i];
//           print('Service ID: ${service.serviceId}');
//           print('Characteristic IDs: ${service.characteristicIds}');
//           // print('Included Services: ${service.includedServices}');
//           // Fluttertoast.showToast(msg: Hwdevicenamelist[found]);
//           print(Hwdevicenamelist[found]);
//           if (Hwdevicenamelist[found] == "rcPlane") {
//             if (!mounted) return;
//
//             // Navigator.push(context, MaterialPageRoute(builder: (context) {
//             //   return dummy11(
//             //     characteristic: QualifiedCharacteristic(
//             //       characteristicId: service.characteristicIds[1],
//             //       serviceId: service.serviceId,
//             //       deviceId: Deviceidlist[found],
//             //     ),
//             //     deviceConnector: widget.deviceConnector,
//             //     connectionStatus: widget.connectionStatus,
//             //     characteristic1: QualifiedCharacteristic(
//             //       characteristicId: service.characteristicIds[0],
//             //       serviceId: service.serviceId,
//             //       deviceId: Deviceidlist[found],
//             //     ),
//             //   );
//             // }));
//           } else {}
//         }
//         i++;
//       }
//     }
//   }
//
//   bool vib = true;
//
//   logout(BuildContext context) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.setStringList('onlyneon_deviceidlist', <String>[]);
//     await preferences.setStringList('onlyneon_devicenamelist', <String>[]);
//     await preferences.setStringList('onlyneon_dslist', <String>[]);
//
//     ///
//     await preferences.setStringList('onlyneon_hwdevicenamelist', <String>[]);
//     await preferences.setString(widget.characteristic.deviceId, "");
//     widget.deviceConnector.disconnect(widget.characteristic.deviceId);
//     if (!mounted) return;
//     // Navigator.of(context).pushReplacement(
//     //     MaterialPageRoute(builder: (BuildContext context) => MainPage()));
//   }
//
//   AppTheme aa = AppTheme();
//   List<int> lastcode = [];
//
//   Future<void> _handleRefresh() async {
//     strr1 = "";
//     Fluttertoast.showToast(msg: "Refreshing...");
//     List<int> code = [82, 10];
//     writeCharacteristicWithResponse1(code);
//   }
//
//   sendFun1(List<int> code) {
//     if (widget.connectionStatus.toString() ==
//         "DeviceConnectionState.connected") {
//       writeCharacteristicWithResponseb(code);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Bluetooth Connection not found!")));
//     }
//   }
//
//   sendFun(List<int> code) {
//     if (widget.connectionStatus.toString() ==
//         "DeviceConnectionState.connected") {
//       writeCharacteristicWithResponse1(code);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Bluetooth Connection not found!")));
//     }
//   }
//
//   ///stick1 fun,var
//   Offset _joystickPosition = Offset(0, 1); // Joystick's ball initial position
//   double _joystickRadius = 100.0; // Radius of the joystick area
//   double _ballRadius = 30.0; // Radius of the joystick ball
//   Offset _joystickOffset =
//   Offset(0, 0); // To track the joystick's offset position
//
//   void _updateJoystickPosition(Offset details, Size size) {
//     // Adjust for the joystick's offset
//     final Offset adjustedDetails = details - _joystickOffset;
//
//     // Center of the joystick (where the ball starts)
//     final Offset center = Offset(_joystickRadius, _joystickRadius);
//
//     // Calculate the offset from the center of the joystick
//     Offset offset = adjustedDetails - center;
//     final double distance = offset.distance;
//
//     // Constrain the movement within the joystick's radius
//     if (distance > _joystickRadius - _ballRadius) {
//       offset =
//           Offset.fromDirection(offset.direction, _joystickRadius - _ballRadius);
//     }
//
//     double normalizedY = offset.dy / (_joystickRadius - _ballRadius);
//
//     // Apply direction and level constraints (Ignore diagonal movements)
//     setState(() {
//       _joystickPosition = Offset(
//           0, normalizedY.clamp(-1, 1)); // Constrain movement to vertical only
//     });
//
//     _printDirectionAndLevel();
//   }
//
//   void _resetJoystick() {
//     setState(() {
//       _joystickPosition = Offset(0, 1); // Reset to the center position
//     });
//   }
//
//   void _printDirectionAndLevel() {
//     double dx = _joystickPosition.dx;
//     double dy = _joystickPosition.dy;
//
//     String? direction;
//     // int level = _getMovementLevel();
//     int verticalLevel = _getVerticalLevel(dy);
//     // Map joystick position to directions and assign the direction character
//     if (dx == 0 && dy == 0) {
//       direction = "S"; // Stop
//       // level = 0;
//     } else if (dy < 0 && dx.abs() < 0.5) {
//       direction = "F"; // Forward
//     } else if (dy > 0 && dx.abs() < 0.5) {
//       direction = "B"; // Bottom
//     } else if (dx > 0 && dy.abs() < 0.5) {
//       direction = "R"; // Right
//     } else if (dx < 0 && dy.abs() < 0.5) {
//       direction = "L"; // Left
//     } else if (dx > 0 && dy < 0) {
//       direction = "FR"; // Forward-Right
//     } else if (dx < 0 && dy < 0) {
//       direction = "FL"; // Forward-Left
//     } else if (dx > 0 && dy > 0) {
//       direction = "BR"; // Bottom-Right
//     } else if (dx < 0 && dy > 0) {
//       direction = "BL"; // Bottom-Left
//     }
//
//     // Send direction and speed only if not center (stop)
//     if (direction != "S") {
//       String command = verticalLevel.toString();
//       sendFun1(command.codeUnits); // Convert string to ASCII values
//     }
//
//     // print('Direction: $direction, Level: $level');
//     print('value: $verticalLevel');
//   }
//
//   int _getVerticalLevel(double dy) {
//     return ((1 - dy) * 50)
//         .round(); // Convert from -1 (bottom) to 1 (top) as 0 to 100%
//   }
//
//   ///stick2 fun,var
//   Offset _joystickPosition1 = Offset(0, 0); // Joystick's ball initial position
//   double _joystickRadius1 = 100.0; // Radius of the joystick area
//   double _ballRadius1 = 30.0; // Radius of the joystick ball
//   Offset _joystickOffset1 =
//   Offset(0, 0); // To track the joystick's offset position
//
//   void _updateJoystickPosition1(Offset details, Size size) {
//     // Adjust for the joystick's offset
//     final Offset adjustedDetails = details - _joystickOffset1;
//
//     // Center of the joystick (where the ball starts)
//     final Offset center = Offset(_joystickRadius1, _joystickRadius1);
//
//     // Calculate the offset from the center of the joystick
//     Offset offset = adjustedDetails - center;
//     final double distance = offset.distance;
//
//     // Constrain the movement within the joystick's radius
//     if (distance > _joystickRadius1 - _ballRadius1) {
//       offset = Offset.fromDirection(
//           offset.direction, _joystickRadius1 - _ballRadius1);
//     }
//
//     // Only handle horizontal movement by setting y to 0 and normalizing x-axis movement
//     double normalizedX = offset.dx / (_joystickRadius1 - _ballRadius1);
//     double horizontalPosition =
//     (normalizedX * 90).clamp(-90, 90); // Map to -90 to 90 range
//
//     setState(() {
//       _joystickPosition1 = Offset(
//           horizontalPosition / 90, 0); // Normalized value for UI, y set to 0
//     });
//
//     _printHorizontalPosition(
//         horizontalPosition); // Print only the horizontal position
//   }
//
//   void _resetJoystick1() {
//     setState(() {
//       _joystickPosition1 = Offset(0, 0); // Reset to the center position
//     });
//   }
//
//   void _printHorizontalPosition(double horizontalPosition) {
//     print(horizontalPosition
//         .toStringAsFixed(0)); // Print value from -90 to 90 as integer
//     sendFun1(horizontalPosition.toStringAsFixed(0).codeUnits);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     final joystickProvider = Provider.of<JoystickProvider2>(context);
//     return WillPopScope(
//       onWillPop: () async {
//         // return _onLogout();
//         return false;
//       },
//
//       ///only neon ui
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: RefreshIndicator(
//           onRefresh: _handleRefresh,
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: Image.asset(
//                   'assets/images/planebg.png',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               // BackdropFilter for the blur effect
//               BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
//                 child: Container(
//                   color:
//                   Colors.black.withOpacity(0.1), // Optional: Overlay color
//                 ),
//               ),
//               // Centered container with rounded rectangle
//               Center(
//                 child: Container(
//                   padding: EdgeInsets.all(8.0),
//                   decoration: BoxDecoration(
//                     borderRadius:
//                     BorderRadius.circular(20.0), // Rounded corners
//                     border: Border.all(
//                         color: Colors.white, width: 1), // White border
//                   ),
//                   width: screenWidth * 0.94, // Width of the container
//                   height: screenHeight * 0.9, // Height of the container
//                   child: Stack(
//                     children: [
//                       // Top left circular container with asset image
//                       Positioned(
//                         top: screenHeight * 0.04,
//                         left: screenWidth * 0.022,
//                         child: Container(
//                           height: screenHeight * 0.124,
//                           width: screenWidth * 0.06,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.white, width: 1),
//                             color: isBluPressed
//                                 ? Colors.grey[300]
//                                 : Colors.white, // Changes color on press
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: isBluPressed
//                                 ? [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 spreadRadius: 1,
//                                 blurRadius: 5,
//                                 offset: Offset(2, 2),
//                               )
//                             ]
//                                 : [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.5),
//                                 spreadRadius: 1,
//                                 blurRadius: 8,
//                                 offset: const Offset(3, 3),
//                               ),
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 spreadRadius: 1,
//                                 blurRadius: 15,
//                                 offset: const Offset(-1, -1),
//                               ),
//                             ],
//                           ),
//                           child: Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                   onLongPress: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             planePermissionPage(),
//                                       ),
//                                     );
//                                   },
//                                   onTap: () {
//                                     Vibration.vibrate();
//                                     if (widget.connectionStatus.toString() ==
//                                         "DeviceConnectionState.connected") {
//                                       widget.deviceConnector
//                                           .disconnect(characteristic.deviceId);
//                                     } else if (widget.connectionStatus
//                                         .toString() ==
//                                         "DeviceConnectionState.disconnected") {
//                                       widget.deviceConnector
//                                           .connect(characteristic.deviceId);
//                                       subscribeCharacteristic();
//                                     } else {}
//                                   },
//                                   onTapDown: (_) {
//                                     setState(() => isBluPressed =
//                                     true); // Change state to pressed
//                                   },
//                                   onTapUp: (_) {
//                                     setState(() => isBluPressed =
//                                     false); // Change state back on release
//                                   },
//                                   onTapCancel: () {
//                                     setState(() => isBluPressed =
//                                     false); // Ensure button resets if tap is canceled
//                                   },
//                                   splashColor: AppColor.instanse
//                                       .redSplashEffect, // Customize splash color
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Center(
//                                     child: widget.connectionStatus.toString() ==
//                                         "DeviceConnectionState.connected"
//                                         ? Image.asset(bluetoothOnIcon,
//                                         height: screenHeight * 0.11)
//                                         : Image.asset(bluetoothOffIcon,
//                                         height: screenHeight * 0.11),
//                                   ))),
//                         ),
//                       ),
//                       // Top right two square containers with asset images
//
//                       Positioned(
//                         top: screenHeight * 0.04,
//                         right: 16,
//                         child: Row(
//                           children: [
//                             // Container(
//                             //   height: screenHeight * 0.124,
//                             //   width: screenWidth * 0.06,
//                             //   decoration: BoxDecoration(
//                             //     boxShadow: [
//                             //       BoxShadow(
//                             //         color: Colors.black.withOpacity(0.5),
//                             //         spreadRadius: 1,
//                             //         blurRadius: 8,
//                             //         offset: const Offset(3, 3),
//                             //       ),
//                             //       BoxShadow(
//                             //         color: Colors.black.withOpacity(0.05),
//                             //         spreadRadius: 1,
//                             //         blurRadius: 15,
//                             //         offset: const Offset(-1, -1),
//                             //       ),
//                             //     ],
//                             //     color: Colors.white,
//                             //     borderRadius: BorderRadius.circular(10),
//                             //     border: Border.all(color: Colors.white, width: 1),
//                             //     image: const DecorationImage(
//                             //       image: AssetImage(
//                             //           'assets/images/pair.png'), // Replace with your asset image
//                             //       fit: BoxFit.cover,
//                             //     ),
//                             //   ),
//                             //   child: Material(
//                             //       color: Colors.transparent,
//                             //       child: InkWell(
//                             //         onTap: () {
//                             //           Vibration.vibrate();
//                             //           Navigator.push(
//                             //             context,
//                             //             MaterialPageRoute(
//                             //               builder: (context) =>
//                             //                   planePermissionPage(),
//                             //             ),
//                             //           );
//                             //         },
//                             //         onTapDown: (_) {
//                             //           setState(() => isPressed =
//                             //           true); // Change state to pressed
//                             //         },
//                             //         onTapUp: (_) {
//                             //           setState(() => isPressed =
//                             //           false); // Change state back on release
//                             //         },
//                             //         onTapCancel: () {
//                             //           setState(() => isPressed =
//                             //           false); // Ensure button resets if tap is canceled
//                             //         },
//                             //         splashColor: AppColor.instanse
//                             //             .redSplashEffect, //Customize splash color
//                             //         borderRadius: BorderRadius.circular(10),
//                             //       )),
//                             // ),
//                             const SizedBox(width: 8), // Spacing between images
//                             Container(
//                               height: screenHeight * 0.124,
//                               width: screenWidth * 0.06,
//                               decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.5),
//                                     spreadRadius: 1,
//                                     blurRadius: 8,
//                                     offset: const Offset(3, 3),
//                                   ),
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.05),
//                                     spreadRadius: 1,
//                                     blurRadius: 15,
//                                     offset: const Offset(-1, -1),
//                                   ),
//                                 ],
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border:
//                                 Border.all(color: Colors.white, width: 1),
//                                 image: const DecorationImage(
//                                   image: AssetImage(
//                                       'assets/images/homearrow.png'), // Replace with your asset image
//                                   fit: BoxFit.fitHeight,
//                                 ),
//                               ),
//                               child: Material(
//                                   color: Colors.transparent,
//                                   child: InkWell(
//                                     onTap: () {
//                                       Vibration.vibrate();
//                                       if (widget.connectionStatus.toString() ==
//                                           "DeviceConnectionState.connected") {
//                                         widget.deviceConnector.disconnect(
//                                             characteristic.deviceId);
//                                       }
//                                       Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                             const HomePage(
//                                                 username: "",
//                                                 loggedin: true)),
//                                       );
//                                     },
//                                     onTapDown: (_) {
//                                       setState(() => isPressed =
//                                       true); // Change state to pressed
//                                     },
//                                     onTapUp: (_) {
//                                       setState(() => isPressed =
//                                       false); // Change state back on release
//                                     },
//                                     onTapCancel: () {
//                                       setState(() => isPressed =
//                                       false); // Ensure button resets if tap is canceled
//                                     },
//                                     splashColor: AppColor.instanse
//                                         .redSplashEffect, // Customize splash color
//                                     borderRadius: BorderRadius.circular(10),
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Top center text "RC Plane"
//                       Positioned(
//                         top: 20,
//                         left: screenWidth * 0.5 - 70, // Center horizontally
//                         child: Text(
//                           "RC Plane",
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//
//                       ///joystick 1
//                       Positioned(
//                         bottom: 20,
//                         left: screenWidth * 0.04,
//                         child: GestureDetector(
//                           onPanUpdate: (details) {
//                             Vibration.vibrate();
//                             RenderBox renderBox =
//                             context.findRenderObject() as RenderBox;
//                             Size size = renderBox.size;
//                             _updateJoystickPosition(
//                                 details.localPosition, size);
//                           },
//                           onPanEnd: (details) {
//                             sendFun([48]);
//                             _resetJoystick(); // Reset the ball position to the center when released
//                           },
//                           child: Container(
//                             width: _joystickRadius * 1.85,
//                             height: _joystickRadius * 1.85,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               // color: Colors.redAccent
//                               image: DecorationImage(
//                                 image: AssetImage(
//                                     'assets/images/joystickimg1.png'), // Replace with your local image asset path
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             child: Stack(
//                               alignment:
//                               Alignment.center, // Center the child widgets
//                               children: [
//                                 // Joystick ball
//                                 Align(
//                                   alignment: Alignment(_joystickPosition.dx,
//                                       _joystickPosition.dy),
//                                   child: Container(
//                                     width: joystickProvider.ballRadius * 3,
//                                     height: joystickProvider.ballRadius * 3,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       gradient: RadialGradient(
//                                         colors: [
//                                           Colors
//                                               .white, // White color towards the center
//                                           Color.fromRGBO(255, 51, 5, 0.8),
//                                         ],
//                                         stops: [
//                                           0.2,
//                                           1.0
//                                         ], // Define how much of the container is green
//                                         center: Alignment
//                                             .center, // Center the gradient
//                                         radius: 1.0, // Set the gradient radius
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors
//                                               .grey.shade400, // Shadow color
//                                           spreadRadius:
//                                           6, // Spread of the shadow
//                                           blurRadius:
//                                           5, // Blur effect for smooth transition
//                                           offset: Offset(
//                                               0, 0), // Position of the shadow
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       ///joystick 2
//                       Positioned(
//                         bottom: 20,
//                         right: screenWidth * 0.04,
//                         child: GestureDetector(
//                           onPanUpdate: (details) {
//                             Vibration.vibrate();
//                             RenderBox renderBox =
//                             context.findRenderObject() as RenderBox;
//                             Size size = renderBox.size;
//                             _updateJoystickPosition1(
//                                 details.localPosition, size);
//                           },
//                           onPanEnd: (details) {
//                             sendFun([48]);
//                             _resetJoystick1(); // Reset the ball position to the center when released
//                           },
//                           child: Container(
//                             width: _joystickRadius1 * 1.85,
//                             height: _joystickRadius1 * 1.85,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               // color: Colors.redAccent
//                               image: DecorationImage(
//                                 image: AssetImage(
//                                     'assets/images/joystickimg1.png'), // Replace with your local image asset path
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             child: Stack(
//                               alignment:
//                               Alignment.center, // Center the child widgets
//                               children: [
//                                 // Joystick ball
//                                 Align(
//                                   alignment: Alignment(_joystickPosition1.dx,
//                                       _joystickPosition1.dy),
//                                   child: Container(
//                                     width: joystickProvider.ballRadius * 3,
//                                     height: joystickProvider.ballRadius * 3,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       gradient: RadialGradient(
//                                         colors: [
//                                           Colors
//                                               .white, // White color towards the center
//                                           Color.fromRGBO(0, 59, 255, 0.8),
//                                         ],
//                                         stops: [
//                                           0.2,
//                                           1.0
//                                         ], // Define how much of the container is green
//                                         center: Alignment
//                                             .center, // Center the gradient
//                                         radius: 1.0, // Set the gradient radius
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors
//                                               .grey.shade400, // Shadow color
//                                           spreadRadius:
//                                           6, // Spread of the shadow
//                                           blurRadius:
//                                           5, // Blur effect for smooth transition
//                                           offset: Offset(
//                                               0, 0), // Position of the shadow
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       ///switch
//                       Positioned(
//                         bottom: 20,
//                         left: screenWidth * 0.4,
//                         child: Transform.scale(
//                           scale: 0.9,
//                           child: IconTheme.merge(
//                             data: const IconThemeData(color: Colors.white),
//                             child: AnimatedToggleSwitch<int>.rolling(
//                               current: value,
//                               values: const [0, 1],
//                               onChanged: (i) {
//                                 Vibration.vibrate();
//                                 print(i.toString());
//                                 setState(() => value = i);
//                                 if (i == 0) {
//                                   sendFun([77]);
//                                 } else {
//                                   sendFun([78]);
//                                 }
//                               },
//                               style: const ToggleStyle(
//                                 indicatorColor: Colors.white,
//                                 borderColor: Colors.transparent,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     spreadRadius: 1,
//                                     blurRadius: 2,
//                                     offset: Offset(0, 1.5),
//                                   )
//                                 ],
//                               ),
//                               indicatorIconScale: sqrt2,
//                               iconBuilder: coloredRollingIconBuilder,
//                               borderWidth: 3.0,
//                               styleAnimationType: AnimationType.onHover,
//                               styleBuilder: (value) => ToggleStyle(
//                                 backgroundColor: colorBuilder(value),
//                                 // borderRadius: BorderRadius.circular(value * 10.0),
//                                 borderRadius: BorderRadius.circular(30.0),
//                                 indicatorBorderRadius:
//                                 BorderRadius.circular(30.0),
//                                 // indicatorBorderRadius: BorderRadius.circular(value * 10.0),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//     // }));
//   }
//
//   Color colorBuilder(int value) => switch (value) {
//     0 => Colors.redAccent,
//     1 => Colors.green,
//     _ => Colors.red,
//   };
//
//   Widget coloredRollingIconBuilder(int value, bool foreground) {
//     final color = foreground ? colorBuilder(value) : null;
//     return Icon(
//       iconDataByValue(value),
//       color: color,
//     );
//   }
//
//   IconData iconDataByValue(int? value) => switch (value) {
//     0 => Icons.power_settings_new,
//     1 => Icons.power_settings_new,
//     _ => Icons.lightbulb_outline_rounded,
//   };
// }
