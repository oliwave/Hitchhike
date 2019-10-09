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
        time = parsedJson['time'],
        character = parsedJson['character'],
        text = parsedJson['text'];

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      'room': room,
      'time': time,
      'character': character,
      'text': text,
    };
  }

  final String room;
  final String time;
  final String character;
  final String text;
}
