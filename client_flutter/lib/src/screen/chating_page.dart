import 'package:client_flutter/src/widgets/general_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/provider_collection.dart' show CloudMessageProvider;

class ChatingPage extends StatelessWidget {
  static const String routeName = '/chating_page';

  @override
  Widget build(BuildContext context) {
    Provider.of<CloudMessageProvider>(
      context,
      listen: false,
    ).context = context;

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Text('雞掰～～'),
    );
  }
}
