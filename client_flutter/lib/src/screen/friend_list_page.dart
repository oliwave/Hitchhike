import 'package:flutter/material.dart';

import '../widgets/general_app_bar.dart';

class FriendListPage extends StatelessWidget {
  static const String routeName = "/friend_list_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
