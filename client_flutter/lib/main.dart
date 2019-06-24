import 'package:flutter/material.dart';

import './src/screen/screen_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hitchhike',
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return navigateToTargetPage(settings);
          },
        );
      },
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
