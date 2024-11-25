// import 'package:color_picker_camera/color_picker_camera.dart';

import 'dart:ui';
import 'package:ssss/pages/machines/rcCar/permissionCheck.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

import '../../../logic/JoystickProvider2.dart';

import '../../../utils/appcolors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/helpermethods.dart';
import '../../../utils/images.dart';
import '../../../utils/theme.dart';
import '../../home.dart';
import '../../src/ble/ble_device_connector.dart';
import '../../src/ble/ble_device_interactor.dart';
import '../../src/ble/ble_logger.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../rover/suggestion_box.dart';

class cardummy extends StatelessWidget {
  cardummy({
    required this.characteristic,
    required this.deviceConnector,
    required this.connectionStatus,
    required this.characteristic1,
    super.key,
  });
  final QualifiedCharacteristic characteristic;
  final QualifiedCharacteristic characteristic1;
  final BleDeviceConnector deviceConnector;
  DeviceConnectionState connectionStatus;

  ///update include bledeviceconnector

  @override
  Widget build(BuildContext context) => Consumer4<ConnectionStateUpdate,
          BleDeviceInteractor, BleLogger, BleDeviceConnector>(
      builder:
          (_, connectionStateUpdate, interactor, logger, deviceConnector, __) =>
              dummy1(
                connectionStatus: connectionStateUpdate.connectionState,
                characteristic: characteristic,
                characteristic1: characteristic1,
                // deviceConnector: deviceConnector,
                deviceConnector: deviceConnector,
                readCharacteristic: interactor.readCharacteristic,
                writeWithResponse: interactor.writeCharacterisiticWithResponse,
                subscribeToCharacteristic: interactor.subScribeToCharacteristic,
                discoverServices: interactor.discoverServices,
                // subscribeToCharacteristic: subscribeToCharacteristic,
                writeWithoutResponse:
                    interactor.writeCharacterisiticWithoutResponse,
                messages: logger.messages,
              ));
}

class dummy1 extends StatefulWidget {
  const dummy1({
    super.key,
    required this.characteristic,
    required this.characteristic1,
    required this.deviceConnector,
    required this.connectionStatus,
    required this.readCharacteristic,
    required this.writeWithResponse,
    required this.subscribeToCharacteristic,
    required this.discoverServices,
    required this.writeWithoutResponse,
    required this.messages,
  });

  final QualifiedCharacteristic characteristic;
  final List<String> messages;
  final QualifiedCharacteristic characteristic1;
  final BleDeviceConnector deviceConnector;
  final DeviceConnectionState connectionStatus;
  final Future<List<int>> Function(QualifiedCharacteristic characteristic)
      readCharacteristic;
  final Future<void> Function(
          QualifiedCharacteristic characteristic, List<int> value)
      writeWithResponse;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)
      subscribeToCharacteristic;
  final Future<List<DiscoveredService>> Function(String str) discoverServices;

  final Future<void> Function(
          QualifiedCharacteristic characteristic, List<int> value)
      writeWithoutResponse;

  @override
  State<dummy1> createState() => _dummy1State(
      characteristic,
      readCharacteristic,
      writeWithResponse,
      subscribeToCharacteristic,
      writeWithoutResponse);
}

class _dummy1State extends State<dummy1> {
  QualifiedCharacteristic characteristic;
  Future<List<int>> Function(QualifiedCharacteristic characteristic)
      readCharacteristic;
  Future<void> Function(QualifiedCharacteristic characteristic, List<int> value)
      writeWithResponse;

  Stream<List<int>> Function(QualifiedCharacteristic characteristic)
      subscribeToCharacteristic;

  Future<void> Function(QualifiedCharacteristic characteristic, List<int> value)
      writeWithoutResponse;

  _dummy1State(
      this.characteristic,
      this.readCharacteristic,
      this.writeWithResponse,
      this.subscribeToCharacteristic,
      this.writeWithoutResponse);

  List<String> Deviceidlist = [];
  List<String> Devicenamelist = [];
  List<String> DiscoverServices = [];
  List<String> Hwdevicenamelist = [];

