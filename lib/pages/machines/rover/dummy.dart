// import 'package:color_picker_camera/color_picker_camera.dart';

import 'dart:ui';
import 'package:ssss/pages/machines/rcCar/permissionCheck.dart';
import 'package:ssss/pages/machines/rover/permissionCheck.dart';
import 'package:ssss/pages/machines/rover/suggestion_box.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

import '../../../logic/JoystickProvider2.dart';

import '../../../utils/appcolors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/helpermethods.dart';
import '../../../utils/images.dart';
import '../../../utils/theme.dart';
import '../../extra/outlineglowborder.dart';
import '../../home.dart';
import '../../src/ble/ble_device_connector.dart';
import '../../src/ble/ble_device_interactor.dart';
import '../../src/ble/ble_logger.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:functional_data/functional_data.dart';
import 'package:provider/provider.dart';

class roverdummy extends StatelessWidget {
  roverdummy({
    required this.characteristic,
    required this.deviceConnector,
    required this.connectionStatus,
    required this.characteristic1,
    Key? key,
  }) : super(key: key);
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
    Key? key,
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
  }) : super(key: key);

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
      this.characteristic,
      this.readCharacteristic,
      this.writeWithResponse,
      this.subscribeToCharacteristic,
      this.writeWithoutResponse);
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
    preferences.setString('rover', widget.characteristic.deviceId);
  }

  late StreamSubscription<List<int>> subscribeStream;
  String strr1 = "";
  List<String> result = [];
  String str = "";
  String str1 = "";
  bool isSuggestionShow = false;

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
        builder: (BuildContext context) => HomePage(
              username: '',
              loggedin: true,
            )));
  }

  bool _isVisible = false;
  Color _currentColor = Colors.blue;
  bool _isRcVisible = false;
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
  bool isBluPressed = false;
  bool isPressed = false;
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
          SnackBar(content: Text("Bluetooth Connection not found!")));
    }
  }

  sendFun(List<int> code) {
    if (widget.connectionStatus.toString() ==
        "DeviceConnectionState.connected") {
      writeCharacteristicWithResponse1(code);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bluetooth Connection not found!")));
    }
  }

  Offset _joystickPosition = Offset(0, 0); // Joystick's ball initial position
  double _joystickRadius = 100.0; // Radius of the joystick area
  double _ballRadius = 30.0; // Radius of the joystick ball
  Offset _joystickOffset =
      Offset(0, 0); // To track the joystick's offset position

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
      _joystickPosition = Offset(0, 0); // Reset to the center position
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

  double _camerasliderValue = 0.0;
  double _drillersliderValue = 0.0;
  double _grippersliderValue = 0.0;
  double _arm1sliderValue = 0.0;
  double _arm2sliderValue = 0.0;

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
                  'assets/images/roverbg.png',
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
              Center(
                child: Container(
                  padding: EdgeInsets.all(8.0),
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
                                        builder: (context) => roverPermissionPage(),
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

                      // Top center text "RC Car"
                      Positioned(
                        top: 20,
                        left: screenWidth * 0.5 - 70, // Center horizontally
                        child: Text(
                          "Rover",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      //oav
                      Positioned(
                        bottom: screenWidth * 0.08,
                        right: screenWidth * 0.28,
                        child:  Column(
                          children: [
                            Container(
                              height: h*0.06,
                              width: w*0.15,
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
                                    contentPadding: const EdgeInsets.only(top: 0,left: 15),
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
                            heightGap(screenHeight * 0.02),
                            Container(
                              height: h*0.06,
                              width: w*0.15,
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
                      ),
                      // 5 sliders
                      ///slider1
                      Positioned(
                        top: screenHeight * 0.275,
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.055,
                        child: UnicornOutlineButtonGlow(
                          radius: 10,
                          strokeWidth: 4,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(36, 187, 68, 0.2),
                              Color.fromRGBO(24, 184, 196, 1),
                              Color.fromRGBO(36, 187, 68, 0.2),
                            ],
                            stops: [0.0, 0.5, 1.0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: screenHeight * 0.7,
                            width: screenWidth * 0.064,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.0518,
                        top: 6,
                        height: screenHeight * 0.84,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius:
                                        14.0), // Custom thumb shape
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape: CustomRoundedRectSliderTrackShape(
                                    radius: 8.0),
                              ),
                              child: Slider(
                                value: _camerasliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  Vibration.vibrate();
                                  setState(() {
                                    _camerasliderValue = value;
                                    if (value > 0 && value < 91) {
                                      String command = "U${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                    if (value < 0 && value > -91) {
                                      String command = "D${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                    if (value == 0) {
                                      String command = "UD${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                    print("camera");
                                    print(value);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.15,
                        left: screenWidth * 0.075,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.07,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '-90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Camera" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2,
                        left: screenWidth * 0.076,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: screenWidth * 0.012,
                            ),
                          ),
                        ),
                      ),

                      ///slider2
                      Positioned(
                        top: screenHeight * 0.275,
                        left: screenWidth * 0.16,
                        bottom: screenHeight * 0.025,
                        child: UnicornOutlineButtonGlow(
                          radius: 10,
                          strokeWidth: 4,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(36, 187, 68, 0.2),
                              Color.fromRGBO(24, 184, 196, 1),
                              Color.fromRGBO(36, 187, 68, 0.2),
                            ],
                            stops: [0.0, 0.5, 1.0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: screenHeight * 0.7,
                            width: screenWidth * 0.064,
                          ),
                        ),
                      ),
                      Positioned(
                        // right: 0,
                        top: 6,
                        // bottom: 0,
                        left: screenWidth * 0.157,
                        height: screenHeight * 0.84,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius:
                                        14.0), // Custom thumb shape
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape: CustomRoundedRectSliderTrackShape1(
                                    radius: 8.0),
                              ),
                              child: Slider(
                                value: _drillersliderValue,
                                // value: _camerasliderValue,
                                min: 0.0,
                                max: 100.0,
                                divisions: 100,
                                onChanged: (value) {
                                  Vibration.vibrate();
                                  setState(() {
                                    _drillersliderValue = value;
                                    print("driller");
                                    print(value);
                                    String command = "M${value.toInt()}";
                                    sendFun(command.codeUnits);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.178,
                        top: screenWidth * 0.15,
                        child: Text(
                          '100',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.186,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Driller" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2,
                        left: screenWidth*0.183,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Driller',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: screenWidth * 0.012,
                            ),
                          ),
                        ),
                      ),

                      ///slider3
                      Positioned(
                        top: screenHeight * 0.275,
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.267,
                        child: UnicornOutlineButtonGlow(
                          radius: 10,
                          strokeWidth: 4,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(36, 187, 68, 0.2),
                              Color.fromRGBO(24, 184, 196, 1),
                              Color.fromRGBO(36, 187, 68, 0.2),
                            ],
                            stops: [0.0, 0.5, 1.0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: screenHeight * 0.7,
                            width: screenWidth * 0.064,
                          ),
                        ),
                      ),
                      Positioned(
                        // right: 0,
                        top: 6,
                        // bottom: 0,
                        left: screenWidth * 0.2633,
                        height: screenHeight * 0.84,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius:
                                        14.0), // Custom thumb shape
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape: CustomRoundedRectSliderTrackShape(
                                    radius: 8.0),
                              ),
                              child: Slider(
                                value: _grippersliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  Vibration.vibrate();
                                  setState(() {
                                    _grippersliderValue = value;
                                    print("gripper");
                                    print(value);
                                    if (value > 0 && value < 91) {
                                      String command = "G${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                    if (value < 0 && value > -91) {
                                      String command = "H${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                    if (value == 0) {
                                      String command = "GH${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.15,
                        left: screenWidth * 0.29,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.28,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '-90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Gripper" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2,
                        left: screenWidth*0.288,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Gripper',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: screenWidth * 0.012,
                            ),
                          ),
                        ),
                      ),

                      ///slider4
                      Positioned(
                        top: screenHeight * 0.275,
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.37,
                        child: UnicornOutlineButtonGlow(
                          radius: 10,
                          strokeWidth: 4,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(36, 187, 68, 0.2),
                              Color.fromRGBO(24, 184, 196, 1),
                              Color.fromRGBO(36, 187, 68, 0.2),
                            ],
                            stops: [0.0, 0.5, 1.0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: screenHeight * 0.7,
                            width: screenWidth * 0.064,
                          ),
                        ),
                      ),
                      Positioned(
                        // right: 0,
                        top: 6,
                        // bottom: 0,
                        left: screenWidth * 0.367,
                        height: screenHeight * 0.84,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius:
                                        14.0), // Custom thumb shape
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape: CustomRoundedRectSliderTrackShape(
                                    radius: 8.0),
                              ),
                              child: Slider(
                                value: _arm1sliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  Vibration.vibrate();
                                  setState(() {
                                    _arm1sliderValue = value;
                                    print("_arm1sliderValue");
                                    print(value);
                                    if (value > 0 && value < 91) {
                                      String command = "I${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                    if (value < 0 && value > -91) {
                                      String command = "J${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                    if (value == 0) {
                                      String command = "IJ${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.15,
                        left: screenWidth * 0.39,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.385,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '-90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Arm 1" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2,
                        left: screenWidth*0.392,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Arm 1',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: screenWidth * 0.012,
                            ),
                          ),
                        ),
                      ),

                      ///slider5
                      Positioned(
                        top: screenHeight * 0.275,
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.473,
                        child: UnicornOutlineButtonGlow(
                          radius: 10,
                          strokeWidth: 4,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(36, 187, 68, 0.2),
                              Color.fromRGBO(24, 184, 196, 1),
                              Color.fromRGBO(36, 187, 68, 0.2),
                            ],
                            stops: [0.0, 0.5, 1.0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: screenHeight * 0.7,
                            width: screenWidth * 0.064,
                          ),
                        ),
                      ),
                      Positioned(
                        // right: 0,
                        top: 6,
                        // bottom: 0,
                        left: screenWidth * 0.47,
                        height: screenHeight * 0.84,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius:
                                        14.0), // Custom thumb shape
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape: CustomRoundedRectSliderTrackShape(
                                    radius: 8.0),
                              ),
                              child: Slider(
                                value: _arm2sliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  Vibration.vibrate();
                                  setState(() {
                                    _arm2sliderValue = value;
                                    print("_arm1sliderValue");
                                    print(value);
                                    if (value > 0 && value < 91) {
                                      String command = "N${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                    if (value < 0 && value > -91) {
                                      String command = "K${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                    if (value == 0) {
                                      String command = "NK${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.15,
                        left: screenWidth * 0.493,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.49,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '-90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Arm 2" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2,
                        left: screenWidth * 0.495,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Arm 2',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: screenWidth * 0.012,
                            ),
                          ),
                        ),
                      ),

                      ///adjust code
                      Positioned(
                          top: 0,
                          bottom: screenHeight * 0.58,
                          right: screenWidth * 0.17,
                          left: screenWidth * 0.35,
                          child: Container(
                            color: Colors.transparent,
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
                            //     border:
                            //         Border.all(color: Colors.white, width: 1),
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
                            //                   roverPermissionPage(),
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
                                border:
                                    Border.all(color: Colors.white, width: 1),
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
                                      //     "DeviceConnectionState.connected") {
                                      //   widget.deviceConnector.disconnect(
                                      //       characteristic.deviceId);
                                      // }
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const HomePage(
                                      //               username: "",
                                      //               loggedin: true)),
                                      // );
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

                      ///joystick
                      Positioned(
                        bottom: 20,
                        right: screenWidth * 0.03,
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
                            sendFun([48]);
                            _resetJoystick(); // Reset the ball position to the center when released
                          },
                          child: Container(
                            width: _joystickRadius * 1.85,
                            height: _joystickRadius * 1.85,
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
                                  alignment: Alignment(_joystickPosition.dx,
                                      _joystickPosition.dy),
                                  child: Container(
                                    width: joystickProvider.ballRadius * 3,
                                    height: joystickProvider.ballRadius * 3,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors
                                              .white, // White color towards the center
                                          Color.fromRGBO(81, 241, 105, 1),
                                        ],
                                        stops: [
                                          0.2,
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
                      )
                    ],
                  ),
                ),
              ),
              isSuggestionShow == true?
              Positioned(
                  top: screenHeight*0.04,
                  right: screenWidth*0.25,
                  child: ObstacleValueCard()):SizedBox()
            ],
          ),
        ),
      ),
    );
    // }));
  }
}

