import 'package:client_flutter/init_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './src/screen/page_collection.dart';
import './src/provider/setup_provider.dart';

// import './test_api.dart'; // (ucomment this to test api)

Future main() async {
  // Testing the restful api. // (ucomment this to test api)
  // await apiTest.runTest(); // (ucomment this to test api)

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
        ...globalProviders,
        ...localProviders,
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Colors.transparent,
        ),
        title: 'hitchhike',
        // home: LoginPage(), // (profile)
        home: Homepage(), // (debug)
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              return navigateToTargetPage(settings.name);
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
