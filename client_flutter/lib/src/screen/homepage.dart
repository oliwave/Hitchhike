import 'package:client_flutter/src/widgets/homepage/favorite_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_collection.dart' show CloudMessageProvider;
import '../widgets/homepage/location_app_bar.dart';
import '../widgets/homepage/map_view.dart';
import '../widgets/homepage/position_floating_action_button.dart';
import '../widgets/homepage/bottom_sheet.dart';
import '../widgets/bulletin.dart';

import '../../src/util/util_collection.dart' show PlatformInfo;

import '../test/info_button.dart';
import '../test/geo_info.dart';

class Homepage extends StatelessWidget {
  static const String routeName = '/homepage';

  @override
  Widget build(BuildContext context) {
    PlatformInfo.context = context;

    Provider.of<CloudMessageProvider>(
      context,
      listen: false,
    ).context = context;

    print('Refreshing Homepage ...');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          MapView(),
          LocationAppBar(),
          TestingInfoButton(), // WARNING : Only for testing
          TestingGeoInfo(), // WARNING : Only for testing
          GoogleLogo(),
          PositionFloatingActionButton(),
          FavoriteFloatingActionButton(),
          Bulletin(),
        ],
      ),
      bottomSheet: HomepageBottomSheet(),
    );
  }
}

class GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-0.85, 0.8),
      child: Text(
        'Google',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
