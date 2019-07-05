import './restful/api.dart';
import './cached/simple_storage.dart';

/// Gather all of the request of resources to the [Repository].
///
/// The repository contains resources from different sources,
/// such as [_api] and [_prefs] created by the singleton pattern.
///
/// In dart, the singleton pattern can be implemented by prefixing the constructor 
/// with the syntax sugar, "factory". It provides a mechanism for object caching, so 
/// you won't get the different object when you instantiate it. Instead,
/// you get the same object no matter whenever and wherever you access it. 
/// [https://dart.dev/guides/language/language-tour#constructors]
class Repository {
  Repository._();

  /// Get access to the internet resource.
  final _api = Api();

  /// Get acces to the local storage.
  final _prefs = SimpleStorage();

  static final _repository = Repository._();

  /// factory constructor
  factory Repository() {
    return _repository;
  }

  /// From Api
  Future<String> verifyUserId(String userId) async {
    return await _api.verifyUserId(userId);
  }

  Future<int> signUp(String userId, String password, String username) async {
    return await _api.signUp(userId, password, username);
  }

  Future<int> login(String userId, String password) async {
    return await _api.login(userId, password);
  }

  /// From Cached SimpleStorage
  bool getIsMatched() {
    return _prefs.getIsMatched();
  }

  bool getIsDriver() {
    return _prefs.getIsDriver();
  }

  Future<bool> setIsMatched(bool isMatched) {
    return _prefs.setIsMatched(isMatched);
  }

  Future<bool> setIsDriver(bool isDriver) {
    return _prefs.setIsDriver(isDriver);
  }
}
