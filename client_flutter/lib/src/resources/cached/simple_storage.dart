import 'package:client_flutter/src/resources/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [SimpleSorage] is a simple key-value storage dedicating to save the unsensitive
/// data on client.
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

  bool getBool(String target) {
    if (!_boolProperTarget(target)) {
      return false;
    }

    bool value = false;

    try {
      value = _prefs.getBool(target);
    } catch (e) {
      print('It\'s the first time to get $target : $e');
    }

    print(value);
    return value;
  }

  Future<bool> setBool(String target, bool value) async {
    if (!_boolProperTarget(target)) {
      return false;
    }
    return await _prefs.setBool(target, value);
  }

  String getString(String target) {
    String value;

    try {
      value = _prefs.getString(target);
    } catch (e) {
      print('It\'s the first time to get $target : $e');
    }

    print(value);
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
