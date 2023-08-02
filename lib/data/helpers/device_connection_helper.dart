import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:santos_checker/controllers/network_connectivity_controller.dart';

bool isConnectInternet = true;
bool isConnectServer = true;

void checkDeviceConnection(BuildContext context,
    NetworkConnectivity deviceConnectivity, Map sourceMap) {
  deviceConnectivity.initialise();
  deviceConnectivity.myStream.listen((source) {
    sourceMap = source;
    late bool isConnectTemp = true;
    switch (sourceMap.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        isConnectTemp = sourceMap.values.toList()[0] ? true : false;
        break;
      case ConnectivityResult.wifi:
        isConnectTemp = sourceMap.values.toList()[0] ? true : false;
        break;
      case ConnectivityResult.none:
      default:
        isConnectTemp = false;
    }

    if (isConnectTemp != isConnectInternet) {
      isConnectInternet = isConnectTemp;
      if (isConnectInternet) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Anda kembali Online"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Anda sedang Offline. Periksa koneksi internet anda"),
          backgroundColor: Colors.grey,
        ));
      }
    }
  });
}
