import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../screen/page_collection.dart' show ChatingPage;
import '../../provider/provider_collection.dart' show ChatingProvider;

class ChatingFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatinProvider = Provider.of<ChatingProvider>(context);

    return Visibility(
      visible: chatinProvider.isVisible,
      child: Hero(
        tag: 'chat',
        child: Material(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Colors.grey,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.chat,
                color: Colors.black54,
              ),
              onPressed: () => Navigator.pushNamed(
                context,
                ChatingPage.routeName,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
