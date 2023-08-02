import 'dart:convert';
import 'package:get/get.dart';
import 'package:santos_checker/data/helpers/server_helper.dart';

class PersiapanAction extends GetConnect {
  Future<Response> mulaiPersiapan(var token, var uid) async {
    String urlAPI = await getURLAPI();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({"token": token, "uid": uid});
    return post("http://$urlAPI/persiapan", body, headers: headers);
  }

  Future<Response> selesaiPersiapan(var token, var uid) async {
    String urlAPI = await getURLAPI();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({"token": token, "uid": uid});
    return post("http://$urlAPI/selesai_persiapan", body, headers: headers);
  }
}
