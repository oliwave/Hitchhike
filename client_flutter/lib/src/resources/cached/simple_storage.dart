import 'package:shared_preferences/shared_preferences.dart';

/// Global access the [sharedPrefences] when import this file.
final sharedPrefences = SimpleStorage._();

/// Create a simple key-value storage on client
class SimpleStorage {
  SimpleStorage._() {
    init();
  }

  SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool getIsMatched() {
    return prefs.getBool('isMatched') ?? false;
  }

  bool getIsDriver() {
    return prefs.getBool('isDriver') ?? false;
  }

  Future<bool> setIsMatched(bool isMatched) {
    return prefs.setBool('isMatched', isMatched);
  }

  Future<bool> setIsDriver(bool isDriver) {
    return prefs.setBool('isDriver', isDriver);
  }

}
