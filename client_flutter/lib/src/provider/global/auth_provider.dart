import 'package:flutter/material.dart';

import '../../resources/repository.dart';

import '../../resources/restful/request_method.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider._();

  factory AuthProvider() {
    return _auth;
  }

  static final _auth = AuthProvider._();

  static final _secure = Repository.getSecureStorage;
  static final _prefs = Repository.getSimpleStorage;
  static final _api = Repository.getApi;

  // get hash verification code
  Future<String> invokeVerifyCode(String uid) async {
    final response = await _api.sendHttpRequest(VerifyUserIdRequest(
      userId: uid,
    ));
    if (response.body == 'fail') {
      return null;
    } else {
      return response.body;
    }
  }

  Future<bool> identifyRegisteredId(String uid) async {
    if (uid.length == 9) {
      final response = await _api.sendHttpRequest(IdentifyRegisteredIDRequest(
        userId: uid,
      ));
      if (response.body == 'fail') {
        return true; // 已註冊過
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> invokeSignUp(Map user) async {
    final response = await _api.sendHttpRequest(SignUpRequest(
      userId: user['uid'],
      password: user['password'],
      username: user['name'],
      gender: user['gender'],
      birthday: user['birthday'],
    ));

    String gender = '';
    if (user['gender'] == 1) {
      gender = '男';
    } else if (user['gender'] == 2) {
      gender = '女';
    }
    // 儲存資料
    if (response.body == 'success') {
      _secure.storeSecret(TargetSourceString.pwd, user['password']);
      _prefs.setString(TargetSourceString.uid, user['id']);
      _prefs.setString(TargetSourceString.name, user['name']);
      _prefs.setString(TargetSourceString.gender, gender);
      _prefs.setString(TargetSourceString.birthday, user['birthday']);
    }

    print(response.body);
  }

  String jwt;

  Future<void> invokeLogin(String id, String pwd) async {
    final response = await _api.sendHttpRequest(LoginRequest(
      userId: id,
      password: pwd,
    ));
    print(response.statusCode);

    if (response.statusCode == 200) {
      _secure.storeSecret(TargetSourceString.jwt, response.body);
    }

    jwt = response.body;

    // if()
    _prefs.setString(
        TargetSourceString.lastLoginTime, DateTime.now().toString());

    // notifyListeners();
  }

  Future<void> init() async {
    jwt = await _secure.getSecret(TargetSourceString.jwt);
    print('The value of jwt token is $jwt');
    final lastLoginTime = _prefs.getString(TargetSourceString.lastLoginTime);

    ///TODO
    if (lastLoginTime != null) {
      final lastDateTime = DateTime.parse(lastLoginTime);

      final duration = lastDateTime.difference(DateTime.now()).inDays;

      if (duration > 30) {
        jwt = null;
      }
    }
  }
}
