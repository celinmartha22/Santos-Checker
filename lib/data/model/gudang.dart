class ListGudang {
  ListGudang({
    required this.gudangs,
  });

  List<Gudang> gudangs;

  factory ListGudang.fromJson(Map<String, dynamic> json) => ListGudang(
        gudangs: List<Gudang>.from(
            (json['data'] as List).map((e) => Gudang.fromMap(e))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(gudangs.map((x) => x.toMap())),
      };
}

class Gudang {
  late String idGudang;
  late String namaGudang;

  Gudang({
    required this.idGudang,
    required this.namaGudang,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': idGudang,
      'gudang': namaGudang,
    };
  }

  Gudang.fromMap(Map<String, dynamic> map) {
    idGudang = map['id'].toString();
    namaGudang = map['gudang'];
  }
}
