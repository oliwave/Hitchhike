import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart';

class Bookmark extends StatefulWidget {
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  IconData star = Icons.star_border;

  @override
  Widget build(BuildContext context) {
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
          _changeIcon(context);
        },
      ),
    );
  }

  void _changeIcon(BuildContext context) {
    final orderInfo =
        Provider.of<HomepageProvider>(context, listen: false).orderInfo;

    setState(() {
      if (orderInfo.geoEnd != null && orderInfo.geoStart != null) {
        star = star == Icons.star ? Icons.star_border : Icons.star;
      } else {
        Provider.of<BulletinProvider>(
          context,
          listen: false,
        ).showBulletin('請先設定好路線！');
      }
    });
  }
}
