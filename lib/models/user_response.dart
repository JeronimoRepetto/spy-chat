// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

import 'package:spy_chat/models/user.dart';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  UserResponse({
    this.ok,
    this.users,
  });

  bool? ok;
  List<User>? users;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    ok: json["ok"],
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "users": List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}
