import 'package:santos_checker/constants/enum.dart';
import 'package:santos_checker/data/api/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:santos_checker/data/model/gudang.dart';

class GudangProvider extends ChangeNotifier {
  List<Gudang> _gudang = [];
  late ApiService _apiService;

  late ResultStateDb _state;
  String _message = '';
  String get message => _message;
  List<Gudang> get result => _gudang;
  ResultStateDb get state => _state;

  List<Gudang> get favorites => _gudang;
  GudangProvider() {
    _apiService = ApiService();
    _fetchAllGudang();
  }

  Future<dynamic> _fetchAllGudang() async {
    try {
      _state = ResultStateDb.loading;
      notifyListeners();
      final gudang = await _apiService.getGudang();
      if (gudang.gudangs.isEmpty) {
        _state = ResultStateDb.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateDb.hasData;
        notifyListeners();
        return _gudang = gudang.gudangs;
      }
    } catch (e) {
      _state = ResultStateDb.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<ListGudang> getGudangAll() async {
    return await _apiService.getGudang();
  }
}
