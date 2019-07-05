import 'package:permission_handler/permission_handler.dart';

/// [init] is a comile-time constant.
/// [https://dart.dev/guides/language/language-tour#final-and-const]
const init = InitSetting();

class InitSetting {
  const InitSetting();

  Future runInitSetting() {
    return Future.wait(
      [
        _setPermission(),
      ],
    );
  }

  Future _setPermission() async {
    final permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.locationWhenInUse]);

    print('show the location permission status : '
        '${permissions[PermissionGroup.locationWhenInUse]}');
  }
}
