import 'package:client_flutter/src/provider/role_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import './src/provider/location_provider.dart';
import './src/screen/screen_route.dart';

import './test_api.dart';

Future main() async {
  // Testing the restful api
  TestApi testApi = TestApi();
  final futureList = [
    testApi.testVerifyUid(),
  ];
  await Future.wait(futureList);

  await setPermission();

  // Formal app
  runApp(MyApp());
}

Future setPermission() async {
  final permissions = await PermissionHandler()
      .requestPermissions([PermissionGroup.locationWhenInUse]);

  print('show the location permission status : '
      '${permissions[PermissionGroup.locationWhenInUse]}');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: multiProviderList(),
      child: MaterialApp(
        title: 'hitchhike',
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              return navigateToTargetPage(settings);
            },
          );
        },
      ),
    );
  }

  multiProviderList() => [
        ChangeNotifierProvider(builder: (context) => RoleProvider()),
        ChangeNotifierProvider(builder: (context) => LocationProvider()),
      ];

  Widget navigateToTargetPage(RouteSettings settings) {
    if (settings.name == Homepage.routeName) {
      return Homepage();
    } else if (settings.name == LoginPage.routeName) {
      return LoginPage();
    } else if (settings.name == SignUpProfilePage.routeName) {
      return SignUpProfilePage();
    } else if (settings.name == ProfilePage.routeName) {
      return ProfilePage();
    } else {
      throw 'bad route';
    }
  }
}
