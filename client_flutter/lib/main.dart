import 'package:client_flutter/init_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './src/screen/page_collection.dart';
import './src/provider/setup_provider.dart';

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
        ...localProviders,
        ...globalProviders,
      ],
      child: MaterialApp(
        title: 'hitchhike',
        home: LoginPage(),
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

  Widget navigateToTargetPage(String routeName) {

    print(routeName);
    var page;
    if (routeName == Homepage.routeName) {
      page = Homepage();
    } else if (routeName == LoginPage.routeName) {
      page = LoginPage();
    } else if (routeName == SignUpProfilePage.routeName) {
      page = SignUpProfilePage();
    } else if (routeName == ProfilePage.routeName) {
      page = ProfilePage();
    } else {
      page = BadRoutePage();
    }
    return page;
  }
}
