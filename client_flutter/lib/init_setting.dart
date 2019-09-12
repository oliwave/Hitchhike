import 'dart:async';

import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity/connectivity.dart';

import './src/resources/file/directory_access.dart';
import './src/widgets/homepage/google_map_widget/marker_bitmap.dart';
import './src/resources/repository.dart';
import './src/resources/restful/request_method.dart' show FcmTokenRequest;
import './src/provider/provider_collection.dart'
    show LocationProvider, FavoriteRoutesProvider, ConnectivityProvider;

/// TODO : Must add Wifi and data permission to make sure every user behavior is correct.
final init = InitSetting();

class InitSetting {
  static final _prefs = Repository.getSimpleStorage;
  static final _api = Repository.getApi;
  static final _fcm = Repository.getCloudMessageHandler;
  static final _db = Repository.getDatabaseHandler;

  static final _bitmap = MarkerBitmap();
  static final _locationProvider = LocationProvider();
  static final _favoriteRoutesProvider = FavoriteRoutesProvider();
  static final _connectivityProvider = ConnectivityProvider();

  Future<void> runInitSetting(BuildContext context) async {
    await _setLocationPermission();
    _networkConnection();
    await _prefs.init();
    await _fcm.init();
    await _bitmap.initializeBitmap(context);
    await DirectoryAccess.initDirectory();
    await _locationProvider.initializePosition();
    await _db.init();
    await _favoriteRoutesProvider.initRoutesList();

    _checkHasFcmToken();
  }

  Future<void> _setLocationPermission() async {
    _fcm.iOSPermissionRequest();

    final permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.locationWhenInUse]);

    print('show the location permission status : '
        '${permissions[PermissionGroup.locationWhenInUse]}');
  }

  Future<void> _checkHasFcmToken() async {
    final hasFcmToken = _prefs.getBool(TargetSourceString.hasFcmToken);
    print(
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhas'
        'FcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken'
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken'
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken'
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken'
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken'
        'hasFcmTokenhasFcmTokenhasFcmTokenhasFcmToken is $hasFcmToken');

    /// TODO : refactor to use hasSendFcmToken instead of hasFcmToken
    if (!hasFcmToken) {
      final response = await _api.sendHttpRequest(
        FcmTokenRequest(
          fcmToken: _fcm.fcmToken,
          jwtToken: '',
        ),
      );

      print(
          'fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response '
          'fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response '
          'fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response '
          'fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response fcm response '
          'fcm response : ${response.statusCode}');

      final result = await _prefs.setBool(
        TargetSourceString.hasFcmToken,
        response.statusCode == 200,
      );

      print('hasFcmToken is set with : $result');
    }
  }

  void _networkConnection() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print(
          'Connectivity has been triggered and the network status is $result');
      _connectivityProvider.networkStatus = result != ConnectivityResult.none;
    });
  }
}
