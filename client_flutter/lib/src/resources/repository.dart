import './source_collection.dart';

/// Gather all of the request of resources to the [Repository].
///
/// The repository contains resources from different sources,
/// such as [api], [prefs], [jwtStorage] and [] created by the singleton pattern.
/// That is, repository holds the reference from every source.
///
/// In dart, the singleton pattern can be implemented by prefixing the constructor
/// with the syntax sugar, "factory". It provides a mechanism for object caching, so
/// you won't get the different object when you instantiate it. Instead,
/// you get the same object no matter whenever and wherever you access it.
/// [https://dart.dev/guides/language/language-tour#constructors]
class Repository {

  Repository._();

  /// Get access to the internet resource.
  static Api get getApi => Api();

  /// Get access to the local storage.
  static SimpleStorage get getPrefs => SimpleStorage();

  /// Get access to the jwt storage.
  static SecureStorage get getSecureStorage => SecureStorage();

}
