import 'package:flutter/material.dart';

import '../../resources/repository.dart';

import '../../resources/restful/request_method.dart';
import '../../util/validation_handler.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider._();

  factory AuthProvider() {
    return _auth;
  }

  static final _auth = AuthProvider._();

  static final _secure = Repository.getSecureStorage;
  static final _api = Repository.getApi;
  static final _prefs = Repository.getSimpleStorage;

  Future invokeVerifyCode(String uid) async {
    final response = await _api.sendHttpRequest(VerifyUserIdRequest(
      userId: uid,
    ));
    return response.statusCode;
  }

  bool checkVerifyCode(String rawSixDigits, final hashedrawSixDigits) {
    return ValidationHandler.verifySixDigitsCode(rawSixDigits: rawSixDigits, hashedSixDigits: hashedrawSixDigits.toString());
  }

  Future<void> invokeSignUp(Map user) async{
    final response = await _api.sendHttpRequest(SignUpRequest(
      userId: user['uid'],
      password: user['password'],
      username: user['name'],
      gender: user['gender'],
      birthday: user['birthday'],
    ));
    
    print(response.statusCode);

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
