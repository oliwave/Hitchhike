import 'package:client_flutter/src/provider/provider_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/platform_info.dart';
import '../../widgets/homepage/search_block.dart';

import './menu_button.dart';
import './bookmark.dart';

class LocationAppBar extends StatefulWidget {
  @override
  _LocationAppBarState createState() => _LocationAppBarState();
}

class _LocationAppBarState extends State<LocationAppBar>
    with SingleTickerProviderStateMixin {
  AnimationController _appBarController;
  Animation<double> _appBarAnimation;
  Animation<Color> _statusBarColorAnimation;

  @override
  void initState() {
    _appBarController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _appBarAnimation = _appBarController.drive(
      Tween<double>(
        begin: 90,
        end: 0,
      ),
    );

    _statusBarColorAnimation = _appBarAnimation.drive(
      ColorTween(
        begin: Colors.transparent,
        end: Colors.white,
      ),
    );

    final provider = Provider.of<HomepageProvider>(
      context,
      listen: false,
    );

    provider.appBarController = _appBarController;

    super.initState();
  }

  @override
  void dispose() {
    _appBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Refreshing LocationAppBar ...');

    return AnimatedBuilder(
      animation: _statusBarColorAnimation,
      builder: (BuildContext context, Widget content) {
        return Container(
          color: _statusBarColorAnimation.value,
          child: SafeArea(
            bottom: false, // iOS will have padding at the bottom
            child: content,
          ),
        );
      },
      child: AnimatedBuilder( // content
        animation: _appBarAnimation,
        builder: (BuildContext context, Widget rowOfWidgets) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: PlatformInfo.screenAwareSize(_appBarAnimation.value),
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
            child: _appBarController.isDismissed ? rowOfWidgets : null,
          );
        },
        child: Row( // rowOfWidgets
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: MenuButton(),
            ),
            Flexible(
              flex: 5,
              fit: FlexFit.loose,
              child: SearchBlock(),
            ),
            Flexible(
              flex: 1,
              child: Bookmark(),
            ),
          ],
        ),
      ),
    );
  }
}
