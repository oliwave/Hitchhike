import 'dart:async';

import 'package:flutter/material.dart';

class BulletinProvider extends ChangeNotifier {
  BulletinProvider._();

  factory BulletinProvider() {
    return _bulletinProvider;
  }

  static final _bulletinProvider = BulletinProvider._();

  String _showText = '公告測試';
  Color _textColor;
  Color _iconColor;
  AnimationController _bulletinSizeController;

  String get showText => _showText;
  Color get textColor => _textColor;
  Color get iconColor => _iconColor;

  void _changeBulletinState(String text, Color textColor, Color iconColor) {
    _showText = text;
    _textColor = textColor;
    _iconColor = iconColor ?? Colors.orange.withOpacity(0.65);
    notifyListeners();
  }

  set bulletinSizeController(AnimationController controller) {
    _bulletinSizeController = controller;
  }

  Future<void> showBulletin({
    @required String text,
    Color textColor = Colors.black87,
    Color iconColor,
  }) async {
    _changeBulletinState(text, textColor, iconColor);
    await _bulletinSizeController.forward();
    await Future.delayed(Duration(milliseconds: 1200));
    await _bulletinSizeController.reverse();
  }
}
