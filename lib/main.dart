import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth/screens/bluetooth_off_screen.dart';
import 'package:flutter_bluetooth/screens/find_device_screen.dart';

void main() {
  runApp(Bluetoothexample());
}

class Bluetoothexample extends StatelessWidget {
  const Bluetoothexample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Bluetooth Example",
      home: FlutterBlueShow(),
    );
  }
}

class FlutterBlueShow extends StatelessWidget {
  const FlutterBlueShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FlutterBluePlus.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return FindDeviceScreen(); //Bluetooth Off
          }
          return BluetoothOffScreen(); //Bluetooth On
        },
      ),
    );
  }
}
