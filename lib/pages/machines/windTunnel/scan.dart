import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../src/ble/ble_device_connector.dart';
import '../../src/ble/ble_scanner.dart';
import 'device_interaction_tab.dart';



class WindDeviceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer4<BleScanner, BleScannerState,BleDeviceConnector,ConnectionStateUpdate>(
    builder: (_, bleScanner, bleScannerState,deviceConnector, connectionStateUpdate,__) => WindScanPage(
      scannerState: bleScannerState ??
          BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
      startScan: bleScanner.startScan,
      stopScan: bleScanner.stopScan,
      connectionStatus: connectionStateUpdate.connectionState,
      deviceConnector: deviceConnector,
    ),
  );
}

class WindScanPage extends StatefulWidget {
  const WindScanPage({required this.scannerState, required this.startScan, required this.stopScan,required this.deviceConnector,required this.connectionStatus});

  final BleScannerState scannerState;
  final DeviceConnectionState connectionStatus;
  final BleDeviceConnector deviceConnector;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;

  @override
  State<WindScanPage> createState() => _CarScanPageState();
}

class _CarScanPageState extends State<WindScanPage> {

@override
  void initState() {
    super.initState();
    _startScanning();
  }
 TextEditingController _uuidController=TextEditingController();
String deviceid = "";
List <DiscoveredDevice>devices=[];
List <DiscoveredDevice>filterdevices=[];

void _startScanning() {
  if (widget.connectionStatus.toString() ==
      "DeviceConnectionState.connected") {
    widget.deviceConnector
        .disconnect(deviceid);
  }
  final text = _uuidController.text;
  widget.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
}

String demo(String name){
  String str1=name.toLowerCase();
  if(str1.contains('floro')==true || str1.contains('flaunt beat')==true || str1.contains('flaunt beat\n')==true){
    return name;
  }else{
    return 'nomatch';
  }
}

bool _isValidUuidInput() {
  final uuidText = _uuidController.text;
  if (uuidText.isEmpty) {
    return true;
  } else {
    try {
      Uuid.parse(uuidText);
      return true;
    } on Exception {
      return false;
    }
  }
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
              'assets/images/windblur.jpg',
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Optional: Overlay color
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0.0,16.0,0.0,0.0),
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
              width: screenWidth * 0.3, // Adjusted for better space usage
              height: screenHeight * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Connect to Network!" text at the top left
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Connect to Device!',
                          style: GoogleFonts.ubuntu(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              CupertinoIcons.multiply,
                              size: 22,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5), // Space below the title
                  // Scrollable ListView in the middle
                  Expanded(
                    ///ui
                    // child: ListView.builder(
                    //   itemCount: 10, // Example item count
                    //   itemBuilder: (context, index) {
                    //     return Container(
                    //       margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25), // Spacing between tiles
                    //       decoration: BoxDecoration(
                    //         border: Border.all(color: Colors.white, width: 1), // White border
                    //         borderRadius: BorderRadius.circular(12.0), // Rounded border for each tile
                    //       ),
                    //       child: ListTile(
                    //         minTileHeight: 11,
                    //         leading: Icon(Icons.bluetooth, color: Color.fromRGBO(170, 170, 170, 1),size: 17,), // Bluetooth icon in leading
                    //         title: Text(
                    //           'Network $index',
                    //           style: TextStyle(color: Color.fromRGBO(170, 170, 170, 1),fontSize: 12),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    child:ListView(
                      children: widget.scannerState.discoveredDevices
                      // children: filterdevices
                          .map(
                              (device) =>
                          ///working
                          //    device.name==demo(device.name)
                          true==true && device.name.isNotEmpty
                              ?Container( margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25), // Spacing between tiles
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1), // White border
                              borderRadius: BorderRadius.circular(12.0), // Rounded border for each tile
                            ),
                            // device.name==demonew(device.name)?Card(color: Colors.grey,
                            child: ListTile(
                              minTileHeight: 11,
                              title: Text(device.name,style:TextStyle(color: Color.fromRGBO(170, 170, 170, 1),fontSize: 12),),
                              leading: Icon(Icons.bluetooth, color: Color.fromRGBO(170, 170, 170, 1),size: 17,), // Bluetooth icon in leading
                              onTap: () async {
                                print(device.id);
                                widget.stopScan();
                                await Navigator.push<void>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      DeviceInteractionTab(
                                        device: device,
                                      ),
                                    ));
                              },
                            ),
                          ):Visibility(visible: false,child: ListTile(title: Text(""),))
                      )
                          .toList(),
                    ),
                  ),
                  // Fixed refresh button at the bottom left
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(88, 88, 88, 9),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight:  Radius.circular(20),
                      )
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(!widget.scannerState.scanIsInProgress &&
                                    _isValidUuidInput()){
                                  _startScanning();
                                }else if(widget.scannerState.scanIsInProgress){
                                  widget.stopScan();
                                }
                              },
                              child: Container(
                                width: screenWidth * 0.12,
                                height: screenHeight * 0.1,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(255, 255, 255, 1),
                                      Color.fromRGBO(170, 184, 209, 1),
                                    ],
                                  ),
                                ),
                                child: Text(
                                  'Refresh',
                                  style: TextStyle(color:Color.fromRGBO(30, 30, 30, 1),fontSize: 12,fontWeight: FontWeight.w400),
                                ),
                              ),
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
    );
  }
}
