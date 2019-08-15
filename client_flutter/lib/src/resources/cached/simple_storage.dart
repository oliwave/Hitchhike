import 'package:client_flutter/src/resources/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [SimpleSorage] is a simple key-value storage dedicating to save the unsensitive
/// data on client.
class SimpleStorage {
  SimpleStorage._();

  static SharedPreferences _prefs;

  static final _simpleStoage = SimpleStorage._();

  factory SimpleStorage() {
    return _simpleStoage;
  }

  Future<void> init() async {
    if (_prefs != null) {
      print('SimpleStorage had been initialized since the app was launched!');
    }
    _prefs = await SharedPreferences.getInstance();
    print('SharedPreferences has been resolved !!!');
  }

  bool getBool(String target) {
    if (!_boolProperTarget(target)) {
      return false;
    }

    bool value = _prefs.getBool(target);

    if (value == null) value = false;

    // print('The value of getBool is $value');
    return value;
  }

  Future<bool> setBool(String target, bool value) async {
    if (!_boolProperTarget(target)) {
      return false;
    }
    return await _prefs.setBool(target, value);
  }

  String getString(String target) {
    String value = _prefs.getString(target);

    // print('The value of getString is $value');
    return value;
  }

  Future<bool> setString(String target, String value) {
    return _prefs.setString(target, value);
  }

  bool _boolProperTarget(String target) {
    if (target == TargetSourceString.jwt ||
        target == TargetSourceString.pwd ||
        target == 'password' ||
        target.isEmpty) {
      return false;
    }
    return true;
  }
}
