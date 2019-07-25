import 'package:flutter/material.dart';

import '../util/platform_info.dart';
import '../widgets/homepage/map_view.dart';
import '../widgets/homepage/bottom_sheet.dart';
import '../widgets/homepage/location_app_bar.dart';

class Homepage extends StatelessWidget {
  static const String routeName = '/homepage';

  @override
  Widget build(BuildContext context) {
    // Assign the context of Homepage to 'PlatformInfo' for getting 
    // the size of scaffold.
    PlatformInfo.context = context; 

    return Scaffold(
      body: Stack(
        children: <Widget>[
          MapView(),
          LocationAppBar(),
          GoogleLogo(),
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