  void getid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> deviceidlist =
        preferences.getStringList('onlyneon_deviceidlist')!;
    final List<String> devicenamelist =
        preferences.getStringList('onlyneon_devicenamelist')!;
    final List<String> discoverServices =
        preferences.getStringList('onlyneon_dslist')!;

    ///
    final List<String> hwdevicenamelist =
        preferences.getStringList('onlyneon_hwdevicenamelist')!;
    setState(() {
      Devicenamelist = devicenamelist;

      /// arrange in alphabetic order
      // Devicenamelist.sort();
      Deviceidlist = deviceidlist;
      DiscoverServices = discoverServices;
      Hwdevicenamelist = hwdevicenamelist;
      var a = preferences.getString("onlyneon_currentdevice");
      if (a != null && a.isNotEmpty) {
        _selectedItem = a.toString();
        Fluttertoast.showToast(msg: _selectedItem);
      }
      if (Devicenamelist.isNotEmpty) {
        if (_selectedItem.isEmpty) {
          _selectedItem = Devicenamelist[0];
        }
      } else {
        // Fluttertoast.showToast(msg: "no device");
        _selectedItem = "No device";
      }
    });
  }

  navigatetohome(BuildContext context) {
    print('Navigating to home...');
    if (mounted) {
      print('Widget is mounted.');
      widget.deviceConnector.disconnect(widget.characteristic.deviceId);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          print('Navigating after delay...');
          try {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomePage(username: '', loggedin: true,)));
          } catch (e) {
            print('Navigation Error: $e');
          }
        } else {
          print('Widget is not mounted after delay.');
        }
      });
    } else {
      print('Widget is not mounted.');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getid();
    });
    super.initState();
    savedDevice();
    subscribeCharacteristic();
    // List<int> code = [82, 10]; //neon code
    // writeCharacteristicWithResponse1(code);
  }

  void savedDevice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('car', widget.characteristic.deviceId);
  }

  late StreamSubscription<List<int>> subscribeStream;
  String strr1 = "";
  List<String> result = [];
  String str = "";
  String str1 = "";

  Future<void> subscribeCharacteristic() async {
    subscribeStream = subscribeToCharacteristic(widget.characteristic1).listen(
      (event) {
        print("event");
        print(event);
        setState(() {
          for (int i = 0; i < event.length; i++) {
            print(String.fromCharCode(event[i]));
            strr1 = strr1 + String.fromCharCode(event[i]);
          }
        });

        setState(() {
          print(strr1);
          // Fluttertoast.showToast(msg: strr1);
          print(strr1.length);
          // if (strr1.length > 0) {
          ///x,1,100,100
          if (strr1.length == 11 ||
              strr1.length == 10 ||
              strr1.length == 9 ||
              strr1.length == 8 ||
              strr1.length == 7) {
            result = strr1.split(',');
            if (result.length == 4) {
              print(result[0]);
              print(result[1]);
              print(result[2]);
              // power status
              if (result[1] == "1") {
              } else if (result[1] == "0") {}
              // brightness status
              print(result[2]);
              // Future.delayed(const Duration(seconds: 1), () async {
              ///working

              // initvalue1=double.parse(result[2])* 12.5;
              // });

              // speed status
              print(result[3]);
              // Future.delayed(const Duration(seconds: 1), () async {
              //   initvalue=double.parse(result[3]);
              ///working
              // });
              strr1 = "";
            }
          }
        });
      },
    );
    // subscribeStream.cancel();
    // setState(() {
    //   subscribeOutput = 'Notification set';
    // });
  }

  writeCharacteristicWithResponse1(List<int> code) {
    // senddata(model,androidver,widget.messages.last);
    widget.writeWithResponse(widget.characteristic, code);
  }

  List<int> stickcode = [];

  void writeCharacteristicWithResponseb(List<int> code) {
    if (stickcode.isEmpty || stickcode.toString() != code.toString()) {
      // Update stickcode with the new command
      setState(() {
        stickcode = code;
      });
      // Send the command to the characteristic
      widget.writeWithResponse(widget.characteristic, code);
    }
  }

  List<int> speedcode = [];

  writeCharacteristicWithResponsespd(List<int> code) {
    // senddata(model,androidver,widget.messages.last);
    if (speedcode.isEmpty == true) {
      setState(() {
        speedcode = code;
      });
      widget.writeWithResponse(widget.characteristic, code);
    } else if (speedcode.toString() == code.toString()) {
    } else {
      setState(() {
        speedcode = code;
      });
      widget.writeWithResponse(widget.characteristic, code);
    }
  }

  @override
  void dispose() {
    subscribeStream?.cancel();
    super.dispose();
  }

  ///

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse("0x$hexColor"));
  }

  _onLogout() {
    widget.deviceConnector.disconnect(widget.characteristic.deviceId);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => const HomePage(
              username: '',
              loggedin: true,
            )));
  }

  bool _isVisible = false;
  Color _currentColor = Colors.blue;
  bool _isRcVisible = false;
  bool isPressed = false;
  bool isBluPressed = false;
  String? textRcValue;
  TextEditingController _oavBoxController = TextEditingController();
  TextEditingController _textRcFieldController = TextEditingController();

  String fixedcolorstat = "true";

  pandelay1() {
    Future.delayed(const Duration(milliseconds: 300), () {
// Here you can write your code

      setState(() {
        fixedcolorstat = "true";
      });
    });
  }

  Color? cp;

  bool stat = false;

  bool lightTheme = true;
  Color currentColor = Colors.amber;
  Color color11 = Colors.red;

  Color statcolor = Colors.green;

  String _selectedItem = '';

  switchd(int found) async {
    // Fluttertoast.showToast(msg: found.toString());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(
        "onlyneon_currentdevice", Devicenamelist[found]);
    final List<DiscoveredService> discoveredServices =
        await widget.discoverServices(Deviceidlist[found]);

    // Fluttertoast.showToast(msg: discoveredServices.toString());
    // final result = await widget.discoverServices(Deviceidlist[found]);
    // Fluttertoast.showToast(msg: discoveredServices.toString());
    int i = 0;
    if (discoveredServices.length > 1) {
      while (i < discoveredServices.length) {
        if (i == 2) {
          DiscoveredService service = discoveredServices[i];
          print('Service ID: ${service.serviceId}');
          print('Characteristic IDs: ${service.characteristicIds}');
          // print('Included Services: ${service.includedServices}');
          // Fluttertoast.showToast(msg: Hwdevicenamelist[found]);
          print(Hwdevicenamelist[found]);
          if (Hwdevicenamelist[found] == "rcCar") {
            if (!mounted) return;

            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return dummy11(
            //     characteristic: QualifiedCharacteristic(
            //       characteristicId: service.characteristicIds[1],
            //       serviceId: service.serviceId,
            //       deviceId: Deviceidlist[found],
            //     ),
            //     deviceConnector: widget.deviceConnector,
            //     connectionStatus: widget.connectionStatus,
            //     characteristic1: QualifiedCharacteristic(
            //       characteristicId: service.characteristicIds[0],
            //       serviceId: service.serviceId,
            //       deviceId: Deviceidlist[found],
            //     ),
            //   );
            // }));
          } else {}
        }
        i++;
      }
    }
  }

  bool vib = true;

  logout(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList('onlyneon_deviceidlist', <String>[]);
    await preferences.setStringList('onlyneon_devicenamelist', <String>[]);
    await preferences.setStringList('onlyneon_dslist', <String>[]);

    ///
    await preferences.setStringList('onlyneon_hwdevicenamelist', <String>[]);
    await preferences.setString(widget.characteristic.deviceId, "");
    widget.deviceConnector.disconnect(widget.characteristic.deviceId);
    if (!mounted) return;
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (BuildContext context) => MainPage()));
  }

  AppTheme aa = AppTheme();
  List<int> lastcode = [];

  Future<void> _handleRefresh() async {
    strr1 = "";
    Fluttertoast.showToast(msg: "Refreshing...");
    List<int> code = [82, 10];
    writeCharacteristicWithResponse1(code);
  }

  sendFun1(List<int> code) {
    if (widget.connectionStatus.toString() ==
        "DeviceConnectionState.connected") {
      writeCharacteristicWithResponseb(code);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bluetooth Connection not found!")));
    }
  }

  sendFun(List<int> code) {
    if (widget.connectionStatus.toString() ==
        "DeviceConnectionState.connected") {
      writeCharacteristicWithResponse1(code);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bluetooth Connection not found!")));
    }
  }

  Offset _joystickPosition =
      const Offset(0, 0); // Joystick's ball initial position
  double _joystickRadius = 100.0; // Radius of the joystick area
  double _ballRadius = 30.0; // Radius of the joystick ball
  Offset _joystickOffset =
      const Offset(0, 0); // To track the joystick's offset position

  void _updateJoystickPosition(Offset details, Size size) {
    // Adjust for the joystick's offset
    final Offset adjustedDetails = details - _joystickOffset;

    // Center of the joystick (where the ball starts)
    final Offset center = Offset(_joystickRadius, _joystickRadius);

    // Calculate the offset from the center of the joystick
    Offset offset = adjustedDetails - center;
    final double distance = offset.distance;

    // Constrain the movement within the joystick's radius
    if (distance > _joystickRadius - _ballRadius) {
      offset =
          Offset.fromDirection(offset.direction, _joystickRadius - _ballRadius);
    }

    setState(() {
      // Convert to a normalized position (-1 to 1) for both X and Y
      _joystickPosition = Offset(
        offset.dx / (_joystickRadius - _ballRadius),
        offset.dy / (_joystickRadius - _ballRadius),
      );
    });

    _printDirectionAndLevel();
  }

  void _resetJoystick() {
    setState(() {
      _joystickPosition = const Offset(0, 0); // Reset to the center position
    });
  }

  void _printDirectionAndLevel() {
    double dx = _joystickPosition.dx;
    double dy = _joystickPosition.dy;

    String? direction;
    int level = _getMovementLevel();

    // Map joystick position to directions and assign the direction character
    if (dx == 0 && dy == 0) {
      direction = "S"; // Stop
      level = 0;
    } else if (dy < 0 && dx.abs() < 0.5) {
      direction = "F"; // Forward
    } else if (dy > 0 && dx.abs() < 0.5) {
      direction = "B"; // Bottom
    } else if (dx > 0 && dy.abs() < 0.5) {
      direction = "R"; // Right
    } else if (dx < 0 && dy.abs() < 0.5) {
      direction = "L"; // Left
    } else if (dx > 0 && dy < 0) {
      direction = "FR"; // Forward-Right
    } else if (dx < 0 && dy < 0) {
      direction = "FL"; // Forward-Left
    } else if (dx > 0 && dy > 0) {
      direction = "BR"; // Bottom-Right
    } else if (dx < 0 && dy > 0) {
      direction = "BL"; // Bottom-Left
    }

    // Send direction and speed only if not center (stop)
    if (direction != "S") {
      String command = "$direction$level";
      sendFun1(command.codeUnits); // Convert string to ASCII values
    }

    print('Direction: $direction, Level: $level');
  }

