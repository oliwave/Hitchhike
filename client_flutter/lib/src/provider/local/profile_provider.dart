import 'package:client_flutter/src/logics/notify_manager.dart';
import '../../resources/repository.dart';
import '../../resources/restful/request_method.dart';

class ProfileProvider extends NotifyManager {
  ProfileProvider(notifyListeners) : super(notifyListeners);

  static final _api = Repository.getApi;

  String _password;
  String _name;
  String _gender;
  String _birthday;
  String _photo;

  String get password => _password;
  String get gender => _gender;
  String get name => _name; // _name : walker
  String get birthday => _birthday; // _name : walker
  String get photo => _photo; // _name : walker

  set password(String password) {
    if (password != null && password.isNotEmpty) {
      _password = password;
      notifyListeners();
    }
  }

  // name : kim
  // _name : walker
  set name(String name) {
    if (name != null && name.isNotEmpty) {
      _name = name;
      notifyListeners();
    }
  }

  set gender(String gender) {
    if (gender != null && name.isNotEmpty) {
      _gender = gender;
      notifyListeners();
    }
  }

  set birthday(String birthday) {
    if (birthday != null && birthday.isNotEmpty) {
      _birthday = birthday;
      notifyListeners();
    }
  }

  set photo(String photo) {
    if (photo != null && photo.isNotEmpty) {
      _photo = photo;
      notifyListeners();
    }
  }

  Future<void> modifyPassword(_password, jwt) async {
    final response = await _api.sendHttpRequest(ProfilePwdRequest(
      password: _password,
      jwtToken: jwt,
    ));

    print(response.statusCode);
  }

  Future<void> modifyProfileName(_name, jwt) async {
    final response = await _api.sendHttpRequest(ProfileNameRequest(
      name: _name,
      jwtToken: jwt,
    ));

    print(response.statusCode);
  }

  Future<void> modifyProfilePhoto(_photo, jwt) async {
    final response = await _api.sendHttpRequest(ProfilePhotoRequest(
      photo: _photo,
      jwtToken: jwt,
    ));

    print(response.statusCode);
  }
}
