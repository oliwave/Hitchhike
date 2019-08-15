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

  Future<void> init() async {
    if (_fcmToken != null) {
      print(
          'CloudMessageHandler had been initialized since the app was launched!');
    }
    _fcmToken = await _firebaseMessaging.getToken();
    print('CloudMessageHandler has been resolved !!!');
  }

  Future<String> refreshMessagingToken() async {
    return _fcmToken = await _firebaseMessaging.getToken();
  }
}
