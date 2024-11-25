import 'package:ssss/pages/machines/rcCar/scan.dart';
import 'package:ssss/pages/machines/rover/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'bleStatus.dart';


class roverPermissionPage extends StatefulWidget {

  @override
  _CarMainPageState createState() => _CarMainPageState();
}

class _CarMainPageState extends State<roverPermissionPage> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<BleStatus>(
    builder: (_, status, __) {
      if (status == BleStatus.ready) {
        return RoverDeviceListScreen();
      } else {
        return RoverBleStatusScreen(status: status ?? BleStatus.unknown);
      }
    },
  );
}
