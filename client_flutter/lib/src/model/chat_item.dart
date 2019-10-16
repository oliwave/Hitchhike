import 'package:flutter/material.dart';

class ChatItem {
  ChatItem({
    @required this.room,
    @required this.time,
    @required this.character,
    @required this.text,
  });

  ChatItem.fromInstance(Map<String, dynamic> parsedJson)
      : this._mapType(parsedJson);

  ChatItem.fromDB(Map<String, dynamic> parsedJson) : this._mapType(parsedJson);

  ChatItem._mapType(Map<String, dynamic> parsedJson)
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

  final String room;
  final DateTime time;
  final String character;
  final String text;
}