class CustomRoundedRectSliderTrackShape extends SliderTrackShape {
  final double radius;

  CustomRoundedRectSliderTrackShape({required this.radius});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset? offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset!.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 95;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    Offset? secondaryOffset,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activeTrackPaint = Paint()
      ..color = sliderTheme.activeTrackColor!;
    final Paint inactiveTrackPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;

    // Draw the inactive track with rounded corners
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(radius)),
      inactiveTrackPaint,
    );

    // Draw the active track (from center to thumb position)
    final double centerX = trackRect.left + (trackRect.width / 2);
    final Rect activeTrackRect = Rect.fromLTRB(
      centerX,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeTrackRect, Radius.circular(radius)),
      activeTrackPaint,
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  final double enabledThumbRadius;

  const CustomSliderThumbShape({required this.enabledThumbRadius});

  @override
  Size getPreferredSize(bool isDiscrete, bool isEnabled) {
    return Size(enabledThumbRadius * 2, enabledThumbRadius * 2);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
  }) {
    final Paint paint = Paint()..color = sliderTheme.activeTrackColor!;

    // Draw round rectangle shape for the thumb
    final Rect thumbRect = Rect.fromCenter(
        center: center,
        width: enabledThumbRadius * 2,
        height: enabledThumbRadius);
    // context.canvas.drawRRect(
    //   RRect.fromRectAndRadius(thumbRect, Radius.circular(enabledThumbRadius)),
    //   paint,
    // );
  }
}

