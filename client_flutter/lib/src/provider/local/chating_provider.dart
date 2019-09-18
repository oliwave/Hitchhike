import 'package:flutter/material.dart';

class ChatingProvider with ChangeNotifier {
  ChatingProvider._();

  factory ChatingProvider() {
    return _chatingProvider;
  }

  static final _chatingProvider = ChatingProvider._();

  bool _isVisible = false;

  bool get isVisible => _isVisible;

  void toggleChatingButtonVisibility(bool isMatched) {
    _isVisible = isMatched;
    notifyListeners();
  }
}
