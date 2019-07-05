import 'package:client_flutter/init_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './src/screen/screen_route.dart';
import './src/notifier/location_notifier.dart';
import './src/notifier/role_notifier.dart';

import './test_api.dart';

Future main() async {
  // Testing the restful api.
  await apiTest.runTest();

  // Initializing the client app.
  await init.runInitSetting();

  // Formal app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => RoleNotifier()),
        ChangeNotifierProvider(builder: (_) => LocationNotifier()),
      ],
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
