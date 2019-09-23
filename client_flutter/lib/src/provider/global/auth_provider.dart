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
  static final _api = Repository.getApi;
  static final _prefs = Repository.getSimpleStorage;

  String jwt;

  Future<void> invokeLogin(String id, String pwd) async {
    final response = await _api.sendHttpRequest(LoginRequest(
      userId: id,
      password: pwd,
    ));

    print(response.statusCode);

    _secure.storeSecret(TargetSourceString.jwt, response.body);

    jwt = response.body;

    // if()
    _prefs.setString(
        TargetSourceString.lastLoginTime, DateTime.now().toString());

    // notifyListeners();
  }

  Future<void> init() async {
    jwt = await _secure.getSecret(TargetSourceString.jwt);
    final lastLoginTime = _prefs.getString(TargetSourceString.lastLoginTime);
    final lastDateTime = DateTime.parse(lastLoginTime);

    final duration = lastDateTime.difference(DateTime.now()).inDays;

    if (duration > 30) {
      jwt = null;
    }
  }
}
