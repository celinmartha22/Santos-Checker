import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:santos_checker/data/helpers/server_helper.dart';
import 'package:santos_checker/data/model/antrian.dart';
import 'package:santos_checker/data/model/gudang.dart';
import 'package:santos_checker/data/model/kategori.dart';
import 'package:santos_checker/data/model/report.dart';

class ApiService {
  Future<ListAntrian> getAntrian(var token) async {
    try {
      String urlAPI = await getURLAPI();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({"token": token});
      final response = await http.post(Uri.parse('http://$urlAPI/antrian'),
          body: body, headers: headers);
      if (response.statusCode == 200) {
        debugPrint("response getAntrian body ==>  ${response.body.toString()}");
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          return ListAntrian.fromJson(jsonDecode(response.body));
        } else {
          return Future(() => ListAntrian(antrians: [], statistik: []));
        }
      } else {
        debugPrint('ResponseException getAntrian: ${response.reasonPhrase}');
        throw Exception(response.reasonPhrase);
      }
    } on http.ClientException catch (e) {
      debugPrint('ClientException getAntrian: ${e.message}');
      throw Exception(e.message);
    } on SocketException catch (e) {
      debugPrint('SocketException getAntrian: ${e.message}');
      throw Exception(e.message);
    } on TimeoutException catch (e) {
      debugPrint('Timeout getAntrian: ${e.message}');
      throw Exception(e.message);
    } on Error catch (e) {
      debugPrint('Error getAntrian: $e');
      throw Exception(e);
    }
  }

  Future<ListReport> getReport(var token) async {
    try {
      String urlAPI = await getURLAPI();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({"token": token});
      final response = await http.post(Uri.parse('http://$urlAPI/report'),
          body: body, headers: headers);
      if (response.statusCode == 200) {
        debugPrint("response getReport body ==>  ${response.body.toString()}");
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          return ListReport.fromJson(jsonDecode(response.body));
        } else {
          return Future(() => ListReport(reports: [], statistik: []));
        }
      } else {
        debugPrint('ResponseException getReport: ${response.reasonPhrase}');
        throw Exception(response.reasonPhrase);
      }
    } on http.ClientException catch (e) {
      debugPrint('ClientException getReport: ${e.message}');
      throw Exception(e.message);
    } on SocketException catch (e) {
      debugPrint('SocketException getReport: ${e.message}');
      throw Exception(e.message);
    } on TimeoutException catch (e) {
      debugPrint('Timeout getReport: ${e.message}');
      throw Exception(e.message);
    } on Error catch (e) {
      debugPrint('Error getReport: $e');
      throw Exception(e);
    }
  }

  Future<ListGudang> getGudang() async {
    try {
      String urlAPI = await getURLAPI();
      String token = await getToken();

      final body = jsonEncode({"token": token});
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.post(Uri.parse('http://$urlAPI/gudang'),
          body: body, headers: headers);
      if (response.statusCode == 200) {
        debugPrint("response get Gudang body ==>  ${response.body.toString()}");
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          return ListGudang.fromJson(jsonDecode(response.body));
        } else {
          return Future(() => ListGudang(gudangs: []));
        }
      } else {
        throw Exception('Failed to load Gudang');
      }
    } on SocketException catch (e) {
      debugPrint('SocketException getGudang: ${e.message}');
      return Future(() => ListGudang(gudangs: []));
    } on TimeoutException catch (e) {
      debugPrint('Timeout getGudang: ${e.message}');
      return Future(() => ListGudang(gudangs: []));
    } on Error catch (e) {
      debugPrint('Error getGudang: $e');
      return Future(() => ListGudang(gudangs: []));
    }
  }

  Future<ListKategori> getKategori() async {
    try {
      String urlAPI = await getURLAPI();
      String token = await getToken();

      final body = jsonEncode({"token": token});
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.post(Uri.parse('http://$urlAPI/kategori'),
          body: body, headers: headers);
      if (response.statusCode == 200) {
        debugPrint(
            "response get Kategori body ==>  ${response.body.toString()}");
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          return ListKategori.fromJson(jsonDecode(response.body));
        } else {
          return Future(() => ListKategori(kategoris: []));
        }
      } else {
        throw Exception('Failed to load Kategori');
      }
    } on SocketException catch (e) {
      debugPrint('SocketException getKategori: ${e.message}');
      return Future(() => ListKategori(kategoris: []));
    } on TimeoutException catch (e) {
      debugPrint('Timeout getGudang: ${e.message}');
      return Future(() => ListKategori(kategoris: []));
    } on Error catch (e) {
      debugPrint('Error getGudang: $e');
      return Future(() => ListKategori(kategoris: []));
    }
  }
}
