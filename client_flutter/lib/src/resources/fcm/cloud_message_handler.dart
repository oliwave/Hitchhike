import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessageHandler {
  CloudMessageHandler._();

  factory CloudMessageHandler() {
    return _cloudMessageHandler;
  }

  static final _cloudMessageHandler = CloudMessageHandler._();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  static final _fcmEventController = StreamController<Map<String, dynamic>>();

  static set _fcmEvent(Map<String, dynamic> fcmEvent) {
    _fcmEventController.sink.add(fcmEvent);
    print('Add a fcm event to Sink!');
  }

  Stream<Map<String, dynamic>> get fcmEvent => _fcmEventController.stream;

  // Future<String> refreshMessagingToken() async {
  //   return _fcmToken = await firebaseMessaging.getToken();
  // }

  void messageConfiguration() {
    firebaseMessaging.configure(
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
      onBackgroundMessage: _backgroundMessage,
    );
  }

  void iOSPermissionRequest() {
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  dispose() {
    _fcmEventController.close();
  }

  static Future<void> _backgroundMessage(Map<String, dynamic> message) {
    _fcmEvent = message;
  }
}
