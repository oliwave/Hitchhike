// import '../resources/cached/simple_storage.dart';
import 'package:flutter/material.dart';

import '../resources/repository.dart';

/// Recording the current client information
///
/// The [isMatched] is used to judge whether the client is in the matched mode. And
/// if the client is in the matched mode, the [isDriver] can determine what role the
/// client is.
class RoleModel with ChangeNotifier {
  static final _prefs = Repository.getSimpleStorage;

  bool _isMatched = _prefs.getBool(TargetSourceString.isMatched);
  bool _isDriver = _prefs.getBool(TargetSourceString.isDriver);

  bool get isMatched => _isMatched;
  bool get isDriver => _isDriver;

  set isMatched(bool isMatched) {
    _isMatched = isMatched;
  }

  set isDriver(bool isDriver) {
    _isDriver = isDriver;
    notifyListeners();
  }

  @override
  void dispose() {
    // Save the state in case the client turns off the app
    if (_isMatched) {
      _prefs.setBool(TargetSourceString.isDriver, _isDriver);
      _prefs.setBool(TargetSourceString.isMatched, _isMatched);
    }
    super.dispose();
  }
}
