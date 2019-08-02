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

  void showBulletin(String text) {
    showText = text;
    _bulletinSizeController
        .forward()
        .then((_) => Future.delayed(Duration(milliseconds: 1200)))
        .then((_) => _bulletinSizeController.reverse());
  }
}
