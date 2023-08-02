import 'package:santos_checker/constants/enum.dart';
import 'package:santos_checker/data/api/service.dart';
import 'package:santos_checker/data/model/report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// import 'package:santos_checker/data/model/report.dart';

class ReportProvider extends ChangeNotifier {
  List<Report> _report = [];
  ListReport _listReport = ListReport(reports: [], statistik: []);
  late ApiService _apiService;

  late ResultStateDb _state;
  String _message = '';
  String get message => _message;
  List<Report> get result => _report;
  ResultStateDb get state => _state;

  List<Report> get favorites => _report;
  ReportProvider(var token) {
    //, var namaGudang
    _apiService = ApiService();
    _fetchAllReport(token); //, namaGudang
  }

  Future<dynamic> _fetchAllReport(var token) async {
    //, var namaGudang
    try {
      _state = ResultStateDb.loading;
      notifyListeners();
      final report = await _apiService.getReport(token); //, namaGudang
      if (report.reports.isEmpty) {
        _state = ResultStateDb.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateDb.hasData;
        notifyListeners();
        return _report = report.reports;
      }
    } catch (e) {
      _state = ResultStateDb.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  // Future<ListReport> getReportAll(var token, var namaGudang) async {
  //   try {
  //     _state = ResultStateDb.loading;
  //     notifyListeners();
  //     return await _apiService.getReport(token, namaGudang);
  //   } catch (e) {
  //     debugPrint('Error --> $e');
  //     return ListReport(reports: [], statistik: []);
  //   }
  // }

  Future<dynamic> getReportAll(var token) async {
    //, var namaGudang
    try {
      _state = ResultStateDb.loading;
      notifyListeners();
      final report = await _apiService.getReport(token); //, namaGudang
      if (report.reports.isEmpty) {
        _state = ResultStateDb.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateDb.hasData;
        notifyListeners();
        return _listReport = report;
      }
    } catch (e) {
      _state = ResultStateDb.error;
      notifyListeners();
      return _message = '$e';
    }
  }
}
