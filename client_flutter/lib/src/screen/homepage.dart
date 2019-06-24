import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
    );
  }
}
