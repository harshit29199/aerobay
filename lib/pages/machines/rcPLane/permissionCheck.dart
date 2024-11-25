import 'package:ssss/pages/machines/rcCar/scan.dart';
import 'package:ssss/pages/machines/rcPLane/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'bleStatus.dart';


class planePermissionPage extends StatefulWidget {

  @override
  _PlaneMainPageState createState() => _PlaneMainPageState();
}

class _PlaneMainPageState extends State<planePermissionPage> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<BleStatus>(
    builder: (_, status, __) {
      if (status == BleStatus.ready) {
        return PlaneDeviceListScreen();
      } else {
        return PlaneBleStatusScreen(status: status ?? BleStatus.unknown);
      }
    },
  );
}
