import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class PlaneBleStatusScreen extends StatefulWidget {
  const PlaneBleStatusScreen({required this.status, Key? key}) : super(key: key);

  final BleStatus status;

  @override
  State<PlaneBleStatusScreen> createState() => _BleStatusScreenState();
}

class _BleStatusScreenState extends State<PlaneBleStatusScreen> with SingleTickerProviderStateMixin {

  late PermissionStatus _permissionStatus;
  late final AnimationController lottieController;


  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    if(status.isGranted){
      print("location per mili");
    }
  }

  @override
  void initState() {
    demo();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  bool permGranted = true;
  Future<void> demo()async{
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect
    ].request();
    if (statuses[Permission.location]!.isGranted &&
        statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothAdvertise]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted) {
      permGranted = true;
    }
  }

  String onOffStatus ="OFF" ;

  String determineText(BleStatus status) {
    switch (status) {
      case BleStatus.unsupported:
        return "This device does not support Bluetooth";
      case BleStatus.unauthorized:
        return "Allow nearby devices permission in app setting";
      case BleStatus.poweredOff:
        return "Bluetooth is powered off on your device turn it on";
      case BleStatus.locationServicesDisabled:
        return "Enable location services";
      case BleStatus.ready:
        return "Bluetooth is up and running";
      default:
        return "Waiting to fetch Bluetooth status $status";
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse("0x$hexColor"));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/planeuibg.jpg',
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
              padding: EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                border: Border.all(color: Colors.white, width: 1), // White border
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(30, 30, 30, 0.8),
                    Color.fromRGBO(59, 59, 59, 0.8),
                  ],
                ),
              ),
              width: screenWidth * 0.4, // Adjusted for better space usage
              height: screenHeight * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // "Connect to Network!" text at the top left
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      determineText(widget.status),
                      style: GoogleFonts.ubuntu(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
