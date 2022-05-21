import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spy_chat/pages/login_page.dart';
import 'package:spy_chat/pages/users_pages.dart';

import '../services/auth_service.dart';
import '../services/socket_service.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Center(
            child: Text('loading...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final authenticated = await authService.isLogged();
    if (authenticated) {
      socketService.connect();
      //Navigator.pushReplacementNamed(context, 'users');
      Navigator.pushReplacement(
          context, PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsersPage()));
    } else {
      //Navigator.pushReplacementNamed(context, 'login');
      Navigator.pushReplacement(
          context, PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage()));
    }
  }
}
