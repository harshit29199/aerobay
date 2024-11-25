import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ssss/pages/machines/weather/weather_manscreen.dart';
import 'package:ssss/pages/src/ble/ble_device_connector.dart';
import 'package:ssss/pages/src/ble/ble_device_interactor.dart';
import 'package:ssss/pages/src/ble/ble_logger.dart';
import 'package:ssss/pages/src/cardwithinner_shadow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../model/machine.dart';
import '../utils/custom_popup.dart';
import '../utils/images.dart';
import 'authorization/login.dart';
import 'machines/rcCar/dummy.dart';
import 'machines/rcPLane/dummy.dart';
import 'machines/rover/dummy.dart';
import 'machines/satellite/dummy.dart';
import 'machines/rcCar/index.dart';
import 'machines/rcPLane/index.dart';
import 'machines/rover/index.dart';
import 'machines/satellite/index.dart';
import 'machines/windTunnel/dummy.dart';
import 'machines/windTunnel/index.dart';



class HomePage extends StatelessWidget {
  ///update include bledeviceconnector
  ///
  final String username;
  final bool loggedin;

  const HomePage({super.key, required this.username, required this.loggedin});

  @override
  Widget build(BuildContext context) => Consumer4<ConnectionStateUpdate,
      BleDeviceInteractor, BleLogger, BleDeviceConnector>(
      builder:
          (_, connectionStateUpdate, interactor, logger, deviceConnector, __) =>
              Home0(
            connectionStatus: connectionStateUpdate.connectionState,
            deviceConnector: deviceConnector,
            readCharacteristic: interactor.readCharacteristic,
            writeWithResponse: interactor.writeCharacterisiticWithResponse,
            subscribeToCharacteristic: interactor.subScribeToCharacteristic,
            discoverServices: interactor.discoverServices,
            writeWithoutResponse:
            interactor.writeCharacterisiticWithoutResponse,
            messages: logger.messages,
                username:username,
                  loggedin:loggedin
          ));
}

class Home0 extends StatefulWidget {

  const Home0({
    Key? key,
    required this.connectionStatus,
    required this.deviceConnector,
    required this.readCharacteristic,
    required this.writeWithResponse,
    required this.subscribeToCharacteristic,
    required this.discoverServices,
    required this.writeWithoutResponse,
    required this.messages,
    required this.username,
    required this.loggedin,
  }) : super(key: key);

  final String username;
  final bool loggedin;
  final List<String> messages;
  final DeviceConnectionState connectionStatus;
  final Future<List<int>> Function(QualifiedCharacteristic characteristic)
  readCharacteristic;
  final BleDeviceConnector deviceConnector;
  final Future<List<DiscoveredService>> Function(String str) discoverServices;
  final Future<void> Function(
      QualifiedCharacteristic characteristic, List<int> value)
  writeWithResponse;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)
  subscribeToCharacteristic;

  final Future<void> Function(
      QualifiedCharacteristic characteristic, List<int> value)
  writeWithoutResponse;

  @override
  State<Home0> createState() => _HomePageState();
}