// Function to calculate the movement level (1 to 5)
  int _getMovementLevel() {
    double distance = _joystickPosition.distance;
    double normalizedDistance = distance / 1.0;

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
  bool isSuggestionShow = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final joystickProvider = Provider.of<JoystickProvider2>(context);
    return WillPopScope(
      onWillPop: () async {
        // return _onLogout();
        return false;
      },

      ///only neon ui
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/carbg.JPG',
                  fit: BoxFit.cover,
                ),
              ),
              // BackdropFilter for the blur effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  color:
                      Colors.black.withOpacity(0.1), // Optional: Overlay color
                ),
              ),
              // Centered container with rounded rectangle
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(20.0), // Rounded corners
                    border: Border.all(
                        color: Colors.white, width: 1), // White border
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
                                    if (widget.connectionStatus.toString() ==
                                        "DeviceConnectionState.connected") {
                                      widget.deviceConnector
                                          .disconnect(characteristic.deviceId);
                                    } else if (widget.connectionStatus
                                            .toString() ==
                                        "DeviceConnectionState.disconnected") {
                                      widget.deviceConnector
                                          .connect(characteristic.deviceId);
                                      subscribeCharacteristic();
                                    } else {}
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
                                    child: widget.connectionStatus.toString() ==
                                        "DeviceConnectionState.connected"?Image.asset(bluetoothOnIcon,height:screenHeight*0.11):Image.asset(bluetoothOffIcon,height:screenHeight*0.11),
                                  ))),
                        ),
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
                            //           true); // Change state to pressed
                            //         },
                            //         onTapUp: (_) {
                            //           setState(() => isPressed =
                            //           false); // Change state back on release
                            //         },
                            //         onTapCancel: () {
                            //           setState(() => isPressed =
                            //           false); // Ensure button resets if tap is canceled
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
                                      navigatetohome(context);

                                      // if (widget.connectionStatus.toString() ==
                                      //               "DeviceConnectionState.connected") {
                                      //             widget.deviceConnector
                                      //                 .disconnect(characteristic.deviceId);
                                      //           }
                                      //           Navigator.pushReplacement(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //                 builder: (context) => const HomePage(
                                      //                     username: "", loggedin: true)),
                                      //           );
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
                                        sendFun([77]);
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
                            Row(
                              children: [
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
                                            sendFun([76, 69]);
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
                                            sendFun([72, 69]);
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
                                            sendFun([82, 69]);
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
                                    color: AppColor.instanse.blurColor.withOpacity(0.8),
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
                                            intValue < 0 ||
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
                                          if (_oavBoxController.text.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text("Enter OAV value")));
                                          } else {
                                            String s = _oavBoxController.text.toString();
                                            String command = "OAV$s";
                                            sendFun(command.codeUnits);
                                          }
                                          Vibration.vibrate();
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

                      ///joystick with pr
                      // Positioned(
                      //   bottom: 20,
                      //   left: screenWidth * 0.07,
                      //   child: GestureDetector(
                      //     onPanUpdate: (details) {
                      //       RenderBox renderBox = context.findRenderObject() as RenderBox;
                      //       Size size = renderBox.size;
                      //       joystickProvider.updateJoystickPosition(details.localPosition, size);
                      //       // sendFun([83]);
                      //     },
                      //     onPanEnd: (details) {
                      //       // sendFun([83]);
                      //       joystickProvider.resetJoystick(); // Reset the ball position to the center when released
                      //     },
                      //     child: Container(
                      //       width: joystickProvider.joystickRadius * 1.4,
                      //       height: joystickProvider.joystickRadius * 1.4,
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         // color: Colors.redAccent
                      //         image: DecorationImage(
                      //           image: AssetImage('assets/images/joystickimg1.png'), // Replace with your local image asset path
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //       child: Stack(
                      //         alignment: Alignment.center, // Center the child widgets
                      //         children: [
                      //           // Joystick ball
                      //           Align(
                      //             alignment: Alignment(joystickProvider.joystickPosition.dx, joystickProvider.joystickPosition.dy),
                      //             child: Container(
                      //               width: joystickProvider.ballRadius * 2.5,
                      //               height: joystickProvider.ballRadius * 2.5,
                      //               decoration: BoxDecoration(
                      //                 shape: BoxShape.circle,
                      //                 gradient: RadialGradient(
                      //                   colors: [
                      //                     Colors.white, // White color towards the center
                      //                     Color.fromRGBO(255, 234, 5, 0.8),
                      //                   ],
                      //                   stops: [0.2, 1.0], // Define how much of the container is green
                      //                   center: Alignment.center, // Center the gradient
                      //                   radius: 1.0, // Set the gradient radius
                      //                 ),
                      //                 boxShadow: [
                      //                   BoxShadow(
                      //                     color: Colors.grey.shade400, // Shadow color
                      //                     spreadRadius: 6, // Spread of the shadow
                      //                     blurRadius: 5, // Blur effect for smooth transition
                      //                     offset: Offset(0, 0), // Position of the shadow
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      ///joystick without pr
                      Positioned(
                        bottom: 20,
                        right: screenWidth * 0.06,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            Vibration.vibrate();
                            RenderBox renderBox =
                                context.findRenderObject() as RenderBox;
                            Size size = renderBox.size;
                            _updateJoystickPosition(
                                details.localPosition, size);
                          },
                          onPanEnd: (details) {
                            sendFun([83]);
                            _resetJoystick(); // Reset the ball position to the center when released
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
                                  alignment: Alignment(_joystickPosition.dx,
                                      _joystickPosition.dy),
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
                                          spreadRadius:
                                              6, // Spread of the shadow
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
            ],
          ),
        ),
      ),
    );
    // }));
  }
}
