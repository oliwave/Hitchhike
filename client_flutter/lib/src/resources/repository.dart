import 'package:flutter/widgets.dart';

import './source_collection.dart';

/// Gather all of the request of resources to the [Repository].
///
/// The repository contains resources from different sources,
/// such as [api], [prefs], [SecureStorage] and [] created by the singleton pattern.
/// That is, repository holds the reference from every source.
///
/// In dart, the singleton pattern can be implemented by prefixing the constructor
/// with the syntax sugar, "factory". It provides a mechanism for object caching, so
/// you won't get the different object when you instantiate it. Instead,
/// you get the same object no matter whenever and wherever you access it.
///
/// * See https://dart.dev/guides/language/language-tour#constructors
class Repository {
  Repository._();

  /// Get access to the internet resource.
  static Api get getApi => Api();

  /// Get access to the local storage.
  static SimpleStorage get getSimpleStorage => SimpleStorage();

  /// Get access to the jwt storage.
  static SecureStorage get getSecureStorage => SecureStorage();

  /// Get access to the socket
  static SocketHandler get getSocketHandler => SocketHandler();

  /// Get access to the Firebase Cloud Messaging
  static CloudMessageHandler get getCloudMessageHandler =>
      CloudMessageHandler();

  static DatabaseHandler get getDatabaseHandler => DatabaseHandler();

  static JsonFileHandler get getJsonFileHandler => JsonFileHandler();
}

/// The target string is specified which local resource that client wants to access.
class TargetSourceString {
  TargetSourceString._();

  static const String isMatched = 'isMatched';
  static const String hasRevokedDriverPosition = 'hasRevokedDriverPosition';
  static const String hasSentFcmToken = 'hasSentFcmToken';
  static const String role = 'role';
  static const String jwt = 'jwt';
  static const String pwd = 'pwd';
  static const String photo = 'photo';
  static const String uid = 'uid';
  static const String name = 'name';
  static const String gender = 'gender';
  static const String birthday = 'birthday';
  static const String carNum = 'carNum';
  static const String department = 'department';
  static const String driverLat = 'driverLat';
  static const String driverLng = 'driverLng';
  static const String routeLatitude = 'routeLatitude';
  static const String routeLongitude = 'routeLongitude';
  static const String lastLoginTime = 'lastLoginTime';
}

class Character {
  Character._();

  static const String me = 'me';
  static const String otherSide = 'otherSide';
  static const String passengerStart = 'passengerStart';
  static const String passengerEnd = 'passengerEnd';
  static const String route = 'route';
}

class SocketEventName {
  SocketEventName._();

  static const String revokeDriverPosition = 'revokeDriverPosition';
  static const String driverPosition = 'driverPosition';
  static const String previousMessages = 'previousMessages';
  static const String newMessage = 'newMessage';
  static const String sendMessage = 'sendMessage';
}

class FcmEventType {
  FcmEventType._();

  static const String orderConfirmation = 'orderConfirmation';
  static const String paired = 'paired';
}

class FileName {
  FileName._();

  static const String pairedData = 'pairedData.json';
}