class _HomePageState extends State<Home0> {
  String? _username;
  bool isPressed3 =false;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getSavedDevice();
    });
    super.initState();
    if (widget.username.isEmpty) {
      _loadUsername();
    } else {
      _username = widget.username;
      saveUsername();
    }

    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }
  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  String sateLLite="";
  String windTunnel="";
  String weatherMan="";
  String rover="";
  String car="";
  String plane="";

  getSavedDevice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      sateLLite=preferences.getString('sateLLite')??'';
      windTunnel=preferences.getString('windTunnel')??'';
      weatherMan=preferences.getString('weatherMan')??'';
      rover=preferences.getString('rover')??'';
      car=preferences.getString('car')??'';
      plane=preferences.getString('plane')??'';
    });
  }

  Future<void> _connect(BuildContext context,String machine) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();

    _adapterState =BluetoothAdapterState.on;
    // Fluttertoast.showToast(msg: _adapterState.name);
    // print('Bluetooth status: $isBluetoothOn');
    // if (isBluetoothOn) {
    if (_adapterState.name=="on") {
      if(machine=="Satellite"){
        if(sateLLite.isNotEmpty) {
          widget.deviceConnector.connect(sateLLite);
          // Fluttertoast.showToast(msg:  widget.connectionStatus.toString());
          if (widget.connectionStatus.toString() ==
              "DeviceConnectionState.connecting") {
            Fluttertoast.showToast(
                msg:
                "Connect via scanning");
            if (context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                      const SatellitePage()));
            }
          }
          final List<DiscoveredService>
          discoveredServices =
          await widget.discoverServices(sateLLite);
          int i = 0;
          if (discoveredServices.length > 1) {
            while (i < discoveredServices.length) {
              if (i == 3) {
                DiscoveredService service =
                discoveredServices[i];
                print('Service ID: ${service.serviceId}');
                print(
                    'Characteristic IDs: ${service.characteristicIds}');
                // if(!mounted)return;
                if (context.mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return dummy(
                            characteristic:
                            QualifiedCharacteristic(
                              characteristicId:
                              service.characteristicIds[0],
                              serviceId: service.serviceId,
                              deviceId: sateLLite,
                            ),
                            deviceConnector:
                            widget.deviceConnector,
                            connectionStatus:
                            widget.connectionStatus,
                            characteristic1:
                            QualifiedCharacteristic(
                              characteristicId:
                              service.characteristicIds[0],
                              serviceId: service.serviceId,
                              deviceId: sateLLite,
                            )
                        );
                      }));
                }
              }
              i++;
            }
          }
        }else{
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                  const SatellitePage()));
        }
      }

      if(machine=="Wind Tunnel"){
        if(windTunnel.isNotEmpty) {
          widget.deviceConnector.connect(windTunnel);
          // Fluttertoast.showToast(msg:  widget.connectionStatus.toString());
          if (widget.connectionStatus.toString() ==
              "DeviceConnectionState.connecting") {
            Fluttertoast.showToast(
                msg:
                "Connect via scanning");
            if (context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                      const WindPage()));
            }
          }
          final List<DiscoveredService>
          discoveredServices =
          await widget.discoverServices(windTunnel);
          int i = 0;
          if (discoveredServices.length > 1) {
            while (i < discoveredServices.length) {
              if (i == 2) {
                DiscoveredService service =
                discoveredServices[i];
                print('Service ID: ${service.serviceId}');
                print(
                    'Characteristic IDs: ${service.characteristicIds}');
                // if(!mounted)return;
                if (context.mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return Winddummy(
                            characteristic:
                            QualifiedCharacteristic(
                              characteristicId:
                              service.characteristicIds[1],
                              serviceId: service.serviceId,
                              deviceId: windTunnel,
                            ),
                            deviceConnector:
                            widget.deviceConnector,
                            connectionStatus:
                            widget.connectionStatus,
                            characteristic1:
                            QualifiedCharacteristic(
                              characteristicId:
                              service.characteristicIds[0],
                              serviceId: service.serviceId,
                              deviceId: windTunnel,
                            )
                        );
                      }));
                }
              }
              i++;
            }
          }
        }else{
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                  const WindPage()));
        }
      }

      if(machine=="Weather Man"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                const WeatherManScreen(title: "")));
        // if(sateLLite.isNotEmpty) {
        //   widget.deviceConnector.connect(sateLLite);
        //   // Fluttertoast.showToast(msg:  widget.connectionStatus.toString());
        //   if (widget.connectionStatus.toString() ==
        //       "DeviceConnectionState.connecting") {
        //     Fluttertoast.showToast(
        //         msg:
        //         "Connect via scanning");
        //     if (context.mounted) {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (_) =>
        //               const SatellitePage()));
        //     }
        //   }
        //   final List<DiscoveredService>
        //   discoveredServices =
        //   await widget.discoverServices(sateLLite);
        //   int i = 0;
        //   if (discoveredServices.length > 1) {
        //     while (i < discoveredServices.length) {
        //       if (i == 2) {
        //         DiscoveredService service =
        //         discoveredServices[i];
        //         print('Service ID: ${service.serviceId}');
        //         print(
        //             'Characteristic IDs: ${service.characteristicIds}');
        //         // if(!mounted)return;
        //         if (context.mounted) {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (context) {
        //                 return dummy(
        //                     characteristic:
        //                     QualifiedCharacteristic(
        //                       characteristicId:
        //                       service.characteristicIds[1],
        //                       serviceId: service.serviceId,
        //                       deviceId: sateLLite,
        //                     ),
        //                     deviceConnector:
        //                     widget.deviceConnector,
        //                     connectionStatus:
        //                     widget.connectionStatus,
        //                     characteristic1:
        //                     QualifiedCharacteristic(
        //                       characteristicId:
        //                       service.characteristicIds[0],
        //                       serviceId: service.serviceId,
        //                       deviceId: sateLLite,
        //                     )
        //                 );
        //               }));
        //         }
        //       }
        //       i++;
        //     }
        //   }
        // }else{
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) =>
        //           const SatellitePage()));
        // }
      }

      if(machine=="Rover"){
        if(rover.isNotEmpty) {
          widget.deviceConnector.connect(rover);
          // Fluttertoast.showToast(msg:  widget.connectionStatus.toString());
          if (widget.connectionStatus.toString() ==
              "DeviceConnectionState.connecting") {
            Fluttertoast.showToast(
                msg:
                "Connect via scanning");
            if (context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const RoverPage()));
            }
          }
          final List<DiscoveredService>
          discoveredServices =
          await widget.discoverServices(rover);
          int i = 0;
          if (discoveredServices.length > 1) {
            while (i < discoveredServices.length) {
              if (i == 2) {
                DiscoveredService service =
                discoveredServices[i];
                print('Service ID: ${service.serviceId}');
                print(
                    'Characteristic IDs: ${service.characteristicIds}');
                // if(!mounted)return;
                if (context.mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return roverdummy(
                            characteristic:
                            QualifiedCharacteristic(
                              characteristicId:
                              service.characteristicIds[1],
                              serviceId: service.serviceId,
                              deviceId: rover,
                            ),
                            deviceConnector:
                            widget.deviceConnector,
                            connectionStatus:
                            widget.connectionStatus,
                            characteristic1:
                            QualifiedCharacteristic(
                              characteristicId:
                              service.characteristicIds[0],
                              serviceId: service.serviceId,
                              deviceId: rover,
                            )
                        );
                      }));
                }
              }
              i++;
            }
          }
        }else{
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                  const RoverPage()));
        }
      }

      if(machine=="RC Car"){
        if(car.isNotEmpty) {
          widget.deviceConnector.connect(car);
          // Fluttertoast.showToast(msg:  widget.connectionStatus.toString());
          if (widget.connectionStatus.toString() ==
              "DeviceConnectionState.connecting") {
            Fluttertoast.showToast(
                msg:
                "Connect via scanning");
            if (context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const CarPage()));
            }
          }
          final List<DiscoveredService>
          discoveredServices =
          await widget.discoverServices(car);
          int i = 0;
          if (discoveredServices.length > 1) {
            while (i < discoveredServices.length) {
              if (i == 2) {
                DiscoveredService service =
                discoveredServices[i];
                print('Service ID: ${service.serviceId}');
                print(
                    'Characteristic IDs: ${service.characteristicIds}');
                // if(!mounted)return;
                if (context.mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return cardummy(
                            characteristic:
                            QualifiedCharacteristic(
                              characteristicId:
                              service.characteristicIds[1],
                              serviceId: service.serviceId,
                              deviceId: car,
                            ),
                            deviceConnector:
                            widget.deviceConnector,
                            connectionStatus:
                            widget.connectionStatus,
                            characteristic1:
                            QualifiedCharacteristic(
                              characteristicId:
                              service.characteristicIds[0],
                              serviceId: service.serviceId,
                              deviceId: car,
                            )
                        );
                      }));
                }
              }
              i++;
            }
          }
        }else{
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                  const CarPage()));
        }
      }

      if(machine=="RC Plane"){
        if(plane.isNotEmpty) {
          widget.deviceConnector.connect(plane);
          // Fluttertoast.showToast(msg:  widget.connectionStatus.toString());
          if (widget.connectionStatus.toString() ==
              "DeviceConnectionState.connecting") {
            Fluttertoast.showToast(
                msg:
                "Connect via scanning");
            if (context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const PlanePage()));
            }
          }
          final List<DiscoveredService>
          discoveredServices =
          await widget.discoverServices(plane);
          int i = 0;
          if (discoveredServices.length > 1) {
            while (i < discoveredServices.length) {
              if (i == 2) {
                DiscoveredService service =
                discoveredServices[i];
                print('Service ID: ${service.serviceId}');
                print(
                    'Characteristic IDs: ${service.characteristicIds}');
                // if(!mounted)return;
                if (context.mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return planedummy(
                            characteristic:
                            QualifiedCharacteristic(
                              characteristicId:
                              service.characteristicIds[1],
                              serviceId: service.serviceId,
                              deviceId: plane,
                            ),
                            deviceConnector:
                            widget.deviceConnector,
                            connectionStatus:
                            widget.connectionStatus,
                            characteristic1:
                            QualifiedCharacteristic(
                              characteristicId:
                              service.characteristicIds[0],
                              serviceId: service.serviceId,
                              deviceId: plane,
                            )
                        );
                      }));
                }
              }
              i++;
            }
          }
        }else{
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                  const PlanePage()));
        }
      }

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              padding: EdgeInsets.symmetric(
                  horizontal:  MediaQuery.of(context).size.width * 0.35,
                  vertical: 3),
              elevation: 2.0,
              backgroundColor: Colors.red,
              content: const Text(
                  'Bluetooth is turned off. Please turn it on to proceed.')));
    }
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('aerobayUsername') ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              background,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05,
                      screenHeight * 0.08,
                      screenWidth * 0.07,
                      screenHeight * 0.015),
                  child: Row(
                    children: [
                      Image.asset(aerobayLogo, height: screenHeight * 0.1),
                      SizedBox(width: screenWidth * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $_username',
                            style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              // fontSize: screenHeight * 0.045,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'Welcome to AeroBay!!',
                            style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              // fontSize:
                              //     screenHeight * 0.06, // Responsive font size
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Vibration.vibrate();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomExitLogoutPopup(
                                onLogout: _performLogout,
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
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
                          ),
                          child: Image.asset(backIcon,height:screenHeight*0.13),
                        ),
                      ),
                    ],
                  ),
                ),
                // Glassmorphism container with grid
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.13,
                        vertical: screenHeight * 0.03),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.transparent.withOpacity(0.3),
                          width: 10,
                        ),
                        color: Colors.white.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.012),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            mainAxisSpacing: screenHeight * 0.015,
                            crossAxisSpacing: screenWidth * 0.012,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: machineCards.length,
                          itemBuilder: (context, index) {
                            Machine card = machineCards[index];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                    Vibration.vibrate();
                                      if (index == 0) {
                                        _connect(context,card.name);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //         const SatellitePage()));

                                      }
                                      if (index == 1) {
                                        _connect(context,card.name);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //         const WindPage()));
                                      }
                                      if (index == 2) {
                                        _connect(context,card.name);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //         const WeatherManScreen(title: "")));
                                      }
                                      if (index == 3) {
                                        _connect(context,card.name);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //             const RoverPage()));
                                      }
                                      if (index == 4) {
                                        _connect(context,card.name);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //             const CarPage()));
                                      }
                                      if (index == 5) {
                                        _connect(context,card.name);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //             const PlanePage()));
                                      }
                                      if (index == 6) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.35,vertical: 3),
                                              elevation: 2.0,
                                              backgroundColor: Colors.red,
                                              content: const Text('This feature is under development')
                                          ),
                                        );
                                      }
                                      if (index == 7) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.35,vertical: 3),
                                              elevation: 2.0,
                                              backgroundColor: Colors.red,
                                              content: const Text('This feature is under development')
                                          ),
                                        );
                                      }
                                      if (index == 8) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.35,vertical: 3),
                                              elevation: 2.0,
                                              backgroundColor: Colors.red,
                                              content: const Text('This feature is under development')
                                          ),
                                        );
                                      }
                                      if (index == 9) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.35,vertical: 3),
                                              elevation: 2.0,
                                              backgroundColor: Colors.red,
                                              content: const Text('This feature is under development')
                                          ),
                                        );
                                      }
                                      if (index == 10){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.35,vertical: 3),
                                              elevation: 2.0,
                                              backgroundColor: Colors.red,
                                              content: const Text('This feature is under development')
                                          ),
                                        );
                                      }
                                      if (index == 11){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.35,vertical: 3),
                                              elevation: 2.0,
                                              backgroundColor: Colors.red,
                                              content: const Text('This feature is under development')
                                          ),
                                        );
                                      }
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 4,
                                      child: Stack(
                                        children: [
                                          // The custom painter for inner shadow effect
                                          CustomPaint(
                                            painter: InnerShadowPainter(),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                                      child: Image.asset(
                                                        card.imagePath,
                                                        height: screenHeight * 0.12,
                                                        width: screenWidth * 0.07,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: screenHeight * 0.02,
                                                    right: screenHeight * 0.01,
                                                    child: Icon( index ==0|| index==2|| index ==7?Icons.wifi:
                                                      Icons.bluetooth,
                                                      size: screenHeight * 0.03,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ),
                                ),
                                Text(
                                  card.name,
                                  style: GoogleFonts.ubuntu(
                                      fontSize: screenHeight * 0.03,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800]),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('aerobayUsername', _username!);
    await prefs.setBool('isLoggedIn', widget.loggedin);
  }

  void _performLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('aerobayUsername');
    await prefs.setBool('isLoggedIn', false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
