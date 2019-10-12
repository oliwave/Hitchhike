import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/platform_info.dart';
import '../../provider/provider_collection.dart'
    show HomepageProvider, MenuProvider;

class MenuButton extends StatefulWidget {
  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  // AnimationController menuIconController;
  // Animation<double> iconAnimation;

  // @override
  // void initState() {
  //   menuIconController = AnimationController(
  //     vsync: this,
  //     duration: Duration(milliseconds: 500),
  //   );

  //   iconAnimation = CurvedAnimation(
  //     parent: menuIconController,
  //     curve: Curves.linear,
  //   );

  //   final provider = Provider.of<MenuProvider>(
  //     context,
  //     listen: false,
  //   );

  //   provider.menuIconController = menuIconController;

  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   menuIconController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    print('Refreshing MenuButton ...');

    final homeProvider = Provider.of<HomepageProvider>(
      context,
      listen: false,
    );

    final menuProvider = Provider.of<MenuProvider>(
      context,
      listen: false,
    );

    return Padding(
      padding: EdgeInsets.only(
        // top: PlatformInfo.screenAwareSize(10.0),
        top: SizeConfig.screenAwareWidth(3.0),
        // left: PlatformInfo.screenAwareSize(12.0),
        // right: PlatformInfo.screenAwareSize(5.0),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          child: Hero(
            tag: 'menu',
            child: Icon(
              // progress: iconAnimation,
              // icon: AnimatedIcons.menu_close,
              Icons.menu,
              // size: PlatformInfo.screenAwareWidth(23),
              size: SizeConfig.screenAwareWidth(7),
            ),
          ),
          onTap: () => menuProvider.setMenuVisible(true, homeProvider),
        ),
      ),
    );
  }
}
