import 'dart:async';

import 'package:flutter/material.dart';

class BulletinProvider extends ChangeNotifier {
  String _showText = '公告測試';
  AnimationController _bulletinSizeController;

  String get showText => _showText;
  set showText(String text) {
    _showText = text;
    notifyListeners();
  }

  set bulletinSizeController(AnimationController controller) {
    _bulletinSizeController = controller;
  }

  Future<void> showBulletin(String text) async {
    showText = text;
    await _bulletinSizeController.forward();
    await Future.delayed(Duration(milliseconds: 1200));
    await _bulletinSizeController.reverse();
  }
}
