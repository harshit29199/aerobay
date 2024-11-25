// import 'package:color_picker_camera/color_picker_camera.dart';

import 'dart:ui';
import 'package:ssss/pages/machines/rcCar/permissionCheck.dart';
import 'package:ssss/pages/machines/windTunnel/permissionCheck.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

import '../../../logic/JoystickProvider2.dart';

import '../../../utils/appcolors.dart';
import '../../../utils/helpermethods.dart';
import '../../../utils/images.dart';
import '../../../utils/theme.dart';
import '../../extra/outlineborder.dart';
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

class Winddummy extends StatelessWidget {
  Winddummy({
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
    preferences.setString('windTunnel', widget.characteristic.deviceId);
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

  double _aoasliderValue = 0.0;
  double _suctionsliderValue = 0.0;
  double _airflowsliderValue = 0.0;
  double _axisysliderValue = 0.0;
  double _axisxsliderValue = 0.0;
  double _axialmotionsliderValue = 0.0;
  bool isPressed = false;
  bool isPressed1 = false;
  bool isPressed2 = false;
  bool isPressed3 = false;
  bool isPressed4 = false;
  bool isPressed5 = false;
  bool isPressed6 = false;

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
                  'assets/images/windbg.png',
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
                  // padding: EdgeInsets.all(8.0),
                  ///align issue
                  padding: EdgeInsets.all(screenHeight * 0.022),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    border:
                    Border.all(color: Colors.white, width: 1), // White border
                  ),
                  width: screenWidth * 0.94, // Width of the container
                  height: screenHeight * 0.9, // Height of the container
                  child: Stack(
                    children: [
                      // Top center text "RC Car"
                      Positioned(
                        // top: 20,
                        // left: screenWidth * 0.5 - 70, // Center horizontally
                        top: screenWidth * 0.027,
                        left: screenWidth * 0.37,
                        child: Text(
                          "Wind Tunnel",
                          style: TextStyle(
                            // fontSize: 24,
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // 5 sliders
                      ///slider1 aligned
                      Positioned(
                        top: screenHeight * 0.269,
                        // bottom: 10,
                        ///align issue
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.023,
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
                        right: screenWidth * 0.827,
                        top: 0,
                        height: screenHeight * 0.86,
                        width: screenWidth * 0.07,
                        child: Container(
                          // height: screenHeight * 0.1,
                          // width: screenWidth * 0.0725,
                          // color: Colors.red,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.024),
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
                                  value: _aoasliderValue,
                                  min: -90.0,
                                  max: 90.0,
                                  divisions: 181,
                                  onChanged: (value) {
                                    Vibration.vibrate(duration: 140);
                                    setState(() {
                                      _aoasliderValue = value;
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
                                      print("angle of attack");
                                      print(value);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        // child: Container(color: Colors.red,),
                      ),
                      Positioned(
                        top: screenWidth * 0.15,
                        left: screenWidth * 0.045,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.04,
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
                        top: MediaQuery.of(context).size.height / 2.4,
                        left: screenWidth * 0.09,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Angle of Attack',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.018,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///slider2 aligned
                      Positioned(
                        top: screenHeight * 0.269,
                        left: screenWidth * 0.13,
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
                        top: screenWidth * 0,
                        // bottom: 0,
                        left: screenWidth * 0.132,
                        height: screenHeight * 0.86,
                        width: screenWidth * 0.06,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.024),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius: 14.0), // Custom thumb shape
                                overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape:
                                CustomRoundedRectSliderTrackShape(radius: 8.0),
                              ),
                              child: Slider(
                                value: _axialmotionsliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  Vibration.vibrate(duration: 140);
                                  setState(() {
                                    _axialmotionsliderValue = value;
                                    print("axial motion");
                                    print(value);
                                    if(value>0 && value<91){
                                      String command = "E${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }if(value<0 && value>-91){
                                      String command = "F${value.toInt()}";
                                      sendFun(command.codeUnits);
                                    }if(value==0){
                                      String command = "EF${value.toInt()}";
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
                        left: screenWidth * 0.15,
                        top: screenWidth * 0.15,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.146,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '-90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Driller" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2.3,
                        left: screenWidth * 0.2,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Axial Motion',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.018,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///slider3 aligned
                      Positioned(
                        top: screenHeight * 0.269,
                        left: screenWidth * 0.24,
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
                        top: screenWidth * 0,
                        // bottom: 0,
                        left: screenWidth * 0.237,
                        height: screenHeight * 0.86,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.024),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius: 14.0), // Custom thumb shape
                                overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape:
                                CustomRoundedRectSliderTrackShape(radius: 8.0),
                              ),
                              child: Slider(
                                value: _axisxsliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  Vibration.vibrate(duration: 140);
                                  setState(() {
                                    _axisxsliderValue = value;
                                    print("axis x");
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
                        left: screenWidth * 0.262,
                        top: screenWidth * 0.15,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.256,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '-90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Driller" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2.1,
                        left: screenWidth * 0.31,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Axis X',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.018,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///slider4
                      Positioned(
                        top: screenHeight * 0.269,
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.595,
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
                        top: screenWidth * 0,
                        // bottom: 0,
                        left: screenWidth * 0.592,
                        height: screenHeight * 0.86,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.024),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius: 14.0), // Custom thumb shape
                                overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape:
                                CustomRoundedRectSliderTrackShape(radius: 8.0),
                              ),
                              child: Slider(
                                value: _axisysliderValue,
                                min: -90.0,
                                max: 90.0,
                                divisions: 181,
                                onChanged: (value) {
                                  Vibration.vibrate(duration: 140);
                                  setState(() {
                                    _axisysliderValue = value;
                                    print("axisy");
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
                        left: screenWidth * 0.616,
                        child: Text(
                          '90',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.612,
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
                        left: MediaQuery.of(context).size.width / 1.5,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Axis Y',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.018,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///slider5
                      Positioned(
                        top: screenHeight * 0.269,
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.71,
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
                        top: screenWidth * 0,
                        // bottom: 0,
                        left: screenWidth * 0.707,
                        height: screenHeight * 0.86,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.024),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius: 14.0), // Custom thumb shape
                                overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape:
                                CustomRoundedRectSliderTrackShape1(radius: 8.0),
                              ),
                              child: Slider(
                                value: _airflowsliderValue,
                                // value: _camerasliderValue,
                                min: 0.0,
                                max: 100.0,
                                divisions: 100,
                                onChanged: (value) {
                                  Vibration.vibrate(duration: 140);
                                  setState(() {
                                    _airflowsliderValue = value;
                                    print("airflow");
                                    print(value);
                                    String command = "AF${value.toInt()}";
                                    sendFun(command.codeUnits);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.15,
                        left: screenWidth * 0.728,
                        child: Text(
                          '100',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.738,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Arm 1" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2.1,
                        left: MediaQuery.of(context).size.width / 1.28,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Air Flow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.018,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///slider6
                      Positioned(
                        top: screenHeight * 0.269,
                        bottom: screenHeight * 0.025,
                        left: screenWidth * 0.82,
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
                        top: screenWidth * 0,
                        // bottom: 0,
                        left: screenWidth * 0.817,
                        height: screenHeight * 0.86,
                        width: screenWidth * 0.07,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.024),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 42.0,
                                thumbShape: CustomSliderThumbShape(
                                    enabledThumbRadius: 14.0), // Custom thumb shape
                                overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0.0),
                                activeTrackColor: Colors.grey,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                trackShape:
                                CustomRoundedRectSliderTrackShape1(radius: 8.0),
                              ),
                              child: Slider(
                                value: _suctionsliderValue,
                                // value: _camerasliderValue,
                                min: 0.0,
                                max: 100.0,
                                divisions: 100,
                                onChanged: (value) {
                                  // Vibration.vibrate(duration: 15, amplitude: 8);
                                  Vibration.vibrate(duration: 140);
                                  setState(() {
                                    _suctionsliderValue = value;
                                    print("suction");
                                    print(value);
                                    String command = "S${value.toInt()}";
                                    sendFun(command.codeUnits);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.15,
                        left: screenWidth * 0.837,
                        child: Text(
                          '100',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.848,
                        bottom: screenWidth * 0.024,
                        child: Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.016,
                          ),
                        ),
                      ),
                      // Fixed text "Arm 2" in the center of the track
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2.1,
                        // left: MediaQuery.of(context).size.width / 1,
                        right: screenWidth * 0.0008,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Suction',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.018,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///adjust code
                      Positioned(
                          top: 0,
                          bottom: screenHeight * 0.58,
                          right: screenWidth * 0.02,
                          left:screenWidth * 0.02 ,
                          child: Container(
                            color: Colors.transparent,
                          )
                      ),
                      /// Top right two square containers with asset images
                      Positioned(
                        // top: 16,
                        // right: 16,
                        top: screenHeight * 0.04,
                        right: screenHeight * 0.04,
                        child: Row(
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => carPermissionPage(),
                            //       ),
                            //     );
                            //   },
                            //   child: Container(
                            //     height: screenHeight * 0.14,
                            //     width: screenHeight * 0.14,
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: BorderRadius.circular(10),
                            //       border: Border.all(color: Colors.white, width: 1),
                            //       image: DecorationImage(
                            //         image: AssetImage(
                            //             'assets/images/pair.png'), // Replace with your asset image
                            //         fit: BoxFit.cover,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Container(
                            //   height: screenHeight * 0.14,
                            //   width: screenHeight * 0.14,
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
                            //                   windPermissionPage(),
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
                            SizedBox(
                                width:
                                screenHeight * 0.03), // Spacing between images
                            Container(
                              height: screenHeight * 0.14,
                              width: screenHeight * 0.14,
                              decoration: BoxDecoration(

                                border: Border.all(color: Colors.white, width: 1),
                                color: isPressed1 ? Colors.grey[300] : Colors.white, // Changes color on press
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: isPressed1 // Adds shadow to simulate press effect
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
                                  onTap: (){
                                    Vibration.vibrate();
                                    navigatetohome(context);

                                    // if (widget.connectionStatus.toString() ==
                                    //     "DeviceConnectionState.connected") {
                                    //   widget.deviceConnector
                                    //       .disconnect(characteristic.deviceId);
                                    // }
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => const HomePage(
                                    //           username: "", loggedin: true)),
                                    // );
                                  },
                                  onTapDown: (_) {
                                    setState(() => isPressed1 = true); // Change state to pressed
                                  },
                                  onTapUp: (_) {
                                    setState(() => isPressed1 = false); // Change state back on release
                                  },
                                  onTapCancel: () {
                                    setState(() => isPressed1 = false); // Ensure button resets if tap is canceled
                                  },
                                  splashColor: Colors.redAccent.withOpacity(0.3), // Customize splash color
                                  borderRadius: BorderRadius.circular(10),
                                  child: Center(
                                    child: Image.asset("assets/images/homearrow.png"),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      /// Top left circular container with asset image
                      Positioned(
                          top: screenHeight * 0.04,
                          left: screenHeight * 0.04,
                          child: Container(
                            height: screenHeight * 0.14,
                            width: screenHeight * 0.14,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              color: isPressed ? Colors.grey[300] : Colors.white, // Changes color on press
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isPressed // Adds shadow to simulate press effect
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
                                      builder: (context) => windPermissionPage(),
                                    ),
                                  );
                                },
                                onTap: (){
                                  Vibration.vibrate(duration: 140);
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
                                onTapDown: (_) {
                                  setState(() => isPressed = true); // Change state to pressed
                                },
                                onTapUp: (_) {
                                  setState(() => isPressed = false); // Change state back on release
                                },
                                onTapCancel: () {
                                  setState(() => isPressed = false); // Ensure button resets if tap is canceled
                                },
                                splashColor: Colors.redAccent.withOpacity(0.3), // Customize splash color
                                borderRadius: BorderRadius.circular(10),
                                child: Center(
                                  child: widget.connectionStatus.toString() ==
                                      "DeviceConnectionState.connected"?Image.asset(bluetoothOnIcon,height:screenHeight*0.11):Image.asset(bluetoothOffIcon,height:screenHeight*0.11),



                                  // child: Icon(Icons.bluetooth, color: widget.connectionStatus.toString() ==
                                  //     "DeviceConnectionState.connected"
                                  //     ? Colors.green
                                  //     : Colors.red),
                                ),
                              ),
                            ),
                          )
                      ),
                      /// center container with 4 button
                      Positioned(
                        top: screenHeight * 0.3,
                        left: screenHeight * 0.73,
                        child: UnicornOutlineButton(
                          radius: 16,
                          strokeWidth: 4,
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 0.7,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              AppColor.instanse.newGradient,
                            ],
                            stops: const [0.5, 0.6, 1.0],
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(7),
                            padding: const EdgeInsets.all(8),
                            // height: screenHeight * 0.55,
                            height: screenHeight * 0.455,
                            // width: screenWidth * 0.26,
                            width: screenWidth * 0.215,
                            decoration: BoxDecoration(
                                color: AppColor.instanse.borderWhite.withOpacity(0.5),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: screenHeight * 0.19,
                                      width: screenWidth * 0.09,
                                      decoration: BoxDecoration(
                                        // color: AppColor.instanse.newWhite,
                                        // borderRadius: BorderRadius.circular(10),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.black.withOpacity(0.1),
                                        //     offset: const Offset(5, 5),
                                        //     blurRadius: 8,
                                        //     spreadRadius: 1,
                                        //   ),
                                        //   BoxShadow(
                                        //     color: Colors.black.withOpacity(0.1),
                                        //     offset: const Offset(5, 5),
                                        //     blurRadius: 8,
                                        //     spreadRadius: 1,
                                        //   ),
                                        // ],
                                        ///
                                        border: Border.all(color: Colors.white, width: 1),
                                        color: isPressed4 ? Colors.grey[300] : Colors.white, // Changes color on press
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: isPressed4 // Adds shadow to simulate press effect
                                            ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(2, 2),
                                          )
                                        ]
                                            : [],
                                      ),
                                      child: InkWell(
                                        onTap: (){
                                          Vibration.vibrate(duration: 140);
                                          sendFun([76, 69]);
                                        },
                                        onTapDown: (_) {
                                          setState(() => isPressed4 = true); // Change state to pressed
                                        },
                                        onTapUp: (_) {
                                          setState(() => isPressed4 = false); // Change state back on release
                                        },
                                        onTapCancel: () {
                                          setState(() => isPressed4 = false); // Ensure button resets if tap is canceled
                                        },
                                        splashColor: Colors.redAccent.withOpacity(0.3), // Customize splash color
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/led.png",
                                              height: screenHeight * 0.085,
                                            ),
                                            heightGap(screenHeight * 0.01),
                                            Text(
                                              "LED",
                                              style: aa.innerUiStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: screenHeight * 0.19,
                                      width: screenWidth * 0.09,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 1),
                                        color: isPressed5 ? Colors.grey[300] : Colors.white, // Changes color on press
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: isPressed5 // Adds shadow to simulate press effect
                                            ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(2, 2),
                                          )
                                        ]
                                            : [],
                                      ),
                                      child: InkWell(
                                        onTap: (){
                                          Vibration.vibrate(duration: 140);
                                          sendFun([77, 49]);
                                        },
                                        onTapDown: (_) {
                                          setState(() => isPressed5 = true); // Change state to pressed
                                        },
                                        onTapUp: (_) {
                                          setState(() => isPressed5 = false); // Change state back on release
                                        },
                                        onTapCancel: () {
                                          setState(() => isPressed5 = false); // Ensure button resets if tap is canceled
                                        },
                                        splashColor: Colors.redAccent.withOpacity(0.3),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/mist.png",
                                              height: screenHeight * 0.085,
                                            ),
                                            heightGap(screenHeight * 0.01),
                                            Text(
                                              "MIST 1",
                                              style: aa.innerUiStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: screenHeight * 0.19,
                                      width: screenWidth * 0.09,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 1),
                                        color: isPressed6 ? Colors.grey[300] : Colors.white, // Changes color on press
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: isPressed6 // Adds shadow to simulate press effect
                                            ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(2, 2),
                                          )
                                        ]
                                            : [],
                                      ),
                                      child: InkWell(
                                        onTap: (){
                                          sendFun([77, 50]);
                                          Vibration.vibrate(duration: 140);
                                        },
                                        onTapDown: (_) {
                                          setState(() => isPressed6 = true); // Change state to pressed
                                        },
                                        onTapUp: (_) {
                                          setState(() => isPressed6 = false); // Change state back on release
                                        },
                                        onTapCancel: () {
                                          setState(() => isPressed6 = false); // Ensure button resets if tap is canceled
                                        },
                                        splashColor: Colors.redAccent.withOpacity(0.3),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/mist.png",
                                                height: screenHeight * 0.085),
                                            heightGap(screenHeight * 0.01),
                                            Text(
                                              "MIST 2",
                                              style: aa.innerUiStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: screenHeight * 0.19,
                                      width: screenWidth * 0.09,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 1),
                                        color: isPressed3 ? Colors.grey[300] : Colors.white, // Changes color on press
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: isPressed3 // Adds shadow to simulate press effect
                                            ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(2, 2),
                                          )
                                        ]
                                            : [],
                                      ),
                                      child: InkWell(
                                        onTap: (){
                                          Vibration.vibrate(duration: 140);
                                          sendFun([77, 51]);
                                        },
                                        onTapDown: (_) {
                                          setState(() => isPressed3 = true); // Change state to pressed
                                        },
                                        onTapUp: (_) {
                                          setState(() => isPressed3 = false); // Change state back on release
                                        },
                                        onTapCancel: () {
                                          setState(() => isPressed3 = false); // Ensure button resets if tap is canceled
                                        },
                                        splashColor: Colors.redAccent.withOpacity(0.3),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/mist.png",
                                              height: screenHeight * 0.085,
                                            ),
                                            heightGap(screenHeight * 0.01),
                                            Text(
                                              "MIST 3",
                                              style: aa.innerUiStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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