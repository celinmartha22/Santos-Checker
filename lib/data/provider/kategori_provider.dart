import 'package:santos_checker/constants/enum.dart';
import 'package:santos_checker/data/api/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:santos_checker/data/model/kategori.dart';

class KategoriProvider extends ChangeNotifier {
  List<Kategori> _kategori = [];
  late ApiService _apiService;

  late ResultStateDb _state;
  String _message = '';
  String get message => _message;
  List<Kategori> get result => _kategori;
  ResultStateDb get state => _state;

  List<Kategori> get favorites => _kategori;
  KategoriProvider() {
    _apiService = ApiService();
    _fetchAllKategori();
  }

  Future<dynamic> _fetchAllKategori() async {
    try {
      _state = ResultStateDb.loading;
      notifyListeners();
      final kategori = await _apiService.getKategori();
      if (kategori.kategoris.isEmpty) {
        _state = ResultStateDb.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateDb.hasData;
        notifyListeners();
        return _kategori = kategori.kategoris;
      }
    } catch (e) {
      _state = ResultStateDb.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<ListKategori> getKategoriAll() async {
    return await _apiService.getKategori();
  }
}
