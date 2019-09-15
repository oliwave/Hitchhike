import 'package:flutter/material.dart';

class BadRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '404 NOT FOUND.',
          style: TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}
