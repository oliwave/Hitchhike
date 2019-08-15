import 'package:permission_handler/permission_handler.dart';

import './src/resources/repository.dart';
import './src/resources/restful/request_method.dart' show FcmTokenRequest;

/// [init] is a comile-time constant.
/// [https://dart.dev/guides/language/language-tour#final-and-const]
final init = InitSetting();

class InitSetting {
  static final _prefs = Repository.getSimpleStorage;
  static final _api = Repository.getApi;
  static final _fcm = Repository.getCloudMessageHandler;

  Future<void> runInitSetting() async {
    await _setLocationPermission();
    await _prefs.init();
    await _fcm.init();
    _checkLaunchingTime();
  }

  Future<void> _setLocationPermission() async {
    final permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.locationWhenInUse]);

    print('show the location permission status : '
        '${permissions[PermissionGroup.locationWhenInUse]}');
  }

  void _checkLaunchingTime() {
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
