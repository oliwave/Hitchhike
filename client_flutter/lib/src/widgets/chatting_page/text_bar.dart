import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart' show ChattingProvider;

class TextBar extends StatelessWidget {
  const TextBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChattingProvider>(
      context,
      listen: false,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(1, 0), // Only set the box shadow at the bottom
          ),
        ],
      ),
      child: IconTheme(
        data: IconThemeData(color: Colors.blue),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  decoration: InputDecoration.collapsed(
                    hintText: "訊息ing ~",
                  ),
                  controller: chatProvider.chatTextController,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmit(
                    chatProvider.chatTextController.text,
                    chatProvider,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit(
    String value,
    ChattingProvider chatProvider,
  ) {
    chatProvider.newText = value;
  }
}
