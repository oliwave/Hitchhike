import 'package:flutter/material.dart';

import '../../logics/notify_manager.dart';
import '../../provider/provider_collection.dart' show ChattingProvider;
import '../../resources/repository.dart';

class ChatStreamManager extends NotifyManager {
  ChatStreamManager({
    @required VoidCallback notifyListeners,
    @required ChattingProvider chattingProvider,
  })  : _chattingProvider = chattingProvider,
        super(notifyListeners) {
    _triggerListener();
  }

  final ChattingProvider _chattingProvider;
  final _socketHandler = Repository.getSocketHandler;

  /// The [Character] of incoming message must be [Character.otherSide].
  void listenPreviousMessagesStream() =>
      _socketHandler.getPreviousMessagesStream.listen(_preMessage);

  /// The [Character] of incoming message must be [Character.otherSide].
  void listenNewMessageStream() =>
      _socketHandler.getNewMessageStream.listen(_newMessage);

  void _preMessage(List<Map<String, dynamic>> messages) {
    for (var message in messages) {
      _messageProcessor(message);
    }
  }

  void _newMessage(Map<String, dynamic> message) {
    _messageProcessor(message);
  }

  void _messageProcessor(Map<String, dynamic> message) {
    _chattingProvider.chatRecordManager.storeRecord(
      message: message,
      character: Character.otherSide,
    );

    notifyListeners();
  }

  void _triggerListener() {
    listenNewMessageStream();
    listenPreviousMessagesStream();
  }
}
