// import 'package:client_flutter/src/logics/notify_manager.dart';
import 'package:flutter/material.dart';

import '../../resources/repository.dart';
import '../../resources/restful/request_method.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider._();

  factory ProfileProvider() {
    return _auth;
  }

  static final _auth = ProfileProvider._();
  static final _secure = Repository.getSecureStorage;
  static final _prefs = Repository.getSimpleStorage;
  static final _api = Repository.getApi;

  String _uid;
  String _name;
  String _pwd;
  String _photo;
  String _gender;
  String _birthday;
  String _department;
  String _carNum;

  // String get name => _name; // _name : walker

  // // name : kim
  // // _name : walker
  // set name(String name) {
  //   if (name != null && name.isNotEmpty) {
  //   }
  // }
  String getUserId() {
    _uid = _prefs.getString(TargetSourceString.uid);
    print('test : ' + _uid);
    String email = 's'+_uid;
    // if (_uid == null) {
    //   return '';
    // } else {
    //   return _uid;
    // }
    return email;
  }

  Future<void> invokeModifyName(String newname, String jwt) async {
    _api.sendHttpRequest(ProfileNameRequest(
      name: newname,
      jwtToken: jwt,
    ));
    await _prefs.setString(TargetSourceString.name, newname);

    notifyListeners();
  }

  String getName() {
    _name = _prefs.getString(TargetSourceString.name);
    if (_name == null) {
      return '';
    } else {
      return _name;
    }
  }

  // Future<void> invokeModifyGender(String newgender, String jwt) async {
  //   final response = await _api.sendHttpRequest(ProfileGenderRequest(
  //     name: newgender,
  //     jwtToken: jwt,
  //   ));

  //   _prefs.setString(TargetSourceString.gender, newgender);
  //   print(response.body);
  // }

  String getGender() {
    _gender = _prefs.getString(TargetSourceString.gender);
    if (_gender == null) {
      return '';
    } else {
      return _gender;
    }
  }

  String getBirthday() {
    _birthday = _prefs.getString(TargetSourceString.birthday);
    if (_birthday == null) {
      return '';
    } else {
      return _birthday;
    }
  }

  Future<void> invokeModifyDepartment(String newdepartment, String jwt) async {
    _api.sendHttpRequest(ProfileDepartmentRequest(
      department: newdepartment,
      jwtToken: jwt,
    ));

    await _prefs.setString(TargetSourceString.department, newdepartment);
    notifyListeners();

  }

  String getDepartment() {
    _department = _prefs.getString(TargetSourceString.department);

    if (_department == null) {
      return '';
    } else {
      return _department;
    }
  }

  Future<void> invokeModifyCarNum(String newcarNum, String jwt) async {
    _api.sendHttpRequest(ProfileCarNumRequest(
      carNum: newcarNum,
      jwtToken: jwt,
    ));

    await _prefs.setString(TargetSourceString.department, newcarNum);
    notifyListeners();

  }

  String getCarNum() {
    _carNum = _prefs.getString(TargetSourceString.carNum);

    if (_carNum == null) {
      return '';
    } else {
      return _carNum;
    }
  }

  // Future<void> invokeModifyPhoto(String newphoto, String jwt) async {
  //   _api.sendHttpRequest(ProfilePhotoRequest(
  //     photo: newphoto,
  //     jwtToken: jwt,
  //   ));

  //   await _prefs.setString(TargetSourceString.photo, newphoto);
  //   print(response.body);
  // }

  // String getPhoto() {
  //   _photo = _prefs.getString(TargetSourceString.photo);
  //   if (_photo == null) {
  //     return '';
  //   } else {
  //     return _photo;
  //   }
  // }
}
