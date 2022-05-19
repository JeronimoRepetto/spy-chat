import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:spy_chat/global/enviroment.dart';
import 'package:spy_chat/models/login_response.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool _authenticated = false;
  bool get authenticating => _authenticated;
  set authenticated(bool val) {
    _authenticated = val;
    notifyListeners();
  }

  // Getters of token - statics

  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token ?? '';
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  final _storage = FlutterSecureStorage();

  Future<bool> login(String email, String pass) async {
    authenticated = true;
    // Create storage
    final data = {"email": email, "password": pass};

    final result = await http.post(Uri.parse('${Environment.apiUrl}/login'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    print(result.body);
    if (result.statusCode == 200) {
      final loginResponse = loginResponseFromJson(result.body);
      _user = loginResponse.user;
      authenticated = false;
      _saveToken(loginResponse.token ?? '');
      return true;
    } else {
      authenticated = false;
      return false;
    }
  }

  Future<dynamic> register(String name, String email, String pass) async {
    authenticated = true;
    // Create storage
    final data = {"name": name, "email": email, "password": pass};

    final result = await http.post(Uri.parse('${Environment.apiUrl}/login/new'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});
    print(result.body);
    if (result.statusCode == 200) {
      final loginResponse = loginResponseFromJson(result.body);
      _user = loginResponse.user;
      authenticated = false;
      _saveToken(loginResponse.token ?? '');
      return true;
    } else {
      authenticated = false;
      final body = jsonDecode(result.body);
      return body['msg'];
    }
  }

  Future<bool> isLogged()async{
    final token = await _storage.read(key: 'token');
    final result = await http.get(Uri.parse('${Environment.apiUrl}/login/newToken'), headers: {
      'Content-Type': 'application/json',
      'x-token' : token.toString()
    });
    if (result.statusCode == 200) {
      final loginResponse = loginResponseFromJson(result.body);
      _user = loginResponse.user;
      authenticated = false;
      _saveToken(loginResponse.token ?? '');
      return true;
    } else {
      authenticated = false;
      logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
