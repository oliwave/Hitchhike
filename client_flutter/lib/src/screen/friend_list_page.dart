import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/loading_container.dart';
import '../widgets/general_app_bar.dart';
import '../provider/provider_collection.dart';
import '../model/friend_item.dart';
import './chatting_page.dart';

class FriendListPage extends StatelessWidget {
  static const String routeName = "/friend_list_page";

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChattingProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        title: GeneralAppBar(
          title: '朋友',
          heroTag: 'chat',
          icon: Icons.people,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Consumer<FriendListProvider>(
          builder: (context, provider, child) {
            return FutureBuilder(
              future: provider.fetchFriendList(),
              builder: (context, AsyncSnapshot<List<FriendItem>> snapshot) {
                if (!snapshot.hasData) return LoadingContainer();

                final friends = snapshot.data;

                print('My friend is : $friends');

                return friends.isNotEmpty
                    ? ListView.builder(
                        itemCount: friends?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                'TESTING',
                              ),
                            ),
                            title: Text(friends[index].name),
                            trailing: friends[index].hasNewMessage
                                ? Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
                            onTap: () => _openChatRoom(
                              chatProvider,
                              provider,
                              friends[index],
                              context,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          '沒朋友還不去交！',
                          style: TextStyle(
                            fontSize: 17,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }

  void _openChatRoom(
    ChattingProvider chatProvider,
    FriendListProvider friendProvider,
    FriendItem friend,
    BuildContext context,
  ) {
    chatProvider.initializeCacheData(friend.room);

    Navigator.pushNamed(
      context,
      ChattingPage.routeName,
    );

    friendProvider.removeUnreadFriend(friend.room);
  }
}
