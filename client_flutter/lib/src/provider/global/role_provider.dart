import 'package:flutter/material.dart';

import '../../resources/repository.dart';
import '../../resources/source_collection.dart';

/// Recording the current client information
///
/// The [isMatched] is used to judge whether the client is in the matched mode. And
/// if the client is in the matched mode, the [isDriver] can determine what role the
/// client is.
class RoleProvider with ChangeNotifier {
  RoleProvider._();

  factory RoleProvider() {
    return _roleProvider;
  }

  static final _roleProvider = RoleProvider._();

  SimpleStorage _prefs;
  bool _isMatched;
  String _role;
  List<String> _routeLatitude;
  List<String> _routeLongitude;

  bool _isFirst = true;

  bool get isMatched => _isMatched;
  String get role => _role;

  /// This method should only be triggered one time.
  void init() {
    if (_isFirst) {
      _prefs = Repository.getSimpleStorage;
      _isMatched = _prefs.getBool(TargetSourceString.isMatched);
      _role = _prefs.getString(TargetSourceString.role);
      _routeLatitude = _prefs.getStringList(TargetSourceString.routeLatitude);
      _routeLongitude = _prefs.getStringList(TargetSourceString.routeLongitude);
      _isFirst = false;
      return;
    }
  }

  set isMatched(bool isMatched) {
    _isMatched = isMatched;
  }

  set role(String role) {
    _role = role;
  }

  @override
  void dispose() {
    // Save the state in case the client turns off the app
    if (_isMatched) {
      _prefs.setString(TargetSourceString.role, _role);
      _prefs.setBool(TargetSourceString.isMatched, _isMatched);
      _prefs.setStringList(TargetSourceString.routeLatitude, _routeLatitude);
      _prefs.setStringList(TargetSourceString.routeLongitude, _routeLongitude);
    } else {
      _prefs.setString(TargetSourceString.role, null);
      _prefs.setBool(TargetSourceString.isMatched, false);
      _prefs.setStringList(TargetSourceString.routeLatitude, null);
      _prefs.setStringList(TargetSourceString.routeLongitude, null);
    }
    super.dispose();
  }
}
