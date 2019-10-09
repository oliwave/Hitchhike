import 'package:flutter/material.dart';

import '../../logics/chat/chat_stream_manager.dart';

class ChattingProvider with ChangeNotifier {
  ChattingProvider._() {
    _initManager();
  }

  factory ChattingProvider() {
    return _chattingProvider;
  }

  static final _chattingProvider = ChattingProvider._();

  final TextEditingController _chatController = TextEditingController();
  final ScrollController _listController = ScrollController();

  ChatStreamManager _chatStreamManager;

  bool _isVisible = false;
  List<String> _data = [
    '使用者發送訊息的時間。',
    '兩個使用者共用的一個 **聊天室ID 也就是 roomId**。不使用聊天對象的JWT',
    '來辨別訊息的歸屬，是因為避免唯',
    '一辨別使用者的ID散播到其他裝置上。至於 `roomId`',
    '成功時放在 `fcm` 一起傳到使用者端。 text: 聊天的內容。',
  ];

  List<String> get data => _data.reversed.toList();

  /// The value of [isVisible] determines whether the [ChattingFloatingActionButton] shoud
  /// be displayed on the screen.
  bool get isVisible => _isVisible;

  /// Controller the user input text.
  TextEditingController get chatTextController => _chatController;
  ScrollController get listController => _listController;

  /// [newText] is a field that used to handle the message which
  /// user input in `TextField`.
  set newText(String newText) {
    _data.add(newText);
    _listController.animateTo(
      0,
      curve: Curves.ease,
      duration: Duration(milliseconds: 400),
    );
    _chatController.clear();
    notifyListeners();
  }

  /// Invoke this method when the state of [isMatched] has been modified.
  void toggleChattingButtonVisibility(bool isMatched) {
    _isVisible = isMatched;
    notifyListeners();
  }

  void _initManager() {
    _chatStreamManager = ChatStreamManager(
      notifyListeners: _registerNotifyListeners,
      chattingProvider: this,
    );
  }

  void _registerNotifyListeners() {
    notifyListeners();
  }
}
