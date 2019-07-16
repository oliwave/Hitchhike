import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = '/login_page';

  const LoginPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginPage'),
      ),
    );
  }
}
