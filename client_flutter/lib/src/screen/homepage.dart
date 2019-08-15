import 'package:client_flutter/src/util/util_collection.dart';
import 'package:flutter/material.dart';

import '../util/platform_info.dart';
import '../widgets/homepage/location_app_bar.dart';
import '../widgets/homepage/map_view.dart';
import '../widgets/homepage/position_floating_action_button.dart';
import '../widgets/homepage/bottom_sheet.dart';
import '../widgets/homepage/google_map_widget/marker_bitmap.dart';
import '../widgets/bulletin.dart';

import '../test/info_button.dart';
import '../test/geo_info.dart';

class Homepage extends StatelessWidget {
  static const String routeName = '/homepage';

  @override
  Widget build(BuildContext context) {

    print('Device width : ${MediaQuery.of(context).size.width}');
    print('Device heigth : ${MediaQuery.of(context).size.height}');

    // Assign the context of Homepage to 'PlatformInfo' for getting
    // the size of scaffold.
    PlatformInfo.context = context;

    MarkerBitmap(context);
    print('Initialize the MarkerBitmap!');

    print('Refreshing Homepage ...');

    return Scaffold(
      body: Stack(
        children: <Widget>[
          MapView(),
          LocationAppBar(),
          TestingInfoButton(), // WARNING : Only for testing
          TestingGeoInfo(), // WARNING : Only for testing
          GoogleLogo(),
          PositionFloatingActionButton(),
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
