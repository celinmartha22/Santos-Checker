class ListAntrian {
  ListAntrian({
    required this.antrians,
    required this.statistik,
  });

  List<Antrian> antrians;
  List<Statistik> statistik;

  factory ListAntrian.fromJson(Map<String, dynamic> json) => ListAntrian(
        antrians: List<Antrian>.from(
            (json['data'] as List).map((e) => Antrian.fromJson(e))),
        statistik: List<Statistik>.from(
            (json['statistik'] as List).map((e) => Statistik.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(antrians.map((x) => x.toJson())),
        "statistik": List<dynamic>.from(statistik.map((x) => x.toJson())),
      };
}

class Antrian {
  late String uid;
  late String nomor;
  late String nopol;
  late String typeKendaraan;
  late String kategori;
  late String gudang;
  late String supir;
  late String nohp;
  late String pendaftaran;
  late String status;
  late String estimasi;
  late String wktBongkar;
  late String batasBongkar;
  late String konfirmasi;
  late String button;

  Antrian({
    required this.uid,
    required this.nomor,
    required this.nopol,
    required this.typeKendaraan,
    required this.kategori,
    required this.gudang,
    required this.supir,
    required this.nohp,
    required this.pendaftaran,
    required this.status,
    required this.estimasi,
    required this.wktBongkar,
    required this.batasBongkar,
    required this.konfirmasi,
    required this.button,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nomor': nomor,
      'nopol': nopol,
      'type_kendaraan': typeKendaraan,
      'kategori': kategori,
      'gudang': gudang,
      'supir': supir,
      'nohp': nohp,
      'pendaftaran': pendaftaran,
      'status': status,
      'Estimasi': estimasi,
      'Wkt Bongkar': wktBongkar,
      'Batas Bongkar': batasBongkar,
      'Konfirmasi': konfirmasi,
      'button': button,
    };
  }

  Antrian.fromJson(Map<String, dynamic> map) {
    uid = map['uid'].toString();
    nomor = map['nomor'] ?? '-';
    nopol = map['nopol'] ?? '-';
    typeKendaraan = map['type_kendaraan'] ?? '-';
    kategori = map['kategori'] ?? '-';
    gudang = map['gudang'] ?? '-';
    supir = map['supir'] ?? '-';
    nohp = map['nohp'] ?? '-';
    pendaftaran = map['pendaftaran'] ?? '-';
    status = map['status'] ?? '-';
    estimasi = map['Estimasi'] ?? '-';
    wktBongkar = map['Wkt Bongkar'] ?? '-';
    batasBongkar = map['Batas Bongkar'] ?? '-';
    konfirmasi = map['Konfirmasi'] ?? '-';
    button = map['button'] ?? '-';
  }
}

class Statistik {
  late String antrian;
  late String bongkar;
  late String selesai;

  Statistik({
    required this.antrian,
    required this.bongkar,
    required this.selesai,
  });

  Map<String, dynamic> toJson() {
    return {
      'Antrian': antrian,
      'Bongkar': bongkar,
      'Selesai': selesai,
    };
  }

  Statistik.fromJson(Map<String, dynamic> map) {
    antrian = map['Antrian'].toString();
    bongkar = map['Bongkar'].toString();
    selesai = map['Selesai'].toString();
  }
}
