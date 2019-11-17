// import 'package:client_flutter/src/logics/notify_manager.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

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

  String _photo;
  String _uid;
  String _name;
  String _pwd;
  String _gender;
  String _birthday;
  String _department;
  String _carNum;

  Uint8List getPhoto() {
    _photo = _prefs.getString(TargetSourceString.photo);
    if (_photo == null || _photo == ''|| _photo == 'null') {
      return null;
    } else {
      Uint8List bytes = base64.decode(_photo);
      return bytes;
    }
  }

  String getUserId() {
    _uid = _prefs.getString(TargetSourceString.uid);
    if (_uid == null) {
      return '';
    } else {
      return _uid;
    }
  }

  Future<String> getPassword() async {
    _pwd = await _secure.getSecret(TargetSourceString.pwd);
    if (_pwd == null) {
      return '';
    } else {
      return _pwd;
    }
  }

  String getEmail() {
    _uid = _prefs.getString(TargetSourceString.uid);
    if (_uid == null) {
      return '';
    } else {
      String email = 's' + _uid;
      return email;
    }
  }

  String getName() {
    _name = _prefs.getString(TargetSourceString.name);
    if (_name == null) {
      return '';
    } else {
      return _name;
    }
  }

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

  String getDepartment() {
    _department = _prefs.getString(TargetSourceString.department);

    if (_department == null) {
      return '';
    } else {
      return _department;
    }
  }

  String getCarNum() {
    _carNum = _prefs.getString(TargetSourceString.carNum);
    if (_carNum == null) {
      return '';
    } else {
      return _carNum;
    }
  }

  Future<void> invokeModifyPhoto(File newImage, String jwt) async {
    if (newImage == null) {
      await _prefs.setString(TargetSourceString.photo, null);
      _api.sendHttpRequest(ProfilePhotoRequest(
        photo: null,
        jwtToken: jwt,
      ));
    } else {
      Uint8List imageBytes = await newImage.readAsBytes();
      _api.sendHttpRequest(ProfilePhotoRequest(
        photo: base64Encode(imageBytes),
        jwtToken: jwt,
      ));
      await _prefs.setString(
          TargetSourceString.photo, base64Encode(imageBytes));
    }

    notifyListeners();
  }

  Future<void> invokeModifyName(String newname, String jwt) async {
    _api.sendHttpRequest(ProfileNameRequest(
      name: newname,
      jwtToken: jwt,
    ));
    await _prefs.setString(TargetSourceString.name, newname);

    notifyListeners();
  }

  Future<void> invokeModifyPassword(String newpwd, String jwt) async {
    _api.sendHttpRequest(ProfilePwdRequest(
      password: newpwd,
      jwtToken: jwt,
    ));
    await _secure.storeSecret(TargetSourceString.pwd, newpwd);

    notifyListeners();
  }
  
  // Future<void> invokeModifyGender(String newgender, String jwt) async {
  //   final response = await _api.sendHttpRequest(ProfileGenderRequest(
  //     name: newgender,
  //     jwtToken: jwt,
  //   ));

  //   _prefs.setString(TargetSourceString.gender, newgender);
  // }

  Future<void> invokeModifyBirthday(String newbirthday, String jwt) async {
    _api.sendHttpRequest(ProfileBirthdayRequest(
      birthday: newbirthday,
      jwtToken: jwt,
    ));

    await _prefs.setString(TargetSourceString.birthday, newbirthday);
    notifyListeners();
  }

  Future<void> invokeModifyDepartment(String newdepartment, String jwt) async {
    _api.sendHttpRequest(ProfileDepartmentRequest(
      department: newdepartment,
      jwtToken: jwt,
    ));

    await _prefs.setString(TargetSourceString.department, newdepartment);
    notifyListeners();
  }

  Future<void> invokeModifyCarNum(String newcarNum, String jwt) async {
    _api.sendHttpRequest(ProfileCarNumRequest(
      carNum: newcarNum,
      jwtToken: jwt,
    ));

    await _prefs.setString(TargetSourceString.carNum, newcarNum);
    notifyListeners();
  }
}
