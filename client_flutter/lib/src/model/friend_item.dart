class FriendItem {
  FriendItem.fromDb(Map<String, dynamic> parsedJson)
      : room = parsedJson['room'],
        name = parsedJson['name'],
        avatar = parsedJson['avatar'];

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      'room': room,
      'name': name,
      'avatar': avatar,
    };
  }

  final String room;
  final String name;
  final String avatar;
}
