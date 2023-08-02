class ListKategori {
  ListKategori({
    required this.kategoris,
  });

  List<Kategori> kategoris;

  factory ListKategori.fromJson(Map<String, dynamic> json) => ListKategori(
        kategoris: List<Kategori>.from(
            (json['data'] as List).map((e) => Kategori.fromMap(e))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(kategoris.map((x) => x.toMap())),
      };
}

class Kategori {
  late String idKategori;
  late String namaKategori;

  Kategori({
    required this.idKategori,
    required this.namaKategori,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': idKategori,
      'kategori': namaKategori,
    };
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    idKategori = map['id'].toString();
    namaKategori = map['kategori'];
  }
}
