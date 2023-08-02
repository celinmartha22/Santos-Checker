class User {
  late String idUser;
  late String username;
  late String password;
  late String name;
  late String kategori;
  late String token;
  late String email;
  late String image;
  late String sja;
  late int loginStatus;

  User({
    required this.idUser,
    required this.username,
    required this.password,
    required this.name,
    required this.kategori,
    required this.token,
    required this.email,
    required this.image,
    required this.sja,
    required this.loginStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': idUser,
      'username': username,
      'firstName': name,
      'kategori': kategori,
      'email': email,
      'image': image,
      'sja': sja,
      'token': token,
      'loginStatus': loginStatus,
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    idUser = map['id'] as String;
    username = map['username'];
    password = map['password'];
    name = map['firstName'];
    kategori = map['kategori'];
    email = map['email'];
    image = map['image'];
    sja = map['sja'];
    loginStatus = map['loginStatus'] ?? 1;
  }
}
