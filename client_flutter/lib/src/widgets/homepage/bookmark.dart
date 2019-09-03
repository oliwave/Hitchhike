import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart'
    show HomepageProvider, FavoriteRoutesProvider, BulletinProvider;
import '../../model/favorite_route_item.dart';

class Bookmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Tooltip(
          child: const Icon(
            Icons.star_border,
            color: Colors.amber,
          ),
          message: '儲存路線',
          showDuration: Duration(milliseconds: 500),
        ),
        onTap: () {
          _addRoute(context);
        },
      ),
    );
  }

  void _addRoute(BuildContext context) {
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

    if (orderInfo.geoStart != null &&
        orderInfo.geoEnd != null &&
        orderInfo.nameStart != null &&
        orderInfo.nameEnd != null &&
        orderInfo.addressStart != null &&
        orderInfo.addressEnd != null) {
      if (routeProvider.routesListLength < 5) {
        final success = routeProvider.addRoute(
          targetRoute: FavoriteRouteItem.fromInstance(
            order: orderInfo,
          ),
        );
        bulletinProvider.showBulletin(success ? '成功儲存路線！' : '重複路線！');
      } else {
        bulletinProvider.showBulletin('最多紀錄 5 條路線！');
      }
    } else {
      bulletinProvider.showBulletin('請先設定好路線！');
    }
  }
}
