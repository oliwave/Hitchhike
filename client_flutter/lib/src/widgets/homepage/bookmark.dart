import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart'
    show HomepageProvider, FavoriteRoutesProvider, BulletinProvider;
import '../../model/favorite_route_item.dart';

/// TODO: The icon of bookmark must change to border one when
/// client choose other location, so extract the business logic
/// to provider.
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
    final orderInfo = Provider.of<HomepageProvider>(
      context,
      listen: false,
    ).orderManager.orderInfo;

    final routeProvider = Provider.of<FavoriteRoutesProvider>(
      context,
      listen: false,
    );
    final bulletinProvider = Provider.of<BulletinProvider>(
      context,
      listen: false,
    );

    setState(() {
      if (orderInfo.geoStart != null &&
          orderInfo.geoEnd != null &&
          orderInfo.nameStart != null &&
          orderInfo.nameEnd != null &&
          orderInfo.addressStart != null &&
          orderInfo.addressEnd != null) {
        star = star == Icons.star ? Icons.star_border : Icons.star;

        routeProvider.addRoute(
          targetRoute: FavoriteRouteItem.fromInstance(
            order: orderInfo,
          ),
        );
      } else {
        bulletinProvider.showBulletin('請先設定好路線！');
      }
    });
  }
}
