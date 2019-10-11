import 'package:flutter/material.dart';

import 'package:connectivity/connectivity.dart';

import '../../resources/repository.dart';
import '../../provider/provider_collection.dart'
    show BulletinProvider, CloudMessageProvider;

class ConnectivityProvider with ChangeNotifier {
  ConnectivityProvider._();

  factory ConnectivityProvider() {
    return _connectivityProvider;
  }

  static final _connectivityProvider = ConnectivityProvider._();
  final _bulletin = BulletinProvider();
  final _fcmHandler = Repository.getCloudMessageHandler;
  final _socketHandler = Repository.getSocketHandler;
  final _fcmProvider = CloudMessageProvider();

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

  void networkConnection() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print(
          'Connectivity has been triggered and the network status is $result');
      _connectivityProvider.networkStatus = result != ConnectivityResult.none;

      if (_connectivityProvider.networkStatus) {
        _socketHandler.connectSocketServer();

        if (!_fcmProvider.fcmTokenManager.hasSentFcmToken) {
          _fcmHandler.messageConfiguration();
          _fcmProvider.fcmTokenManager.initSendFcmToken();
        }
      } else {
        _socketHandler.disconnetSocket();
      }
    });
  }
}