class CustomRoundedRectSliderTrackShape1 extends SliderTrackShape {
  final double radius;

  CustomRoundedRectSliderTrackShape1({required this.radius});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset? offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset!.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 95;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    Offset? secondaryOffset,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activeTrackPaint = Paint()
      ..color = sliderTheme.activeTrackColor!;
    final Paint inactiveTrackPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;

    // Draw the inactive track with rounded corners
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(radius)),
      inactiveTrackPaint,
    );

    // Draw the active track (left side of the thumb) with rounded corners
    final Rect activeTrackRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeTrackRect, Radius.circular(radius)),
      activeTrackPaint,
    );
  }
}

class CustomSliderThumbShape1 extends SliderComponentShape {
  final double enabledThumbRadius;

  const CustomSliderThumbShape1({required this.enabledThumbRadius});

  @override
  Size getPreferredSize(bool isDiscrete, bool isEnabled) {
    return Size(enabledThumbRadius * 2, enabledThumbRadius * 2);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
  }) {
    // Remove thumb drawing
  }
}

///OLD CODE
/*
// import 'package:color_picker_camera/color_picker_camera.dart';

import 'dart:ui';
import 'package:aerobin/pages/machines/rcCar/permissionCheck.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../logic/JoystickProvider2.dart';
import '../../../utils/appcolors.dart';
import '../../../utils/helpermethods.dart';
import '../../../utils/theme.dart';
import '../../home.dart';
import '../../src/ble/ble_device_connector.dart';
import '../../src/ble/ble_device_interactor.dart';
import '../../src/ble/ble_logger.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:functional_data/functional_data.dart';
import 'package:provider/provider.dart';

class dummy extends StatelessWidget {
  dummy({
    required this.characteristic,
    required this.deviceConnector,
    required this.connectionStatus,
    required this.characteristic1,
    Key? key,
  }) : super(key: key);
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
    Key? key,
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
  }) : super(key: key);

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
      this.characteristic,
      this.readCharacteristic,
      this.writeWithResponse,
      this.subscribeToCharacteristic,
      this.writeWithoutResponse);
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
    preferences.setString('rover', widget.characteristic.deviceId);
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
        builder: (BuildContext context) => HomePage(
              username: '',
              loggedin: true,
            )));
  }

  bool _isVisible = false;
  Color _currentColor = Colors.blue;
  bool _isRcVisible = false;
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
          SnackBar(content: Text("Bluetooth Connection not found!")));
    }
  }

  sendFun(List<int> code) {
    if (widget.connectionStatus.toString() ==
        "DeviceConnectionState.connected") {
      writeCharacteristicWithResponse1(code);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bluetooth Connection not found!")));
    }
  }

  Offset _joystickPosition = Offset(0, 0); // Joystick's ball initial position
  double _joystickRadius = 100.0; // Radius of the joystick area
  double _ballRadius = 30.0; // Radius of the joystick ball
  Offset _joystickOffset =
      Offset(0, 0); // To track the joystick's offset position

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
      _joystickPosition = Offset(0, 0); // Reset to the center position
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

  double _camerasliderValue = 0.0;
  double _drillersliderValue = 0.0;
  double _grippersliderValue = 0.0;
  double _arm1sliderValue = 0.0;
  double _arm2sliderValue = 0.0;

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
                  'assets/images/roverbg.png',
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
              Center(
                child: Container(
                  padding: EdgeInsets.all(screenHeight*0.022),
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
                        left: screenHeight * 0.04,
                        child: GestureDetector(
                          onTap: (){
                            if (widget.connectionStatus.toString() ==
                                "DeviceConnectionState.connected") {
                              widget.deviceConnector.disconnect(
                                  characteristic.deviceId);
                            } else if (widget.connectionStatus
                                .toString() ==
                                "DeviceConnectionState.disconnected") {
                              widget.deviceConnector
                                  .connect(characteristic.deviceId);
                              subscribeCharacteristic();
                            } else {
                              // Fluttertoast.showToast(msg: "Connecting");
                              // if (widget.connectionStatus.toString() ==
                              //     "DeviceConnectionState.connected") {
                              //
                              // } else {
                              //
                              // }
                            }
                          },
                          child: Container(
                            height: screenHeight * 0.14,
                            width: screenHeight * 0.14,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.bluetooth, color: widget.connectionStatus.toString() ==
                                "DeviceConnectionState.connected"
                                ? Colors.green
                                : Colors.red),
                          ),
                        ),
                      ),
                      // Top right two square containers with asset images
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => carPermissionPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white, width: 1),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/pair.png'), // Replace with your asset image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8), // Spacing between images
                            InkWell(
                              onTap: (){
                                if (widget.connectionStatus.toString() ==
                                    "DeviceConnectionState.connected") {
                                  widget.deviceConnector
                                      .disconnect(characteristic.deviceId);
                                }
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomePage(username: "", loggedin: true)),
                                );

                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white, width: 1),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/homearrow.png'), // Replace with your asset image
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Top center text "RC Car"
                      Positioned(
                        top: 20,
                        left: screenWidth * 0.5 - 70, // Center horizontally
                        child: Text(
                          "Rover",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      //oav
                      Positioned(
                        top: 80,
                        left: 16,
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: AppColor.instanse.blurColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: AppColor.instanse.colorWhite
                                        .withOpacity(0.8)),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "OAV",
                                  hintStyle: aa.hintStyle,
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
                            GestureDetector(
                              onTap: () {
                                if (_oavBoxController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Enter OAV value")));
                                } else {
                                  String s = _oavBoxController.text.toString();
                                  String command = "OAV$s";
                                  sendFun(command.codeUnits);
                                }
                              },
                              child: Container(
                                width: 70,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15),
                                decoration: BoxDecoration(
                                  color: AppColor.instanse.colorWhite,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1,
                                      color: AppColor.instanse.colorWhite
                                          .withOpacity(0.6)),
                                ),
                                child: Text(
                                  "Set",
                                  style: aa.newSetText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 5 sliders
                      ///slider1
                      Positioned(
                        top: screenHeight * 0.29,
                        // bottom: 10,
                        ///align issue
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.37,
                        child: Container(
                          height: screenHeight * 0.25,
                          width: screenWidth * 0.0725,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(36, 187, 68, 0.2),
                                Color.fromRGBO(24, 184, 196, 1),
                                Color.fromRGBO(36, 187, 68, 0.2),
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            width: screenWidth * 0.01,
                            height: screenWidth * 0.01,
                          ),
                        ),
                      ),
                      Positioned(
                        right: screenWidth * 0.475,
                        top: 6,
                        height: screenHeight * 0.85,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius:
                                    14.0), // Custom thumb shape
                                overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape: CustomRoundedRectSliderTrackShape(
                                    radius: 8.0),
                              ),
                              child: Slider(
                                value: _camerasliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  setState(() {
                                    _camerasliderValue = value;
                                    if(value>0 && value<91){
                                      String command = "U${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }if(value<0 && value>-91){
                                      String command = "D${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }if(value==0){
                                      String command = "UD${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                    print("camera");
                                    print(value);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.15,
                        left: screenWidth * 0.395,

                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.395,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '-90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      // Fixed text "Driller" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2,
                        left: MediaQuery.of(context).size.width / 2.29,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///slider2
                      Positioned(
                        top: screenHeight * 0.29,
                        left: screenWidth * 0.48,
                        bottom: screenHeight * 0.025,
                        child: Container(
                          height: 245,
                          width: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(36, 187, 68, 0.2),
                                Color.fromRGBO(24, 184, 196, 1),
                                Color.fromRGBO(36, 187, 68, 0.2),
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            width: screenWidth * 0.01,
                            height: screenWidth * 0.01,
                          ),
                        ),
                      ),
                      Positioned(
                        // right: 0,
                        top: 6,
                        // bottom: 0,
                        left: screenWidth * 0.48,
                        height: screenHeight * 0.85,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius: 14.0), // Custom thumb shape
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape: CustomRoundedRectSliderTrackShape1(
                                    radius: 8.0),
                              ),
                              child: Slider(
                                value: _drillersliderValue,
                                // value: _camerasliderValue,
                                min: 0.0,
                                max: 100.0,
                                divisions: 100,
                                onChanged: (value) {
                                  setState(() {
                                    _drillersliderValue = value;
                                    print("driller");
                                    print(value);
                                    String command = "M${value.toInt()}";
                                     sendFun(command.codeUnits);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.5,
                        top: screenWidth * 0.15,
                        child: Text(
                          '100',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.51,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Driller" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2,
                        left: MediaQuery.of(context).size.width / 1.81,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Driller',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///slider3
                      Positioned(
                        top: screenHeight * 0.29,
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.595,
                        child: Container(
                          height: screenHeight * 0.25,
                          width: screenWidth * 0.0725,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(36, 187, 68, 0.2),
                                Color.fromRGBO(24, 184, 196, 1),
                                Color.fromRGBO(36, 187, 68, 0.2),
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            width: screenWidth * 0.01,
                            height: screenWidth * 0.01,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        // bottom: 0,
                        left: screenWidth * 0.596,
                        height: screenHeight * 0.85,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius:
                                    14.0), // Custom thumb shape
                                overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape: CustomRoundedRectSliderTrackShape(
                                    radius: 8.0),
                              ),
                              child: Slider(
                                value: _grippersliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  setState(() {
                                    _grippersliderValue = value;
                                    print("gripper");
                                    print(value);
                                    if(value>0 && value<91){
                                      String command = "G${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }if(value<0 && value>-91){
                                      String command = "H${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }if(value==0){
                                      String command = "GH${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.15,
                        left: screenWidth * 0.62,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.615,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '-90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      // Fixed text "Driller" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2,
                        left: MediaQuery.of(context).size.width / 1.5,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Gripper',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///slider4
                      Positioned(
                        top: screenHeight * 0.29,
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.71,
                        child: Container(
                          height: screenHeight * 0.25,
                          width: screenWidth * 0.0725,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(36, 187, 68, 0.2),
                                Color.fromRGBO(24, 184, 196, 1),
                                Color.fromRGBO(36, 187, 68, 0.2),
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            width: screenWidth * 0.01,
                            height: screenWidth * 0.01,
                          ),
                        ),
                      ),

                      Positioned(
                        top: 6,
                        // bottom: 0,
                        left: screenWidth * 0.48,
                        height: screenHeight * 0.85,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius:
                                    14.0), // Custom thumb shape
                                overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape: CustomRoundedRectSliderTrackShape(
                                    radius: 8.0),
                              ),
                              child: Slider(
                                value: _arm1sliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  setState(() {
                                    _arm1sliderValue = value;
                                    print("_arm1sliderValue");
                                    print(value);
                                    if(value>0 && value<91){
                                      String command = "I${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }if(value<0 && value>-91){
                                      String command = "J${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }if(value==0){
                                      String command = "IJ${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),


                      Positioned(
                        top: screenWidth * 0.15,
                        left: screenWidth * 0.74,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.735,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '-90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Arm 1" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2,
                        left: MediaQuery.of(context).size.width / 1.28,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Arm 1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///slider5
                      Positioned(
                        top: screenHeight * 0.29,
                        bottom: 10,
                        left: screenWidth * 0.82,
                        child: Container(
                          height: 245,
                          width: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(36, 187, 68, 0.2),
                                Color.fromRGBO(24, 184, 196, 1),
                                Color.fromRGBO(36, 187, 68, 0.2),
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ),
                      Positioned(
                        // right: 0,
                        top: 0,
                        // bottom: 0,
                        left: screenWidth * 0.821,
                        height: screenHeight* 0.85,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius:
                                    14.0), // Custom thumb shape
                                overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape: CustomRoundedRectSliderTrackShape(
                                    radius: 8.0),
                              ),
                              child: Slider(
                                value: _arm2sliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  setState(() {
                                    _arm2sliderValue = value;
                                    print("_arm1sliderValue");
                                    print(value);
                                    if(value>0 && value<91){
                                      String command = "N${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }if(value<0 && value>-91){
                                      String command = "K${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }if(value==0){
                                      String command = "NK${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: screenWidth * 0.845,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.845,
                        bottom: 18,
                        child: Text(
                          '-90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      // Fixed text "Driller" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2 + 5,
                        // left: MediaQuery.of(context).size.width / 1,
                        right: screenWidth * 0.0008,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Arm 2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///joystick
                      Positioned(
                        bottom: 20,
                        left: screenWidth * 0.07,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                            Size size = renderBox.size;
                            _updateJoystickPosition(
                                details.localPosition, size);
                          },
                          onPanEnd: (details) {
                            sendFun([48]);
                            _resetJoystick();// Reset the ball position to the center when released
                          },
                          child: Container(
                            width: _joystickRadius * 1.4,
                            height: _joystickRadius * 1.4,
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
                                  alignment: Alignment(_joystickPosition.dx,
                                      _joystickPosition.dy),
                                  child: Container(
                                    width: joystickProvider.ballRadius * 2.5,
                                    height: joystickProvider.ballRadius * 2.5,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors
                                              .white, // White color towards the center
                                          Color.fromRGBO(81, 241, 105, 1),
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
                      )
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
class CustomRoundedRectSliderTrackShape extends SliderTrackShape {
  final double radius;

  CustomRoundedRectSliderTrackShape({required this.radius});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset? offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset!.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 95;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset thumbCenter,
        bool isEnabled = false,
        bool isDiscrete = false,
        Offset? secondaryOffset,
        required TextDirection textDirection,
      }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activeTrackPaint = Paint()
      ..color = sliderTheme.activeTrackColor!;
    final Paint inactiveTrackPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;

    // Draw the inactive track with rounded corners
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(radius)),
      inactiveTrackPaint,
    );

    // Draw the active track (from center to thumb position)
    final double centerX = trackRect.left + (trackRect.width / 2);
    final Rect activeTrackRect = Rect.fromLTRB(
      centerX,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeTrackRect, Radius.circular(radius)),
      activeTrackPaint,
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  final double enabledThumbRadius;

  const CustomSliderThumbShape({required this.enabledThumbRadius});

  @override
  Size getPreferredSize(bool isDiscrete, bool isEnabled) {
    return Size(enabledThumbRadius * 2, enabledThumbRadius * 2);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double textScaleFactor,
        required double value,
        required RenderBox parentBox,
        required Size sizeWithOverflow,
      }) {
    final Paint paint = Paint()..color = sliderTheme.activeTrackColor!;

    // Draw round rectangle shape for the thumb
    final Rect thumbRect = Rect.fromCenter(
        center: center,
        width: enabledThumbRadius * 2,
        height: enabledThumbRadius);
    // context.canvas.drawRRect(
    //   RRect.fromRectAndRadius(thumbRect, Radius.circular(enabledThumbRadius)),
    //   paint,
    // );
  }
}


class CustomRoundedRectSliderTrackShape1 extends SliderTrackShape {
  final double radius;

  CustomRoundedRectSliderTrackShape1({required this.radius});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset? offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset!.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 95;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset thumbCenter,
        bool isEnabled = false,
        bool isDiscrete = false,
        Offset? secondaryOffset,
        required TextDirection textDirection,
      }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activeTrackPaint = Paint()
      ..color = sliderTheme.activeTrackColor!;
    final Paint inactiveTrackPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;

    // Draw the inactive track with rounded corners
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(radius)),
      inactiveTrackPaint,
    );

    // Draw the active track (left side of the thumb) with rounded corners
    final Rect activeTrackRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeTrackRect, Radius.circular(radius)),
      activeTrackPaint,
    );
  }
}

class CustomSliderThumbShape1 extends SliderComponentShape {
  final double enabledThumbRadius;

  const CustomSliderThumbShape1({required this.enabledThumbRadius});

  @override
  Size getPreferredSize(bool isDiscrete, bool isEnabled) {
    return Size(enabledThumbRadius * 2, enabledThumbRadius * 2);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double textScaleFactor,
        required double value,
        required RenderBox parentBox,
        required Size sizeWithOverflow,
      }) {
    // Remove thumb drawing
  }
}*/
