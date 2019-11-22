import 'dart:async';

import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import './src/resources/file/directory_access.dart';
import './src/widgets/homepage/google_map_widget/marker_bitmap.dart';
import './src/resources/repository.dart';
import './src/provider/provider_collection.dart'
    show LocationProvider, FavoriteRoutesProvider, ConnectivityProvider, AuthProvider;

final init = InitSetting();

class InitSetting {
  static final _prefs = Repository.getSimpleStorage;
  static final _fcmHandler = Repository.getCloudMessageHandler;
  static final _db = Repository.getDatabaseHandler;

  static final _bitmap = MarkerBitmap();
  static final _locationProvider = LocationProvider();
  static final _favoriteRoutesProvider = FavoriteRoutesProvider();
  static final _connectivityProvider = ConnectivityProvider();
  static final _authProvider = AuthProvider();

  Future<void> runInitSetting(BuildContext context) async {
    await _setLocationPermission();
    await _prefs.init();

    _connectivityProvider.networkConnection();
    
    await _bitmap.initializeBitmap(context);
    await DirectoryAccess.initDirectory();
    ///TODO : cannot call following code without internet. 
    await _locationProvider.initializePosition();
    await _db.init();
    await _favoriteRoutesProvider.initRoutesList();
    await _authProvider.init();
  }

  Future<void> _setLocationPermission() async {
    _fcmHandler.iOSPermissionRequest();

    final permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.locationAlways]);

    print('show the location permission status : '
        '${permissions[PermissionGroup.locationWhenInUse]}');
  }
}
