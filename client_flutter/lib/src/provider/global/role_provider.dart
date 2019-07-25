import 'package:flutter/material.dart';

import '../../resources/repository.dart';

/// Recording the current client information
///
/// The [isMatched] is used to judge whether the client is in the matched mode. And
/// if the client is in the matched mode, the [isDriver] can determine what role the
/// client is.
class RoleProvider with ChangeNotifier {
  static final _prefs = Repository.getSimpleStorage;

  bool _isMatched = _prefs.getBool(TargetSourceString.isMatched);
  String _role = _prefs.getString(TargetSourceString.role);

  bool get isMatched => _isMatched;
  String get role => _role;

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
    }
    super.dispose();
  }
}
