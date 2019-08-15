import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart';
import '../../resources/restful/request_method.dart';
import '../../resources/repository.dart';
import '../../model/order_info.dart';

import '../notify_manager.dart';

/// [OrderManager] handle the major process of sending order and relative tasks.
class OrderManager extends NotifyManager {
  OrderManager(notifyListeners) : super(notifyListeners);

  static final _api = Repository.getApi;

  final OrderInfo _orderInfo = OrderInfo();

  /// The object that records some geo-relative information that will be
  /// used in final order request.
  OrderInfo get orderInfo => _orderInfo;

  void sendOrder(BuildContext context, String buttonName) {
    final roleProvider = Provider.of<RoleProvider>(
      context,
      listen: false,
    );

    if (buttonName != '送出訂單') {
      roleProvider.role = null;
    } else {
      roleProvider.isMatched = true;
      if (_hasCompleteOrderInfo()) {
        _orderRequest(roleProvider.role);
      } else {
        Provider.of<BulletinProvider>(
          context,
          listen: false,
        ).showBulletin('還沒設定路線喔！');
      }
    }
  }

  void _orderRequest(String role) {
    if (role == '司機') {
      _api.sendHttpRequest(DriverRouteRequest(
        originX: orderInfo.geoStart.lng,
        originY: orderInfo.geoStart.lat,
        destinationX: orderInfo.geoEnd.lng,
        destinationY: orderInfo.geoEnd.lat,
        jwtToken: '',
      ));
    } else {
      _api.sendHttpRequest(PassengerRouteRequest(
        originX: orderInfo.geoStart.lng,
        originY: orderInfo.geoStart.lat,
        destinationX: orderInfo.geoEnd.lng,
        destinationY: orderInfo.geoEnd.lat,
        jwtToken: '',
      ));
    }
  }

  bool _hasCompleteOrderInfo() {
    return orderInfo.geoEnd != null && orderInfo.geoStart != null;
  }
}
