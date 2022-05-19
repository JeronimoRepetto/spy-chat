// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.name,
    this.email,
    this.online,
    this.uid,
  });

  String? name;
  String? email;
  bool? online;
  String? uid;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    online: json["online"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "online": online,
    "uid": uid,
  };
}
