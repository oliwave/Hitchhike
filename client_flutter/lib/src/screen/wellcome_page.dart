import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './page_collection.dart' show Homepage, FavoriteRoutesPage, LoginPage;
import '../util/util_collection.dart' show PlatformInfo;

import '../../init_setting.dart';
import '../provider/provider_collection.dart' show AuthProvider;

class WellcomePage extends StatelessWidget {
  static const String routeName = '/wellcome_page';

  @override
  Widget build(BuildContext context) {
    // Initializing the client app.
    // PlatformInfo.context = context;

    print('Device width : ${MediaQuery.of(context).size.width}');
    print('Device heigth : ${MediaQuery.of(context).size.height}');

    init.runInitSetting(context).then((_) {
      print('Finished initial setup!\n');
      final authProivder = Provider.of<AuthProvider>(context, listen: false);
      String targetRoute;
      if (authProivder.jwt == null) {
        targetRoute = LoginPage.routeName;
      } else {
        targetRoute = Homepage.routeName;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        targetRoute,
        // FavoriteRoutesPage.routeName,
        (Route<dynamic> route) => false,
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RichText(
          text: TextSpan(
            text: '暨大搭便車\n',
            style: TextStyle(
              letterSpacing: 1,
              fontSize: 37,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Hitchhike',
                style: TextStyle(
                    letterSpacing: 3,
                    fontSize: 25,
                    fontStyle: FontStyle.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
