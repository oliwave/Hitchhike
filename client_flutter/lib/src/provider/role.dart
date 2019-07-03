import 'package:flutter/material.dart';

import '../resources/repository.dart';

/// Recording the current client information
/// 
/// The [isMatched] is used to judge whether the client is in the matched mode. And
/// if the client is in the matched mode, the [isDriver] can determine what role the 
/// client is.
class Role extends ChangeNotifier {

  static final _repo = Repository.getInstance();

  bool _isMatched = _repo.getIsDriver();
  bool _isDriver = _repo.getIsMatched();

  bool get isMatched => _isMatched;
  bool get isDriver => _isDriver;

  set isMatched(bool isMatched) {
    _isMatched = isMatched;
    // notifyListeners();
  }

  set isDriver(bool isDriver) {
    _isDriver = isDriver;
    notifyListeners();
  }

  @override
  void dispose() {
    // Save the state in case the client turns off the app
    if (_isMatched) {
      _repo.setIsDriver(_isDriver);
      _repo.setIsMatched(_isMatched);
    }
    super.dispose();
  }
  
}