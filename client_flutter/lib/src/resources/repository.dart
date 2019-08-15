import 'package:client_flutter/src/resources/fcm/cloud_message_handler.dart';

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
/// See https://dart.dev/guides/language/language-tour#constructors
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
}

/// The target string is specified which local resource that client wants to access.
class TargetSourceString {
  TargetSourceString._();

  static const String isMatched = 'isMatched';
  static const String hasMultipleLaunched = 'hasMultipleLaunched';
  static const String role = 'role';
  static const String jwt = 'jwt';
  static const String pwd = 'pwd';
}
