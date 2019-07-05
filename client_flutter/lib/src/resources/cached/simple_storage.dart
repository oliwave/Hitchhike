import 'package:shared_preferences/shared_preferences.dart';

/// Create a simple key-value storage on client
class SimpleStorage {
  SimpleStorage._() {
    init();
  }

  SharedPreferences _prefs;

  static final _simpleStoage = SimpleStorage._();

  factory SimpleStorage() {
    return _simpleStoage;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool getIsMatched() {
    return _prefs.getBool('isMatched') ?? false;
  }

  bool getIsDriver() {
    return _prefs.getBool('isDriver') ?? false;
  }

  Future<bool> setIsMatched(bool isMatched) {
    return _prefs.setBool('isMatched', isMatched);
  }

  Future<bool> setIsDriver(bool isDriver) {
    return _prefs.setBool('isDriver', isDriver);
  }
}
