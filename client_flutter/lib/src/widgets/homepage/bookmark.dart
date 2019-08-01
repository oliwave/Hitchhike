import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart';
import '../../model/order_info.dart';

class Bookmark extends StatefulWidget {
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  IconData star = Icons.star_border;
  // Color color = Colors.yellow[900];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomepageProvider>(
      context,
      listen: false,
    );

    return Container(
      child: GestureDetector(
        child: Tooltip(
          child: Icon(
            star,
            color: Colors.amber,
          ),
          message: '儲存路線',
          showDuration: Duration(milliseconds: 500),
        ),
        onTap: () {
          _changeIcon();
        },
      ),
    );
  }

  void _changeIcon() {
    final orderInfo = OrderInfo();

    setState(() {
      // if (orderInfo.geoEnd != null && orderInfo.geoStart != null) {
      star = star == Icons.star ? Icons.star_border : Icons.star;
      // color = color == Colors.black ? Colors.yellow : Colors.black;
      // } else {
      // star =
      // }
    });
    // else {
    //   scaffold.showSnackBar(
    //     SnackBar(
    //       content: Text('請先設定好起訖點！'),
    //     ),
    //   );
    // }
  }
}
