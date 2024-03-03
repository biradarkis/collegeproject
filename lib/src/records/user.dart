class User {
  String email;
  String name;
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.createdAt,
      required this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]));
  }
}
