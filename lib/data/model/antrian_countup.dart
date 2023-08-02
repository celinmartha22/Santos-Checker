class AntrianTimerCountUp {
  late String uid;
  late String nomor;
  late String waktuBongkar;
  late String estimasi;
  late String waktuBatasBongkar;

  AntrianTimerCountUp({
    required this.uid,
    required this.nomor,
    required this.waktuBongkar,
    required this.estimasi,
    required this.waktuBatasBongkar,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nomor': nomor,
      'waktuBongkar': waktuBongkar,
      'estimasi': estimasi,
      'waktuBatasBongkar': waktuBatasBongkar,
    };
  }

  AntrianTimerCountUp.fromJson(Map<String, dynamic> map) {
    uid = map['uid'].toString();
    nomor = map['nomor'] ?? '-';
    waktuBongkar = map['waktuBongkar'] ?? '-';
    estimasi = map['estimasi'] ?? '-';
    waktuBatasBongkar = map['waktuBatasBongkar'] ?? '-';
  }
}
