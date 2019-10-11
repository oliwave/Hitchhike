import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:bubble/bubble.dart';

import '../../provider/provider_collection.dart' show ChattingProvider;
import '../../resources/repository.dart';
import '../../widgets/loading_container.dart';
import '../../model/chat_item.dart';

import './chat_bubble_style.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Consumer<ChattingProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: provider.chatRecordManager.messages,
            builder: (
              BuildContext context,
              AsyncSnapshot<List<ChatItem>> snapshot,
            ) {
              if (!snapshot.hasData) {
                return LoadingContainer();
              }

              final chatItems = snapshot.data;

              return NotificationListener(
                child: ListView.builder(
                  reverse: true,
                  // itemCount: provider.testData.length,
                  itemCount: chatItems.length,
                  controller: provider.listController,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Bubble(
                        nip: BubbleNip.no,
                        // style: index % 2 == 0
                        style: chatItems[index].character == Character.me
                            ? ChatBubbleStyle.me
                            : ChatBubbleStyle.somebody,
                        // child: Text(provider.testData[index]),
                        child: Text(chatItems[index].text),
                      ),
                    );
                  },
                ),
                onNotification: provider.reachTheTopOfListLisnter(),
              );
            },
          );
        },
      ),
    );
  }
}
