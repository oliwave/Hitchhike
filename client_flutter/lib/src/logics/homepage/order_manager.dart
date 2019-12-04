import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/restful/request_method.dart';
import '../../resources/repository.dart';
import '../../model/order_info.dart';

import '../notify_manager.dart';
import '../../provider/provider_collection.dart'
    show
        RoleProvider,
        BulletinProvider,
        CloudMessageProvider,
        HomepageProvider,
        AuthProvider;
import '../../widgets/customized_alert_dialog.dart';

/// [OrderManager] handle the major process of sending order and relative tasks.
class OrderManager extends NotifyManager {
  OrderManager({
    @required VoidCallback notifyListeners,
    @required HomepageProvider homepageProvider,
  })  : _homepageProvider = homepageProvider,
        super(notifyListeners);

  static final _api = Repository.getApi;

  final OrderInfo _orderInfo = OrderInfo();
  final HomepageProvider _homepageProvider;

  /// The object that records some geo-relative information that will be
  /// used in final order request.
  OrderInfo get orderInfo => _orderInfo;

  Future<void> sendOrder(BuildContext context, String buttonName) async {
    final roleProvider = Provider.of<RoleProvider>(
      context,
      listen: false,
    );
    final bulletinProvider = Provider.of<BulletinProvider>(
      context,
      listen: false,
    );
    final fcmProvider = Provider.of<CloudMessageProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    if (buttonName != '建立訂單') {
      roleProvider.role = null;
    } else {
      if (roleProvider.isMatched) {
        bulletinProvider.showBulletin(text: '行程中無法新增訂單！');
        return;
      }

      if (roleProvider.hasSentTravel) {
        bulletinProvider.showBulletin(text: '您的行程已送出了！請等待吧～');
        return;
      }

      if (hasCompleteOrderInfo()) {
        final result = await customizedAlertDialog(
          context: _homepageProvider.bottomSheetContext,
          content: Text('確認送出訂單？'),
          title: Text('訂單確認'),
          confirmButtonName: '送出訂單',
          confirmCallback: () =>
              Navigator.pop(_homepageProvider.bottomSheetContext, true),
          cancelButtonName: '再想想～',
          cancelCallback: () =>
              Navigator.pop(_homepageProvider.bottomSheetContext, false),
        );

        if (result) {
          // The fcm token must be sent to server before sending an order.
          if (!fcmProvider.fcmTokenManager.hasSentFcmToken)
            await fcmProvider.fcmTokenManager.initSendFcmToken();

          _orderRequest(
            roleProvider,
            bulletinProvider,
            authProvider.jwt,
          );
          print(authProvider.jwt);
        }
      } else {
        bulletinProvider.showBulletin(text: '還沒設定路線喔！');
      }
    }
  }

  Future<void> _orderRequest(
    RoleProvider roleProivder,
    BulletinProvider bulletinProvider,
    String jwt,
  ) async {
    final response = await _api.sendHttpRequest(
      roleProivder.role == '司機'
          ? DriverRouteRequest(
              orderInfo: orderInfo,
              jwtToken: jwt,
            )
          : PassengerRouteRequest(
              orderInfo: orderInfo,
              jwtToken: jwt,
            ),
    );

    if (response['statusCode'] != 200) {
      bulletinProvider.showBulletin(
        text: '伺服器無回應，請稍後重新嘗試！',
        textColor: Colors.red[400],
        iconColor: Colors.red[400],
      );
    } else {
      bulletinProvider.showBulletin(
        text: '您的行程已成功送出!尋找附近的${roleProivder.role}...',
      );

      roleProivder.hasSentTravel = true;
    }
  }

  bool hasCompleteOrderInfo() {
    return orderInfo.geoStart != null &&
        orderInfo.geoEnd != null &&
        orderInfo.nameStart != null &&
        orderInfo.nameEnd != null &&
        orderInfo.addressStart != null &&
        orderInfo.addressEnd != null;
  }
}
