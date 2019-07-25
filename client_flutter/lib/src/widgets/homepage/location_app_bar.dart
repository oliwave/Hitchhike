import 'package:flutter/material.dart';

import '../../util/platform_info.dart';
import '../../widgets/homepage/search_block.dart';

import './menu_button.dart';

class LocationAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false, // iOS will have padding at the bottom
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: PlatformInfo.screenAwareSize(90),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 3,
                offset: Offset(0, 1), // Only set the box shadow at the bottom
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MenuButton(),
              SearchBlock(),
            ],
          ),
        ),
      ),
    );
  }
}
