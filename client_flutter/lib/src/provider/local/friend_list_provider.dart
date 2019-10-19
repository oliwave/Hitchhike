import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../resources/source_collection.dart' show DatabaseHandler;
import '../../resources/repository.dart';
import '../../model/friend_item.dart';

class FriendListProvider with ChangeNotifier {
  FriendListProvider._();

  factory FriendListProvider() {
    return _friendListProvider;
  }

  static final FriendListProvider _friendListProvider = FriendListProvider._();

  /// Cached the a list of unread friends, so user don't repeatly
  /// write the [hasNewMessage] into db.
  List<String> _recentUnreadFriends = [];

  final _handler = Repository.getDatabaseHandler;

  // List<String> get recentUnreadFriends => [..._recentUnreadFriends];

  /// Add the room to [_recentUnreadFriends] list.
  set addUnreadFriend(String room) => _recentUnreadFriends.add(room);

  /// A helper method to let user know if the [targetRoom] is in the [_recentUnreadFriends] list.
  bool friendIsUnread(String targetRoom) =>
      _recentUnreadFriends.firstWhere(
        (room) => targetRoom == room,
        orElse: () => null,
      ) !=
      null;

  /// User should invoke this when the specific room was tapped.
  bool removeUnreadFriend(String room) {
    if (!friendIsUnread(room)) return false;

    _updateFriend(room, false);

    return _recentUnreadFriends.remove(room);
  }

  void updateHasNewMessage({
    @required String room,
    @required bool hasNewMessage,
  }) {
    _updateFriend(room, hasNewMessage);
  }

  Future<List<FriendItem>> fetchFriendList() async {
    return (await _handler.db.query(
      DatabaseHandler.friends,
      orderBy: 'hasNewMessage DESC',
    ))
        .map((friend) => FriendItem.fromDb(friend))
        .toList();
  }

  Future<void> addFriend(FriendItem friend) async {
    if (!await isFriend(friend.room)) {
      _handler.db.insert(
        DatabaseHandler.friends,
        friend.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<bool> isFriend(String room) async {
    final friend = await _handler.db.query(
      DatabaseHandler.friends,
      where: 'room = ?',
      whereArgs: [room],
    );

    return friend.isNotEmpty;
  }

  void _updateFriend(String room, bool hasNewMessage) {
    _handler.db.update(
      DatabaseHandler.friends,
      {'hasNewMessage': hasNewMessage ? 1 : 0},
      where: 'room = ?',
      whereArgs: [room],
    );
  }
}
