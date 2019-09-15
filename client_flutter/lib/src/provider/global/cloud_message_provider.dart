import 'dart:async';

import 'package:flutter/material.dart';

import '../../resources/repository.dart';
import '../../logics/fcm/fcm_action_manager.dart';
import '../../logics/fcm/fcm_token_manager.dart';

class CloudMessageProvider with ChangeNotifier {
  CloudMessageProvider._() {
    _managerInit();
    _subscribeFcmEvent();
  }

  factory CloudMessageProvider() {
    return _cloudMessageProvider;
  }

  static final _cloudMessageProvider = CloudMessageProvider._();
  static final _fcm = Repository.getCloudMessageHandler;

  StreamSubscription _fcmEventSubscription;
  BuildContext _context;
  FcmActionManager _fcmActionManager;
  FcmTokenManager _fcmTokenManager;

  FcmActionManager get fcmActionManager => _fcmActionManager;
  FcmTokenManager get fcmTokenManager => _fcmTokenManager;

  set context(BuildContext context) => _context = context;

  void _subscribeFcmEvent() {
    _fcmEventSubscription = _fcm.fcmEvent.listen(
      (Map<String, dynamic> message) {
        print('Emit an fcm event!');
        if (_context != null)
          _fcmActionManager.messageConsumer(message, _context);
      },
    );
  }

  @override
  void dispose() {
    _fcmEventSubscription.cancel();
    super.dispose();
  }

  void _managerInit() {
    _fcmActionManager = FcmActionManager(_registerNotifyListeners);
    _fcmTokenManager = FcmTokenManager(_registerNotifyListeners);
  }

  void _registerNotifyListeners() {
    notifyListeners();
  }
}
