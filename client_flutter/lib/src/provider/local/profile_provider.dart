import 'package:client_flutter/src/logics/notify_manager.dart';
import '../../resources/repository.dart';
import '../../resources/restful/request_method.dart';

class ProfileProvider extends NotifyManager {
  ProfileProvider(notifyListeners) : super(notifyListeners);

  static final _secure = Repository.getSecureStorage;
  static final _prefs = Repository.getSimpleStorage;
  static final _api = Repository.getApi;

  String _name;

  String get name => _name; // _name : walker

  // name : kim
  // _name : walker
  set name(String name) {
    if (name != null && name.isNotEmpty) {
      _prefs.setString(TargetSourceString.name, name);
      _name = _prefs.getString(name);
      notifyListeners();
    }
  }

  Future<void> invokeModifyName(String name, String jwt) async {
    final response = await _api.sendHttpRequest(ProfileNameRequest(
      name: name,
      jwtToken: jwt,
    ));

    print(response.body);
  }
}
