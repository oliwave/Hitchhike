import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessageHandler {
  CloudMessageHandler._();

  factory CloudMessageHandler() {
    return _cloudMessageHandler;
  }

  static final _cloudMessageHandler = CloudMessageHandler._();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String _fcmToken;

  String get fcmToken => _fcmToken;

  final _fcmEventController = StreamController<Map<String, dynamic>>();

  set _fcmEvent(Map<String, dynamic> fcmEvent) {
    _fcmEventController.sink.add(fcmEvent);
    print('Add a fcm event to Sink!');
  }

  Stream<Map<String, dynamic>> get fcmEvent => _fcmEventController.stream;

  Future<void> init() async {
    if (_fcmToken != null) {
      print(
          'CloudMessageHandler had been initialized since the app was launched!');
      return;
    }
    _fcmToken = await _firebaseMessaging.getToken();

    _messageConfiguration();

    print(
        'CloudMessageHandler has been resolved !!! and fcm token is : $_fcmToken');
  }

  Future<String> refreshMessagingToken() async {
    return _fcmToken = await _firebaseMessaging.getToken();
  }

  void _messageConfiguration() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _fcmEvent = message;
        print('Message received in onMessage : $message');
      },
      onResume: (Map<String, dynamic> message) async {
        _fcmEvent = message;
        print('Message received onResume : $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        _fcmEvent = message;
        print('Message received onLaunch : $message');
      },
    );
  }

  void iOSPermissionRequest() {
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  dispose() {
    _fcmEventController.close();
  }
}
