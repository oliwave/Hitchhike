import 'package:flutter/material.dart';

class FriendItem {
  FriendItem({
    @required this.room,
    @required this.name,
    @required this.avatar,
  }) : hasNewMessage = false;

  FriendItem.fromDb(Map<String, dynamic> parsedJson)
      : room = parsedJson['room'],
        name = parsedJson['name'],
        avatar = parsedJson['avatar'],
        hasNewMessage = parsedJson['hasNewMessage'] == 1;

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      'room': room,
      'name': name,
      'avatar': avatar,
      'hasNewMessage': hasNewMessage ? 1 : 0,
    };
  }

  /// [room] stands for room id that corresponds to a unique friend.
  final String room;
  final String name;
  final String avatar;
  final bool hasNewMessage;
}
