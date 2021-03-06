import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spy_chat/routes/routes.dart';
import 'package:spy_chat/services/auth_service.dart';
import 'package:spy_chat/services/chat_service.dart';
import 'package:spy_chat/services/socket_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SpyChat',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
