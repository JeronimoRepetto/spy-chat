import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spy_chat/helpers/show_alert.dart';
import 'package:spy_chat/services/auth_service.dart';
import 'package:spy_chat/services/socket_service.dart';

import '../widget/custom_button.dart';
import '../widget/custom_input.dart';
import '../widget/label.dart';
import '../widget/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Logo(title: 'SpyChat'),
                  _Form(),
                  const Labels(
                      routeName: 'register',
                      title: "¿Don't have account?",
                      subTitle: 'Create account now!'),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'terms & conditions',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            CustomWidget(
              hint: 'Email',
              icon: Icons.email_outlined,
              keyboard: TextInputType.emailAddress,
              textController: emailController,
            ),
            CustomWidget(
              hint: 'Password',
              icon: Icons.password_outlined,
              keyboard: TextInputType.visiblePassword,
              obscureText: true,
              textController: passController,
            ),
            CustomButton(
              onPressed: authService.authenticating
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final loginOk = await authService.login(
                          emailController.text.trim(),
                          passController.text.trim());
                      if (loginOk) {
                        socketService.connect();
                        Navigator.pushReplacementNamed(context, 'users');
                      } else {
                        showAlert(
                            context, 'Error login', 'check your credentials');
                      }
                    },
              text: 'Login',
            )
          ],
        ));
  }
}
