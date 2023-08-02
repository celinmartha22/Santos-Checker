import 'dart:convert';

import 'package:get/get.dart';
import 'package:santos_checker/data/helpers/server_helper.dart';

class BongkarAction extends GetConnect {
  Future<Response> mulaiBongkar(var token, var uid) async {
    String urlAPI = await getURLAPI();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({"token": token, "uid": uid});
    return post("http://$urlAPI/bongkar", body, headers: headers);
  }

  Future<Response> selesaiBongkar(var token, var uid) async {
    String urlAPI = await getURLAPI();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({"token": token, "uid": uid});
    return post("http://$urlAPI/selesai_bongkar", body, headers: headers);
  }
}
