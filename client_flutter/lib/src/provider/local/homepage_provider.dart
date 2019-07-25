import 'package:flutter/material.dart';

class HomepageProvider with ChangeNotifier {
  AnimationController controller;

  bool _isOrderPanel = false;

  bool get isOrderPanel => _isOrderPanel;

  set isOrderPanel(bool isOrderPanel) {
    _isOrderPanel = isOrderPanel;
    notifyListeners();
  }
}
