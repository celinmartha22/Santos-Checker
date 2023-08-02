import 'dart:convert';
import 'package:get/get.dart';
import 'package:santos_checker/data/helpers/server_helper.dart';

class LogoutAction extends GetConnect {
  Future<Response> logout(var token) async {
    String urlAPI = await getURLAPI();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({"token": token});
    return post("http://$urlAPI/logout", body, headers: headers);
  }
}
