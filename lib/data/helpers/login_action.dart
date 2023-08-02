import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santos_checker/data/api/firebase_api.dart';
import 'package:santos_checker/data/helpers/server_helper.dart';

class LoginAction extends GetConnect {
  Future<Response> auth(var nik, var password) async {
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    final fCMToken = await firebaseMessaging.getToken();
    debugPrint("Firebase Token Login: $fCMToken");


    String urlAPI = await getURLAPI();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({"nik": nik, "password": password, "fcm": fCMToken});
    return post("http://$urlAPI/login", body, headers: headers);
  }
}
