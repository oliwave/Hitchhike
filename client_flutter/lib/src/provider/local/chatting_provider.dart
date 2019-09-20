import 'package:flutter/material.dart';

class ChattingProvider with ChangeNotifier {
  ChattingProvider._();

  factory ChattingProvider() {
    return _chattingProvider;
  }

  static final _chattingProvider = ChattingProvider._();

  final TextEditingController _chatController = TextEditingController();

  bool _isVisible = false;
  String _newText;

  /// The value of [isVisible] determines whether the [ChattingFloatingActionButton] shoud
  /// be displayed on the screen.
  bool get isVisible => _isVisible;

  /// Controller the user input text.
  TextEditingController get chatTextController => _chatController;

  /// [newText] is a field that used to handle the message which user input in `TextField`.
  set newText(String newText) {
    _newText = newText;
    print(_newText);
  }

  /// Invoke this method when the state of [isMatched] has been modified.
  void toggleChattingButtonVisibility(bool isMatched) {
    _isVisible = isMatched;
    notifyListeners();
  }
}
