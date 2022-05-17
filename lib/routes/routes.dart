
import 'package:flutter/cupertino.dart';
import 'package:spy_chat/pages/loading_page.dart';
import 'package:spy_chat/pages/login_page.dart';
import 'package:spy_chat/pages/register_page.dart';
import 'package:spy_chat/pages/users_pages.dart';
import '../pages/chat_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users' : (_) => const UsersPage(),
  'chat' : (_) => const ChatPage(),
  'login' : (_) => const LoginPage(),
  'register' : (_) => const RegisterPage(),
  'loading' : (_) => const LoadingPage(),

};
