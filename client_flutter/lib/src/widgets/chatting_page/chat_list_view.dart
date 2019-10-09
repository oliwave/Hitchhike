import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:bubble/bubble.dart';

import '../../provider/provider_collection.dart' show ChattingProvider;
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
          return ListView.builder(
            reverse: true,
            itemCount: provider.data.length,
            controller: provider.listController,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Bubble(
                  nip: BubbleNip.no,
                  style: index % 2 == 0
                      ? ChatBubbleStyle.me
                      : ChatBubbleStyle.somebody,
                  child: Text(provider.data[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
