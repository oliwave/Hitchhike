import 'package:client_flutter/src/provider/provider_collection.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/provider_collection.dart' show CloudMessageProvider;
import '../widgets/general_app_bar.dart';
import '../widgets/chatting_page/text_bar.dart';
import '../widgets/chatting_page/chat_list_view.dart';

class ChattingPage extends StatelessWidget {
  static const String routeName = '/chatting_page';

  @override
  Widget build(BuildContext context) {
    Provider.of<CloudMessageProvider>(
      context,
      listen: false,
    ).context = context;

    final chatProvider = Provider.of<ChattingProvider>(context, listen: false);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 2,
          backgroundColor: Colors.white,
          title: GeneralAppBar(
            title: '聊天室',
            heroTag: 'chat',
            icon: Icons.chat_bubble_outline,
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ChatListView(),
            ),
            TextBar(),
          ],
        ),
      ),
      onWillPop: () async {
        chatProvider.chatRecordManager.releaseCacheData();
        return true;
      },
    );
  }
}
