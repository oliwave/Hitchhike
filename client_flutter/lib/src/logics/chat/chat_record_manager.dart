import 'package:flutter/material.dart';

import 'package:sqflite/sql.dart';

import '../../resources/repository.dart';
import '../../logics/notify_manager.dart';
import '../../model/chat_item.dart';
import '../../provider/provider_collection.dart' show ChattingProvider;
import '../../resources/source_collection.dart' show DatabaseHandler;

class ChatRecordManager extends NotifyManager {
  ChatRecordManager({
    @required VoidCallback notifyListeners,
    @required ChattingProvider chattingProvider,
  })  : _chattingProvider = chattingProvider,
        super(notifyListeners);

  final ChattingProvider _chattingProvider;
  final _handler = Repository.getDatabaseHandler;

  List<ChatItem> _messages = [];
  int _startIndex = -25;
  bool _hasMoreMessages = true;
  String room = 'testRoom';

  Future<List<ChatItem>> get messages async => await _getMoreMessages();

  void storeRecord(
    Map<String, dynamic> message,
  ) {
    message['room'] = room;

    // 1. add new message to chatItems
    _messages.insert(0, ChatItem.fromInstance(message));

    // When you insert a new message, sort the ChatItem list again.
    // (Sort the list from closer to a long time from now)
    _messages.sort((pre, cur) => cur.time.millisecondsSinceEpoch
        .compareTo(pre.time.millisecondsSinceEpoch));

    print(message);

    // 2. store new message to database
    _handler.db.insert(
      DatabaseHandler.chatRecords,
      message,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<ChatItem>> _getMoreMessages() async {
    var oldMessages = <ChatItem>[];

    print('The value of hasMoreMessages is $_hasMoreMessages');

    if (_hasMoreMessages) {
      oldMessages = await _retrieveRecords(
        room: room,
        startIndex: (_startIndex += 25),
        amount: 25, // It's a hardcode value.
      );

      print('Get more message!');

      _hasMoreMessages = oldMessages.isNotEmpty;
    }

    return _messages = [
      ..._messages,
      ...oldMessages,
    ];
  }

  /// Fetch the specific message records with given [room] that identifies
  /// the people who user wants to talk with.
  ///
  /// - [room] is a unique id of a room.
  /// - [startIndex] is the starting point of the record list.
  /// - [amount] is the amount of message records that user want to retrieve.
  Future<List<ChatItem>> _retrieveRecords({
    @required String room,
    @required int startIndex,
    @required int amount,
  }) async {
    final rawRecords = await _handler.db.query(
      DatabaseHandler.chatRecords,
      where: 'room = ?',
      whereArgs: [room],
      offset: startIndex,
      limit: amount,
      orderBy: 'time DESC',
    );

    final chatItems =
        rawRecords.map((record) => ChatItem.fromDB(record)).toList();

    return chatItems;
  }

  releaseCacheData() {
    _messages = [];
    room = null;
    _startIndex = -25;
    _hasMoreMessages = true;
  }
}
