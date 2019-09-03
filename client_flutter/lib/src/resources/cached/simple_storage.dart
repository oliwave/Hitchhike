import 'package:shared_preferences/shared_preferences.dart';

import '../../resources/repository.dart';
import '../../provider/provider_collection.dart' show RoleProvider;

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

    // After '_prefs' has been initialized, we call init() method in RoleProvider.
    RoleProvider().init();
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

  double getDouble(String target) {
    double value = _prefs.getDouble(target);

    return value;
  }

  Future<bool> setDouble(String target, double value) async {
    if (!_boolProperTarget(target)) {
      return false;
    }
    return await _prefs.setDouble(target, value);
  }

  String getString(String target) {
    String value = _prefs.getString(target);

    // print('The value of getString is $value');
    return value;
  }

  Future<bool> setString(String target, String value) async {
    if (!_boolProperTarget(target)) {
      return false;
    }
    return await _prefs.setString(target, value);
  }

  List<String> getStringList(String target) {
    List<String> value = _prefs.getStringList(target);

    return value;
  }

  Future<bool> setStringList(String target, List<String> value) async {
    if (!_boolProperTarget(target)) {
      return false;
    }
    return await _prefs.setStringList(target, value);
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
