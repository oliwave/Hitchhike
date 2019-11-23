import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info/device_info.dart';

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
    await _api.sendHttpRequest(SignUpRequest(
      userId: user['uid'],
      password: user['password'],
      username: user['name'],
      gender: user['gender'],
      birthday: user['birthday'],
    ));
  }

  // 使用者在後端紀錄的裝置和現在的裝置是否相同
  // 若使用者在後端紀錄的裝置為空值 return null
  Future<String> identifyDevice(String uid, String currentDevice) async {
    final response = await _api.sendHttpRequest(GetUserDeviceRequest(
      userID: uid,
    ));
    if (response['device'] == null) {
      return null;
    } else if (currentDevice == response['device']) {
      return 'true';
    } else {
      return 'false';
    }
  }

  // 向後端請求把登入使用者的 userDevice 設為 currentDevice
  void invokeModifyDevice(String currentDevice, String jwt) {
    _api.sendHttpRequest(SetUserDeviceRequest(
      currentDevice: currentDevice,
      jwtToken: jwt,
    ));

    notifyListeners();
  }

  // 將 jwt token 存到 secureStorage
  void invokeStoreJwtToken(String jwt) {
    _secure.storeSecret(TargetSourceString.jwt, jwt);
  }

  // 從後端取得個人資訊並存入 simpleStorage, secureStorage
  Future<void> invokeStoreUserInfo(String jwt) async {
    final response = await _api.sendHttpRequest(GetUserInfoRequest(
      jwtToken: jwt,
    ));
    String gender = '';
    if (response['status'] != 'fail') {
      print(response['carNum']);
      if (response['gender'] == 1) {
        gender = '男';
      } else if (response['gender'] == 2) {
        gender = '女';
      }
      await Future.wait([
        _secure.storeSecret(TargetSourceString.pwd, response['pwd']),
        _prefs.setString(TargetSourceString.photo, response['photo']),
        _prefs.setString(TargetSourceString.uid, response['uid'].toString()),
        _prefs.setString(TargetSourceString.name, response['name']),
        _prefs.setString(TargetSourceString.gender, gender),
        _prefs.setString(TargetSourceString.department, response['department']),
        _prefs.setString(TargetSourceString.birthday, response['birthday']),
        _prefs.setString(TargetSourceString.carNum, response['car_num']),
      ]);
    }
  }

  // 向後端請求確認該名使用者是否在行程中
  Future<bool> identifyUserState(String uid) async {
    final response = await _api.sendHttpRequest(GetUserStateRequest(
      userID: uid,
    ));
    if (response['state'] == 'ture') {
      return true;
    } else {
      return false;
    }
  }

  String jwt;
  String currentUid; // 當前登入使用者
  String currentDevice;

  Future<bool> invokeLogin(String id, String pwd) async {
    final response = await _api.sendHttpRequest(LoginRequest(
      userId: id,
      password: pwd,
    ));

    print(response['statusCode']);

    if (response['statusCode'] == 200) {
      // _secure.storeSecret(TargetSourceString.jwt, response['jwt']);

      jwt = response['jwt'];
      currentUid = id;
      currentDevice = await getDeviceInfo();
      debugPrint('currentUid: $currentUid');
      debugPrint('currentDevice: $currentDevice');

      _prefs.setString(
          TargetSourceString.lastLoginTime, DateTime.now().toString());

      return true;
    } else {
      Fluttertoast.showToast(
        msg: '登入失敗',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red[400].withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }

  void invokeLogout() {
    print('jwt is $jwt');
    jwt = 'logout';
    currentUid = '';

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

  Future getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    }
  }

  void clearAllData(){

  }
}
