//Commited on 23 October
import 'package:ssss/logic/JoystickProvider2.dart';
import 'package:ssss/pages/authorization/login.dart';
import 'package:ssss/pages/home.dart';
import 'package:ssss/pages/machines/rcPLane/index.dart';
import 'package:ssss/pages/machines/satellite/index.dart';
import 'package:ssss/pages/machines/weather/weather_manscreen.dart';
import 'package:ssss/pages/machines/windTunnel/index.dart';
import 'package:ssss/pages/splash/splash.dart';
import 'package:ssss/pages/src/ble/ble_device_connector.dart';
import 'package:ssss/pages/src/ble/ble_device_interactor.dart';
import 'package:ssss/pages/src/ble/ble_logger.dart';
import 'package:ssss/pages/src/ble/ble_scanner.dart';
import 'package:ssss/pages/src/ble/ble_status_monitor.dart';
import 'package:ssss/utils/theme.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'logic/JoystickProvider.dart';
import 'logic/JoystickProvider1.dart';
import 'logic/logic.dart';

AppTheme aa = AppTheme();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final ble = FlutterReactiveBle();
  final bleLogger = BleLogger(ble: ble);
  final scanner = BleScanner(ble: ble, logMessage: bleLogger.addToLog);
  final monitor = BleStatusMonitor(ble);
  final connector = BleDeviceConnector(
    ble: ble,
    logMessage: bleLogger.addToLog,
  );
  final serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: ble.discoverServices,
    readCharacteristic: ble.readCharacteristic,
    writeWithResponse: ble.writeCharacteristicWithResponse,
    writeWithOutResponse: ble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: ble.subscribeToCharacteristic,
    logMessage: bleLogger.addToLog,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.grey[900], // Set your desired color
      statusBarIconBrightness: Brightness.light, // For light status bar icons
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.bottom]);
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: scanner),
        Provider.value(value: monitor),
        Provider.value(value: connector),
        Provider.value(value: serviceDiscoverer),
        Provider.value(value: bleLogger),
        StreamProvider<BleScannerState?>(
          create: (_) => scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
        ChangeNotifierProvider<LogicProvider>(
          create: (_) => LogicProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => JoystickProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => JoystickProvider1(),
        ),
        ChangeNotifierProvider(
          create: (context) => JoystickProvider2(),
        ),
      ],
      child: ConnectivityAppWrapper(
        app: MaterialApp(
          builder: (context, widget) {
            return MediaQuery(
              ///Setting font does not change with system font size
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
          title: aa.title,
          debugShowCheckedModeBanner: false,
          home:  SplashScreen(),
          // home:  const WeatherManScreen(title: "",),
          //    home: LoginPage(),
          //    home: SatellitePage(),
          //    home: WindPage(),
          // home: JoystickExampleApp(),
          // home:  JoystickWidget(),
          // home:  JoystickWidget1(),
          // home:  const SignUpPage(),
          // home:  WeatherManScreen(title: ''),
          // home: PlanePage(),
          // home: HomePage(
          //     username: "Admin1",
          //     loggedin: true),
        ),
      ),
    ),
  );
}
