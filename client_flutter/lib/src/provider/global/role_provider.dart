import 'package:flutter/material.dart';

import '../../resources/repository.dart';
import '../../resources/source_collection.dart';
import '../../provider/provider_collection.dart' show ChattingProvider;

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

  static final _chatingProvider = ChattingProvider();

  SimpleStorage _prefs;
  // List<String> routeLatitude;
  // List<String> routeLongitude;

  bool _isMatched;
  DateTime _endTimeOfTrip;
  bool _hasRevokedDriverPosition;
  String _role;
  double _driverLat;
  double _driverLng;
  bool _hasSentTravel = false;
  String _newTravelRoom;

  bool _isFirst = true;

  bool get isMatched => _isMatched;

  DateTime get endTimeOfTrip => _endTimeOfTrip;

  bool get hasRevokedDriverPosition => _hasRevokedDriverPosition;

  String get role => _role;

  double get driverLat => _driverLat;

  double get driverLng => _driverLng;

  bool get hasSentTravel => _hasSentTravel;

  String get newTravelRoom => _newTravelRoom;

  set isMatched(bool isMatched) {
    _isMatched = isMatched;
    _chatingProvider.isVisible = _isMatched;

    _prefs.setBool(TargetSourceString.isMatched, _isMatched);
  }

  set endTimeOfTrip(DateTime endTimeOfTrip) {
    _endTimeOfTrip = endTimeOfTrip;

    _prefs.setInt(TargetSourceString.endTimeOfTrip,
        _endTimeOfTrip.millisecondsSinceEpoch);
  }

  set hasRevokedDriverPosition(bool hasRevokedDriverPosition) {
    _hasRevokedDriverPosition = hasRevokedDriverPosition;
    _prefs.setBool(
        TargetSourceString.hasRevokedDriverPosition, _hasRevokedDriverPosition);
  }

  set role(String role) {
    _role = role;
    _prefs.setString(TargetSourceString.role, _role);
  }

  set driverLat(double driverLat) {
    _driverLat = driverLat;
    _prefs.setDouble(TargetSourceString.driverLat, _driverLat);
  }

  set driverLng(double driverLng) {
    _driverLng = driverLng;
    _prefs.setDouble(TargetSourceString.driverLng, _driverLng);
  }

  set hasSentTravel(bool hasSentTravel) {
    _hasSentTravel = hasSentTravel;
    _prefs.setBool(TargetSourceString.hasSentTravel, _hasSentTravel);
  }

  set newTravelRoom(String newTravelRoom) {
    _newTravelRoom = newTravelRoom;
    _prefs.setString(TargetSourceString.newTravelRoom, _newTravelRoom);
  }

  /// This method should only be triggered one time.
  void init() {
    if (_isFirst) {
      _prefs = Repository.getSimpleStorage;
      isMatched = _prefs.getBool(TargetSourceString.isMatched);
      endTimeOfTrip = DateTime.fromMillisecondsSinceEpoch(
          _prefs.getInt(TargetSourceString.endTimeOfTrip));
      hasRevokedDriverPosition =
          _prefs.getBool(TargetSourceString.hasRevokedDriverPosition);
      role = _prefs.getString(TargetSourceString.role);
      driverLat = _prefs.getDouble(TargetSourceString.driverLat);
      driverLng = _prefs.getDouble(TargetSourceString.driverLng);
      hasSentTravel = _prefs.getBool(TargetSourceString.hasSentTravel);
      newTravelRoom = _prefs.getString(TargetSourceString.newTravelRoom);
      _isFirst = false;
    }
  }

  void clearCache() {
    isMatched = false;
    // endTimeOfTrip = -1; // Don't need it
    hasRevokedDriverPosition = false;
    role = null;
    driverLat = null;
    driverLng = null;
    hasSentTravel = false;
    newTravelRoom = null;
  }
}
