import 'package:flutter/material.dart';

class ChatItem {
  ChatItem({
    @required this.room,
    @required this.time,
    @required this.character,
    @required this.text,
  });

  ChatItem.fromDB(Map<String, dynamic> parsedJson)
      : room = parsedJson['room'],
        time = DateTime.fromMillisecondsSinceEpoch(parsedJson['time']),
        character = parsedJson['character'],
        text = parsedJson['text'];

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      'room': room,
      'time': time.millisecondsSinceEpoch,
      'character': character,
      'text': text,
    };
  }

  /// [room] stands for room id that corresponds to a unique friend.
  final String room;
  final DateTime time;
  final String character;
  final String text;
}
