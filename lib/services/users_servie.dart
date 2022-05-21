import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spy_chat/global/enviroment.dart';
import 'package:spy_chat/models/user.dart';
import 'package:spy_chat/models/user_response.dart';
import 'package:spy_chat/services/auth_service.dart';

class UserService {
  Future<List<User>?> getUsers() async {
    try {
      final result = await http.get(Uri.parse('${Environment.apiUrl}/users'),
          headers: {
            'Content-type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      final userResponse = userResponseFromJson(result.body);
      return userResponse.users;
    } catch (error) {
      return [];
    }
  }
}
