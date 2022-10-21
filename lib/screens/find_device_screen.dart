


import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth/screens/widgets.dart';

import 'device_screen.dart';



//if the bluetooth is on then this screen will display
class FindDeviceScreen extends StatelessWidget {
  const FindDeviceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => FlutterBluePlus.instance.stopScan(),
              backgroundColor: Colors.red,
              child:  const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => FlutterBluePlus.instance
                    .startScan(timeout: const Duration(seconds: 4)));
          }
        },
      ),
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Find Devices'),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                primary: Colors.black.withOpacity(0.5),
                onPrimary: Colors.white,
              ),
              onPressed: Platform.isAndroid
                  ? () => FlutterBluePlus.instance.turnOff()
                  : null,
              child: const Text('TURN OFF'),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: [
               StreamBuilder<List<BluetoothDevice>>(
                   stream: Stream.periodic(const Duration(seconds: 2))
                       .asyncMap((_) => FlutterBluePlus.instance.connectedDevices),
                   builder: (context, snapshot) {
                 return Column(
                   children: snapshot.data!.map((d) => ListTile(
                     title: Text(d.name),
                     subtitle: Text(d.id.toString()),
                     trailing: StreamBuilder<BluetoothDeviceState>(
                       stream: d.state,
                       initialData: BluetoothDeviceState.disconnected,
                       builder: (c, snapshot) {
                         if (snapshot.data ==
                             BluetoothDeviceState.connected) {
                           return ElevatedButton(
                             child: const Text('OPEN'),
                             onPressed: () => Navigator.of(context).push(
                                 MaterialPageRoute(
                                     builder: (context) =>
                                         DeviceScreen(device: d))),
                           );
                         }
                         return Text(snapshot.data.toString());
                       },
                     ),
                   )).toList()
                 );
               }),
               StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.instance.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                      result: r,
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        r.device.connect();
                        return DeviceScreen(device: r.device);
                      })),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
