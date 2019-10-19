import 'package:flutter/material.dart';

import '../notify_manager.dart';
import '../../resources/repository.dart';
import '../../resources/restful/request_method.dart' show FcmTokenRequest;

class FcmTokenManager extends NotifyManager {
  FcmTokenManager(VoidCallback notifyListeners) : super(notifyListeners);

  final _prefs = Repository.getSimpleStorage;
  final _api = Repository.getApi;
  final _fcm = Repository.getCloudMessageHandler;

  bool _hasSentFcmToken = false;

  String _fcmToken;

  bool get hasSentFcmToken => _hasSentFcmToken;

  Future<void> initSendFcmToken() async {
    // Get the boolean of hasSentFcmToken.
    _hasSentFcmToken = _prefs.getBool(TargetSourceString.hasSentFcmToken);

    // Didn't send fcm token before.
    if (!_hasSentFcmToken) {
      // Fetch Fcm token from Google api or local storage.
      _fcmToken = await _fcm.firebaseMessaging.getToken();

      print('fcmToken is $_fcmToken');

      _sendFcmToken();
    } else {
      return print('hasSentFcmToken has been initialized!');
    }
  }

  Future<void> _sendFcmToken() async {
    print(
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhas'
        'FcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken'
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken'
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken'
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken'
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken'
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken is $hasSentFcmToken');

    // Send fcm token to the server if hasSentFcmToken is false.
    final response = await _api.sendHttpRequest(
      FcmTokenRequest(
        fcmToken: _fcmToken,
        jwtToken: '',
      ),
    );

    print(
        'fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response '
        'fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response '
        'fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response '
        'fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response '
        'fcm response : ${response['statusCode']}');

    // Record the runtime _hasSentFcmToken.
    _hasSentFcmToken = response['statusCode'] == 200;

    /// Write the data to simple storage.
    await _prefs.setBool(
      TargetSourceString.hasSentFcmToken,
      hasSentFcmToken,
    );

    print('hasFcmToken is set with $hasSentFcmToken');
  }
}
