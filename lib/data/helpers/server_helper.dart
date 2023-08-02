import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

Future<String> getURLServer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  String urlServer = "nakulasadewa.co.id";
  return urlServer;
}

Future<String> getURLAPI() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  String urlAPI = "nakulasadewa.co.id/bongkar/restapi/public/api";
  return urlAPI;
}

Future<String> getToken() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  String token = SpUtil.getString('token')!;
  return token;
}

Future<String> getTokenFcm() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  String fcm = SpUtil.getString('fcm')!;
  return fcm;
}