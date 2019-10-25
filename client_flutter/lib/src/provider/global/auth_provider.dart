import 'package:flutter/material.dart';
import 'dart:convert';

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

    // Map<String, dynamic> obj = json.decode(response.body);

    print('hash value : ' + response['hash']);

    if (response['status'] == 'fail') {
      return null;
    } else {
      return response['hash'];
    }
  }

  Future<bool> identifyRegisteredId(String uid) async {
    if (uid.length == 9) {
      print(uid);
      final response = await _api.sendHttpRequest(IdentifyRegisteredIDRequest(
        userId: uid,
      ));

      print(response['status']);

      if (response['status'] == 'fail') {
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
    if (response['status'] == 'success') {
      await Future.wait([
        _secure.storeSecret(TargetSourceString.pwd, user['password']),
        _prefs.setString(TargetSourceString.uid, user['uid']),
        _prefs.setString(TargetSourceString.name, user['name']),
        _prefs.setString(TargetSourceString.gender, gender),
        _prefs.setString(TargetSourceString.birthday, user['birthday']),
      ]);
    }

    print(response['status']);
  }

  String jwt;

  Future<void> invokeLogin(String id, String pwd) async {
    final response = await _api.sendHttpRequest(LoginRequest(
      userId: id,
      password: pwd,
    ));
    print(response['statusCode']);

    if (response['statusCode'] == 200) {
      _secure.storeSecret(TargetSourceString.jwt, response['jwt']);
    }

    jwt = response['jwt'];

    _prefs.setString(
        TargetSourceString.lastLoginTime, DateTime.now().toString());
  }

  void invokeLogout() {
    print('jwt is $jwt');
    jwt = null;

    _secure.storeSecret(TargetSourceString.jwt, 'logout');
    print('jwt is $jwt');
  }

  Future<void> init() async {
    jwt = await _secure.getSecret(TargetSourceString.jwt);
    print('The value of jwt token is $jwt');
    final lastLoginTime = _prefs.getString(TargetSourceString.lastLoginTime);

    // The app is launched for the first time.
    if (jwt == null) return jwt = 'logout';

    // The app has been loged in before
    if (lastLoginTime != null) {
      final lastDateTime = DateTime.parse(lastLoginTime);

      final duration = lastDateTime.difference(DateTime.now()).inDays;

      if (duration > 30) {
        jwt = 'logout';
      }
    }
  }
}
