import 'package:flutter/material.dart';

import 'dart:convert';

import '../../resources/repository.dart';
import '../../logics/chat/chat_stream_manager.dart';
import '../../logics/chat/chat_record_manager.dart';

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
  final _socket = Repository.getSocketHandler;

  ChatStreamManager _chatStreamManager;
  ChatRecordManager _chatRecordManager;
  bool _isVisible = false;
  int touchDown = 0; // TESTING

  ChatRecordManager get chatRecordManager => _chatRecordManager;

  /// The Controller that controll the user's input text.
  TextEditingController get chatTextController => _chatController;
  ScrollController get listController => _listController;

  /// TESTING LIST
  // List<String> get testData => _testData.toList();

  /// The value of [isVisible] determines whether the [ChattingFloatingActionButton] should
  /// be displayed on the screen.
  bool get isVisible => _isVisible;

  set isVisible(bool visible) {
    _isVisible = visible;
    notifyListeners();
  }

  /// [sendMessage] is a field that used to handle the message which
  /// user input in `TextField`.
  set sendMessage(String newText) {
    // _testData.insert(0, newText); // TEST

    if (!_textFilter(newText)) return;

    var message = <String, dynamic>{
      'text': newText,
      'room': chatRecordManager.room,
      'time': DateTime.now().millisecondsSinceEpoch,
    };

    _socket.emitEvent(
      eventName: 'sendMessage',
      content: json.encode(message),
    );

    chatRecordManager.storeRecord(
      message: message,
      character: Character.me,
    );

    _listController.animateTo(
      0,
      curve: Curves.ease,
      duration: Duration(milliseconds: 400),
    );

    _chatController.clear();
    notifyListeners();
  }

  /// Tigger the callback function to load more chat messages
  /// on screen.
  reachTheTopOfListListener() {
    return (notification) {
      if (notification is ScrollEndNotification &&
          _listController.offset == _listController.position.maxScrollExtent &&
          !_listController.position.outOfRange) {
        // Update the UI for showing more chat messages on screen.
        notifyListeners();

        print('You reach the end of chat room! ${touchDown++}');
      }
    };
  }

  void initializeCacheData(String room) {
    chatRecordManager.room = room;
    notifyListeners();
  }

  bool _textFilter(String newText) {
    return newText != '';
  }

  void _initManager() {
    _chatStreamManager = ChatStreamManager(
      notifyListeners: _registerNotifyListeners,
      chattingProvider: this,
    );
    _chatRecordManager = ChatRecordManager(
      notifyListeners: _registerNotifyListeners,
      chattingProvider: this,
    );
  }

  void _registerNotifyListeners() {
    notifyListeners();
  }
}
