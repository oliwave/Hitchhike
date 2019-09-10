import 'package:client_flutter/src/logics/notify_manager.dart';

class ProfileProvider extends NotifyManager {
  ProfileProvider(notifyListeners) : super(notifyListeners);

  String _name;

  String get name {
    return _name; // _name : walker
  }

  // name : kim
  // _name : walker
  set name(String name) {
    if (name != null && name.isNotEmpty) {
      _name = name;
      notifyListeners(); 
    }
  } 

}
