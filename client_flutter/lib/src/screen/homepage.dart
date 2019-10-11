import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/provider_collection.dart' show HomepageProvider;
import '../widgets/homepage/location_app_bar.dart';
import '../widgets/homepage/map_view.dart';
import '../widgets/homepage/position_floating_action_button.dart';
import '../widgets/homepage/favorite_floating_action_button.dart';
import '../widgets/homepage/chatting_floating_action_button.dart';
import '../widgets/homepage/bottom_sheet.dart';
import '../widgets/homepage/menu_view.dart';
import '../widgets/bulletin.dart';
import '../widgets/build_backdrop_filter.dart';

// import '../../src/util/util_collection.dart' show PlatformInfo;

// import '../test/info_button.dart';
// import '../test/geo_info.dart';

class Homepage extends StatelessWidget {
  static const String routeName = '/homepage';

  @override
  Widget build(BuildContext context) {
    print('Refreshing Homepage ...');
    return Scaffold(
      backgroundColor: Colors.white,
      // key: provider.scaffoldKey,
      body: Stack(
        children: <Widget>[
          MapView(),
          LocationAppBar(),
          // TestingInfoButton(), // WARNING : Only for testing
          // TestingGeoInfo(), // WARNING : Only for testing
          GoogleLogo(),
          PositionFloatingActionButton(),
          FavoriteFloatingActionButton(),
          Bulletin(),
          _blurHomepage(context),

          MenuView(),
        ],
      ),
      bottomSheet: HomepageBottomSheet(),
      floatingActionButton: ChatingFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _blurHomepage(BuildContext context) {
    return Consumer<HomepageProvider>(
      builder: (context, provider, child) {
        return provider.animationManager.isOrderPanel ? child : Container();
      },
      child: buildBackdropFilter(context),
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
