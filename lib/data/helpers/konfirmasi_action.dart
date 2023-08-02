import 'dart:convert';
import 'package:get/get.dart';
import 'package:santos_checker/data/helpers/server_helper.dart';

class KonfirmasiAction extends GetConnect {
  Future<Response> konfirmasi(var token, var uid) async {
    String urlAPI = await getURLAPI();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({"token": token, "uid": uid});
    return post("http://$urlAPI/konfirmasi_supir", body, headers: headers);
  }
}
