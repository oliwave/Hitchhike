import './restful/api.dart';
import './cached/simple_storage.dart';

/// Gather all of the request of resources to the [Repository]
class Repository {
  Repository._();

  final api = Api.getInstance();
  final prefs = sharedPrefences;

  static final _repository = Repository._();

  static Repository getInstance() {
    return _repository;
  }

  /// From Api
  Future<String> verifyUserId(String userId) async {
    return await api.verifyUserId(userId);
  }

  Future<int> signUp(String userId, String password, String username) async {
    return await api.signUp(userId, password, username);
  }

  Future<int> login(String userId, String password) async {
    return await api.login(userId, password);
  }

  /// From Cached SimpleStorage
  bool getIsMatched() {
    return prefs.getIsMatched();
  }

  bool getIsDriver() {
    return prefs.getIsDriver();
  }

  Future<bool> setIsMatched(bool isMatched) {
    return prefs.setIsMatched(isMatched);
  }

  Future<bool> setIsDriver(bool isDriver) {
    return prefs.setIsDriver(isDriver);
  }
}
