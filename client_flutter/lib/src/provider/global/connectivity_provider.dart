import 'package:flutter/material.dart';

import '../../provider/provider_collection.dart' show BulletinProvider;

class ConnectivityProvider with ChangeNotifier {
  ConnectivityProvider._();

  factory ConnectivityProvider() {
    return _connectivityProvider;
  }

  static final _connectivityProvider = ConnectivityProvider._();
  final _bulletin = BulletinProvider();

  bool networkStatus;

  bool checkNetworkStatus() {
    if (!networkStatus) {
      _bulletin.showBulletin(
        text: '請先連網再重新嘗試喔！',
        textColor: Colors.red[300],
        iconColor: Colors.red[300],
      );
      return false;
    }
    return true;
  }
}
