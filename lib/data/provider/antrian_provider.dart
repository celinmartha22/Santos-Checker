import 'package:santos_checker/constants/enum.dart';
import 'package:santos_checker/data/api/service.dart';
import 'package:santos_checker/data/model/antrian.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AntrianProvider extends ChangeNotifier {
  List<Antrian> _antrian = [];
  ListAntrian _listAntrian = ListAntrian(antrians: [], statistik: []);
  late ApiService _apiService;

  late ResultStateDb _state;
  String _message = '';
  String get message => _message;
  List<Antrian> get result => _antrian;
  ResultStateDb get state => _state;

  List<Antrian> get favorites => _antrian;
  AntrianProvider(var token) {
    _apiService = ApiService();
    _fetchAllAntrian(token);
  }

  Future<dynamic> _fetchAllAntrian(var token) async {
    try {
      _state = ResultStateDb.loading;
      notifyListeners();
      final antrian = await _apiService.getAntrian(token);
      if (antrian.antrians.isEmpty) {
        _state = ResultStateDb.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateDb.hasData;
        notifyListeners();
        return _antrian = antrian.antrians;
      }
    } catch (e) {
      _state = ResultStateDb.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> getAntrianAll(var token) async {
    try {
      _state = ResultStateDb.loading;
      notifyListeners();
      final antrian = await _apiService.getAntrian(token);
      if (antrian.antrians.isEmpty) {
        _state = ResultStateDb.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateDb.hasData;
        notifyListeners();
        return _listAntrian = antrian;
      }
    } catch (e) {
      _state = ResultStateDb.error;
      notifyListeners();
      return _message = '$e';
    }
  }
}
