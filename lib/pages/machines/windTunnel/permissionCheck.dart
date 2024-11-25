import 'package:ssss/pages/machines/windTunnel/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'bleStatus.dart';


class windPermissionPage extends StatefulWidget {

  @override
  _CarMainPageState createState() => _CarMainPageState();
}

class _CarMainPageState extends State<windPermissionPage> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<BleStatus>(
    builder: (_, status, __) {
      if (status == BleStatus.ready) {
        return WindDeviceListScreen();
      } else {
        return WindBleStatusScreen(status: status ?? BleStatus.unknown);
      }
    },
  );
}
