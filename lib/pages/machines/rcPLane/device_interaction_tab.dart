import 'dart:ui' as ui;
import 'dart:ui';
import 'package:ssss/pages/machines/rcCar/permissionCheck.dart';
import 'package:ssss/pages/machines/rcPLane/permissionCheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:functional_data/functional_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../../utils/theme.dart';
import '../../src/ble/ble_device_connector.dart';
import '../../src/ble/ble_device_interactor.dart';
import '../../src/ble/ble_scanner.dart';
import 'dummy.dart';
part 'device_interaction_tab.g.dart';
//ignore_for_file: annotate_overrides

class DeviceInteractionTab extends StatelessWidget {
  final DiscoveredDevice device;

  const DeviceInteractionTab({
    required this.device,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer5<
      BleDeviceConnector,
      ConnectionStateUpdate,
      BleDeviceInteractor,
      BleScanner,
      BleScannerState>(
    builder: (_, deviceConnector, connectionStateUpdate, serviceDiscoverer,
        bleScanner, bleScannerState, __) =>
        _DeviceInteractionTab(
            viewModel: DeviceInteractionViewModel(
                deviceId: device.id,
                connectableStatus: device.connectable,
                connectionStatus: connectionStateUpdate.connectionState,
                deviceConnector: deviceConnector,
                discoverServices: () =>
                    serviceDiscoverer.discoverServices(device.id)),
            scannerState: bleScannerState ??
                BleScannerState(
                  discoveredDevices: [],
                  scanIsInProgress: false,
                ),
            startScan: bleScanner.startScan,
            stopScan: bleScanner.stopScan,
            deviceName:device.name
        ),
  );
}

@immutable
@FunctionalData()
class DeviceInteractionViewModel extends $DeviceInteractionViewModel {
  const DeviceInteractionViewModel({
    required this.deviceId,
    required this.connectableStatus,
    required this.connectionStatus,
    required this.deviceConnector,
    required this.discoverServices,
  });

  final String deviceId;
  final Connectable connectableStatus;
  final DeviceConnectionState connectionStatus;
  final BleDeviceConnector deviceConnector;
  @CustomEquality(Ignore())
  final Future<List<DiscoveredService>> Function() discoverServices;

  bool get deviceConnected =>
      connectionStatus == DeviceConnectionState.connected;

  bool get deviceDisconnected=>connectionStatus==DeviceConnectionState.disconnected;



  void connect() {
    deviceConnector.connect(deviceId);
  }

  void disconnect() {
    deviceConnector.disconnect(deviceId);
  }
}

class _DeviceInteractionTab extends StatefulWidget {
  const _DeviceInteractionTab({
    required this.viewModel,
    required this.scannerState,
    required this.startScan,
    required this.stopScan,
    required this.deviceName,
    Key? key,
  }) : super(key: key);

  final DeviceInteractionViewModel viewModel;
  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;
  final String deviceName;

  @override
  _DeviceInteractionTabState createState() => _DeviceInteractionTabState();
}

class _DeviceInteractionTabState extends State<_DeviceInteractionTab> {
  late List<DiscoveredService> discoveredServices;
  late TextEditingController _uuidController;

  final TextEditingController _textEditingController =
  TextEditingController();

  void dslist(List<DiscoveredService> discoveredServices)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> dslist = preferences.getStringList('onlyneon_dslist')!;
    if(dslist != null && !dslist.isEmpty){
      if (!dslist.contains(discoveredServices.toString())) {
        dslist.add(discoveredServices.toString());
      }
      await preferences.setStringList('onlyneon_dslist', dslist);
    }else{
      dslist.add(discoveredServices.toString());
      await preferences.setStringList('onlyneon_dslist', dslist);
    }
  }

  bool chk=true;
  AppTheme aa = AppTheme();
  void deviceid(String deviceId,String hwdevicename) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // var a = preferences.getString(deviceId);
    var a = preferences.getString(deviceId) ?? ''; // Provide a default value here
    // if(a != null && !a.isEmpty){
    // if(a.isNotEmpty){
    if(true){
      discoverServices();
      demo();
    } else {
      // Fluttertoast.showToast(msg: a);
      // Fluttertoast.showToast(msg: "key not exist");
      /// open a alert dialog box with single textfield
      if(!mounted)return;
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title:  Text(aa.title,),
              content: TextField(
                // style: aa.style3,
                controller: _textEditingController,
                decoration:  InputDecoration(hintText: 'Enter device name',  enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),),
              ),
              actions: <Widget>[
                // TextButton(
                //   onPressed: () => Navigator.pop(context),
                //   child: const Text('Cancel'),
                // ),
                TextButton(onPressed: (){
                  discoverServices();
                  demo();
                  // Navigator.pop(context);
                }, child:  Text('Skip')),
                TextButton(
                  onPressed: () async {
                    if(_textEditingController.text.isNotEmpty){
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(seconds: 1), () async {

                        final String name = _textEditingController.text;
                        await preferences.setString(deviceId, name);
                        List<String> deviceidlist = preferences.getStringList('onlyneon_deviceidlist') ?? [];
                        List<String> devicenamelist = preferences.getStringList('onlyneon_devicenamelist')??[];
                        List<String> hwdevicenamelist = preferences.getStringList('onlyneon_hwdevicenamelist')??[];
                        if(deviceidlist.isNotEmpty){
                          if (!devicenamelist.contains(name)) {
                            setState(() {
                              chk=true;
                            });
                            deviceidlist.add(deviceId);
                            /// store unique device custom name

                            devicenamelist.add(name);
                            ///
                            hwdevicenamelist.add(hwdevicename);
                            // Fluttertoast.showToast(msg: "not null");
                            // Fluttertoast.showToast(msg: deviceidlist.toString());
                            await preferences.setStringList('onlyneon_deviceidlist', deviceidlist);
                            await preferences.setStringList('onlyneon_devicenamelist', devicenamelist);
                            ///
                            await preferences.setStringList('onlyneon_hwdevicenamelist', hwdevicenamelist);
                            // Fluttertoast.showToast(msg: devicenamelist.toString());
                          }else{
                            setState(() {
                              chk=false;
                            });
                            Fluttertoast.showToast(msg: "Name already exist");
                          }
                        }else{
                          deviceidlist.add(deviceId);
                          devicenamelist.add(name);
                          hwdevicenamelist.add(hwdevicename);
                          await preferences.setStringList('onlyneon_deviceidlist', deviceidlist);
                          await preferences.setStringList('onlyneon_devicenamelist', devicenamelist);
                          await preferences.setStringList('onlyneon_hwdevicenamelist', hwdevicenamelist);
                        }
                        if(chk==true){
                          demo();
                        }
                      });
                    }else{
                      Fluttertoast.showToast(msg: "Please enter any device name");
                    }
                  },
                  child: Text('Save'),
                ),

              ],
            );
          });
    }
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async{
    //   deviceid(widget.viewModel.deviceId,widget.deviceName);
    // });
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
    _startScanning();
    discoveredServices = [];
    discoverServices();
    super.initState();
    // conncheck();
    // widget.viewModel.connect();
  }


  void _startScanning() {
    final text = _uuidController.text;
    widget.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
  }

  Future<void> discoverServices() async {
    // Fluttertoast.showToast(msg: "Connecting in progress...");
    widget.viewModel.connect();
    setState(() {
      _iconColor5 = Colors.green;
    });
    final result = await widget.viewModel.discoverServices();
    setState(() {
      discoveredServices = result;
      print(discoveredServices);
      if(discoveredServices.isNotEmpty){
        // dslist(discoveredServices);
        print("not emptytttttttttttttttttttttt");
        demo();
      }else{
        print("emptytttttttttttttttttttttt");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => planePermissionPage()));
      }
      // print(discoveredServices.last);
    });
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // var a = preferences.getString(widget.viewModel.deviceId);
    // if(a != null && !a.isEmpty){
    //   demo();
    // }
  }

  demo(){
    int i = 0;
    if(discoveredServices.length>1){
      while (i < discoveredServices.length) {
        /// when i is 2 it is for android and when i is 0 it is for ios
        if(i==2){
          DiscoveredService service = discoveredServices[i];
          print('Service ID: ${service.serviceId}');
          print('Characteristic IDs: ${service.characteristicIds}');
          // if(widget.deviceName=="Pulse"){
          if(true){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return planedummy(
                characteristic: QualifiedCharacteristic(
                  characteristicId: service.characteristicIds[1],
                  serviceId: service.serviceId,
                  deviceId: widget.viewModel.deviceId,
                ),
                deviceConnector: widget.viewModel.deviceConnector,
                connectionStatus: widget.viewModel.connectionStatus,
                characteristic1: QualifiedCharacteristic(
                  characteristicId: service.characteristicIds[0],
                  serviceId: service.serviceId,
                  deviceId: widget.viewModel.deviceId,
                ),
              );
            }));
          }else{
            ///test
            Fluttertoast.showToast(msg: "Please select valid device");
            _onLogout();
          }
        }
        if(i==3){
          DiscoveredService service = discoveredServices[i];
          print('Service ID: ${service.serviceId}');
          print('Characteristic IDs: ${service.characteristicIds}');
          // if(widget.deviceName=="rcCar"){
          if(true){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return planedummy(
                characteristic: QualifiedCharacteristic(
                  characteristicId: service.characteristicIds[0],
                  serviceId: service.serviceId,
                  deviceId: widget.viewModel.deviceId,
                ),
                deviceConnector: widget.viewModel.deviceConnector,
                connectionStatus: widget.viewModel.connectionStatus,
                characteristic1: QualifiedCharacteristic(
                  characteristicId: service.characteristicIds[0],
                  serviceId: service.serviceId,
                  deviceId: widget.viewModel.deviceId,
                ),
              );
            }));
          }else{
            ///test
            Fluttertoast.showToast(msg: "Please select valid device");
            _onLogout();
          }
        }
        i++;
      }}
  }

  demo111() {
    widget.viewModel.disconnect();
    setState(() {
      _iconColor5 = Colors.redAccent;
    });
  }

  String stat = "false";

  bool show=true;

  Widget _characteristicTile(QualifiedCharacteristic characteristic,BleDeviceConnector deviceConnector,DeviceConnectionState connectionStatus,QualifiedCharacteristic characteristic1) =>
      Visibility(
        visible: show,
        child: ListTile(
          onTap: () {
            demo();
          },
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.32,
              ),
              RichText(
                text: TextSpan(
                  text: '',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                  ),
                  children:  <TextSpan>[
                    TextSpan(text: '\"Lit your Life\"', style:TextStyle(
                        fontFamily: 'Montserrat',
                        color: _getColorFromHex("#33D78F"),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0) ),
                    // TextSpan(text: new String.fromCharCodes(new Runes('\u005B'))),
                    TextSpan(text: '\n           Tap it', style:TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 14.0) ),
                    // TextSpan(text: new String.fromCharCodes(new Runes('\u005D'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _characteristicTile1(QualifiedCharacteristic characteristic,BleDeviceConnector deviceConnector,DeviceConnectionState connectionStatus) {
    show=false;
    return ListTile(
      onTap: () {
        demo();
      },
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(
          //   width: MediaQuery.of(context).size.width,
          // ),
          RichText(
            text: TextSpan(
              text: '',
              style: TextStyle(
                decoration: TextDecoration.none,
              ),
              children:  <TextSpan>[
                TextSpan(text: '\"Lit your Life\"', style:TextStyle(
                    fontFamily: 'Montserrat',
                    color: _getColorFromHex("#33D78F"),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0) ),
                // TextSpan(text: new String.fromCharCodes(new Runes('\u005B'))),
                TextSpan(text: '\nTap it', style:TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 14.0) ),
                // TextSpan(text: new String.fromCharCodes(new Runes('\u005D'))),
              ],
            ),
          ),
        ],
      ),
    );
  }






  final List<int> _expandedItems = [];

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse("0x$hexColor"));
  }

  Color _iconColor5 = Colors.redAccent;

  get() {
    // Fluttertoast.showToast(msg: widget.viewModel.deviceId);
    widget.viewModel.disconnect();
    widget.viewModel.deviceConnector.dispose();
    // Fluttertoast.showToast(msg: widget.viewModel.connectionStatus.toString());
    if(widget.viewModel.connectionStatus=="DeviceConnectionStata.disconnected"){
      widget.viewModel.deviceConnector.connect(widget.viewModel.deviceId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onLogout() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => planePermissionPage()));
  }



  List<ExpansionPanel> buildPanels() {

    final panels = <ExpansionPanel>[];

    discoveredServices.asMap().forEach((index, service) {

      switch (index) {
        case 0:

        // Fluttertoast.showToast(msg: "service0");
        // print("service 1");
          break;
        case 1:
        // Fluttertoast.showToast(msg: "service1");
        // print("service 2");
          break;
        case 2:
          panels.add(
            ExpansionPanel(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [],
                ),
                headerBuilder: (context, isExpanded) => Visibility(
                  visible: show,
                  child: Container(
                    color: Colors.black,
                    child: _characteristicTile(
                      QualifiedCharacteristic(
                        characteristicId: service.characteristicIds[1],
                        serviceId: service.serviceId,
                        deviceId: widget.viewModel.deviceId,
                      ),
                      widget.viewModel.deviceConnector,widget.viewModel.connectionStatus,
                      QualifiedCharacteristic(
                        characteristicId: service.characteristicIds[0],
                        serviceId: service.serviceId,
                        deviceId: widget.viewModel.deviceId,
                      ),
                    ),
                  ),
                ),
                isExpanded: false,
                backgroundColor: Colors.black
            ),
          );
          break;
        case 3:
          panels.removeAt(0);
          panels.add(
            ExpansionPanel(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [],
                ),
                headerBuilder: (context, isExpanded) => Container(
                  color: Colors.black,
                  child: _characteristicTile1(
                      QualifiedCharacteristic(
                        characteristicId: service.characteristicIds[0],
                        serviceId: service.serviceId,
                        deviceId: widget.viewModel.deviceId,
                      ),
                      widget.viewModel.deviceConnector,widget.viewModel.connectionStatus
                  ),
                ),
                isExpanded: false,
                backgroundColor: Colors.black),
          );
          break;
      }
    });
    return panels;
  }

  String poweron1 = 'dit.png';

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () {
      return _onLogout();
    },
    child: Scaffold(
        // resizeToAvoidBottomInset: false,
        ///new code
        // body: Column(
        //   children: <Widget>[
        //     Flexible(
        //         child: FractionallySizedBox(
        //             heightFactor: 1,
        //             widthFactor: 1,
        //             child: Container(
        //                 decoration: BoxDecoration(
        //                   image: DecorationImage(
        //                     image: AssetImage("assets/selection_bg.jpg"),
        //                     fit: BoxFit.cover,
        //                   ),
        //                 ),
        //                 child: LayoutBuilder(builder: (ctx, constraints) {
        //                   return Column(children: <Widget>[
        //                     Container(
        //                       // color: Colors.white,
        //                       height: constraints.maxHeight * 1,
        //                       width: constraints.maxWidth * 1,
        //                       child: Column(
        //                         // mainAxisAlignment: MainAxisAlignment.center,
        //                         crossAxisAlignment: CrossAxisAlignment.center,
        //                         children: <Widget>[
        //                           SizedBox(
        //                             height: constraints.maxHeight * 0.02,
        //                           ),
        //                           Container(
        //                             height: constraints.maxHeight * 0.15,
        //                             width: constraints.maxWidth * 0.3,
        //                             // child: GestureDetector(
        //                             //   child:Image.asset('assets/onlyneonbg.png',
        //                             //   ),
        //                             // ),
        //                           ),
        //                           SizedBox(
        //                             height: constraints.maxHeight * 0.28,
        //                           ),
        //                           Container(
        //                             height: constraints.maxHeight * 0.25,
        //                             width: constraints.maxWidth * 0.38,
        //                             child: GestureDetector(
        //                               onTap: (){
        //                                 demo();
        //                               },
        //                               child:Image.asset('assets/dit.png',
        //                               ),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ]);
        //                 }))))
        //   ],
        // )
      ///my code
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/planeuibg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Optional: Overlay color
            ),
          ),
        ],
      ),
    ),
  );

}



