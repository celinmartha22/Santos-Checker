class ListReport {
  ListReport({
    required this.reports,
    required this.statistik,
  });

  List<Report> reports;
  List<StatistikReport> statistik;

  factory ListReport.fromJson(Map<String, dynamic> json) => ListReport(
        reports: List<Report>.from(
            (json['data'] as List).map((e) => Report.fromJson(e))),
        statistik: List<StatistikReport>.from((json['statistik'] as List)
            .map((e) => StatistikReport.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(reports.map((x) => x.toJson())),
      };
}

class Report {
  late String nomor;
  late String gudang;
  late String nopol;
  late String typeKendaraan;
  late String pendaftaran;
  late String persiapan;
  late String selesai;
  late String estimasi;
  late String batas;
  late String realisasi;

  Report({
    required this.nomor,
    required this.nopol,
    required this.gudang,
    required this.typeKendaraan,
    required this.pendaftaran,
    required this.persiapan,
    required this.selesai,
    required this.estimasi,
    required this.batas,
    required this.realisasi,
  });

  Map<String, dynamic> toJson() {
    return {
      'nomor': nomor,
      'nopol': nopol,
      'gudang': gudang,
      'type_kendaraan': typeKendaraan,
      'pendaftaran': pendaftaran,
      'persiapan': persiapan,
      'estimasi': estimasi,
      'batas': batas,
      'Wkt Bongkar': selesai,
      'Batas Bongkar': realisasi,
    };
  }

  Report.fromJson(Map<String, dynamic> map) {
    nomor = map['nomor'] ?? '-';
    nopol = map['nopol'] ?? '-';
    gudang = map['gudang'] ?? '-';
    typeKendaraan = map['type_kendaraan'] ?? '-';
    pendaftaran = map['pendaftaran'] ?? '-';
    persiapan = map['persiapan'] ?? '-';
    selesai = map['selesai'] ?? '-';
    estimasi = map['estimasi'] ?? '-';
    batas = map['batas'] ?? '-';
    realisasi = map['realisasi'] ?? '-';
  }
}

class StatistikReport {
  late String gudang;
  late String jumlah;

  StatistikReport({
    required this.gudang,
    required this.jumlah,
  });

  Map<String, dynamic> toJson() {
    return {
      'gudang': gudang,
      'jumlah': jumlah,
    };
  }

  StatistikReport.fromJson(Map<String, dynamic> map) {
    gudang = map['gudang'].toString();
    jumlah = map['jumlah'].toString();
  }
}
