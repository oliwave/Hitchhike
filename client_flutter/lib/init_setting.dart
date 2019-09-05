import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './src/resources/file/directory_access.dart';
import './src/widgets/homepage/google_map_widget/marker_bitmap.dart';
import './src/resources/repository.dart';
import './src/resources/restful/request_method.dart' show FcmTokenRequest;
import './src/provider/provider_collection.dart'
    show LocationProvider, FavoriteRoutesProvider;

/// [init] is a comile-time constant.
/// [https://dart.dev/guides/language/language-tour#final-and-const]
final init = InitSetting();

class InitSetting {
  static final _prefs = Repository.getSimpleStorage;
  static final _api = Repository.getApi;
  static final _fcm = Repository.getCloudMessageHandler;
  static final _db = Repository.getDatabaseHandler;

  static final _bitmap = MarkerBitmap();
  static final _locationProvider = LocationProvider();
  static final _favoriteRoutesProvider = FavoriteRoutesProvider();

  Future<void> runInitSetting(BuildContext context) async {
    await _setLocationPermission();
    await _prefs.init();
    await _fcm.init();
    await _bitmap.initializeBitmap(context);
    await DirectoryAccess.initDirectory();
    await _locationProvider.initializePosition();
    await _db.init();
    await _favoriteRoutesProvider.initRoutesList();

    _checkLaunchingTimes();
  }

  Future<void> _setLocationPermission() async {
    _fcm.iOSPermissionRequest();

    final permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.locationWhenInUse]);

    print('show the location permission status : '
        '${permissions[PermissionGroup.locationWhenInUse]}');
  }

  void _checkLaunchingTimes() {
    final hasMultipleLaunched =
        _prefs.getBool(TargetSourceString.hasMultipleLaunched);

    if (!hasMultipleLaunched) {
      final response = _api.sendHttpRequest(FcmTokenRequest(
        fcmToken: _fcm.fcmToken,
        jwtToken: '',
      ));

      _prefs.setBool(TargetSourceString.hasMultipleLaunched, true).then(
          (onValue) => print('hasMultipleLaunched is set with : $onValue'));
    }
  }
}
