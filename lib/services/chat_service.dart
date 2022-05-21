import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spy_chat/global/enviroment.dart';
import 'package:spy_chat/models/message.dart';
import 'package:spy_chat/models/message_response.dart';
import 'package:spy_chat/services/auth_service.dart';

import '../models/user.dart';

class ChatService with ChangeNotifier {
  User? userToSend;

  Future<List<Message>?> getChat(String uid) async {
    final result = await http.get(
        Uri.parse('${Environment.apiUrl}/messages/$uid'),
     headers: {
      'Content-Type': 'application/json',
       'x-token': await AuthService.getToken()
     },
    );

    final messagesResponse = messageResponseFromJson(result.body);
    return messagesResponse.messages;
  }
}
