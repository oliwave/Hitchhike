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
  bool isMatched;
  bool hasRevokedDriverPosition;
  String role;
  double driverLat;
  double driverLng;
  List<String> routeLatitude;
  List<String> routeLongitude;

  bool _isFirst = true;

  /// This method should only be triggered one time.
  void init() {
    if (_isFirst) {
      _prefs = Repository.getSimpleStorage;
      isMatched = _prefs.getBool(TargetSourceString.isMatched);
      hasRevokedDriverPosition =
          _prefs.getBool(TargetSourceString.hasRevokedDriverPosition);
      role = _prefs.getString(TargetSourceString.role);
      driverLat = _prefs.getDouble(TargetSourceString.driverLat);
      driverLng = _prefs.getDouble(TargetSourceString.driverLng);
      routeLatitude = _prefs.getStringList(TargetSourceString.routeLatitude);
      routeLongitude = _prefs.getStringList(TargetSourceString.routeLongitude);
      _isFirst = false;
      return;
    }
  }

  @override
  void dispose() {
    // Save the state in case the client turns off the app
    if (isMatched) {
      _prefs.setString(TargetSourceString.role, role);
      _prefs.setBool(TargetSourceString.isMatched, isMatched);
      _prefs.setBool(TargetSourceString.hasRevokedDriverPosition,
          hasRevokedDriverPosition);
      _prefs.setDouble(TargetSourceString.driverLat, driverLat);
      _prefs.setDouble(TargetSourceString.driverLng, driverLng);
      _prefs.setStringList(TargetSourceString.routeLatitude, routeLatitude);
      _prefs.setStringList(TargetSourceString.routeLongitude, routeLongitude);
    } else {
      _prefs.setString(TargetSourceString.role, null);
      _prefs.setBool(TargetSourceString.isMatched, false);
      _prefs.setBool(TargetSourceString.hasRevokedDriverPosition, false);
      _prefs.setDouble(TargetSourceString.driverLat, null);
      _prefs.setDouble(TargetSourceString.driverLng, null);
      _prefs.setStringList(TargetSourceString.routeLatitude, null);
      _prefs.setStringList(TargetSourceString.routeLongitude, null);
    }
    super.dispose();
  }
}
