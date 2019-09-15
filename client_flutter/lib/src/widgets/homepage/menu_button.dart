import 'package:flutter/material.dart';

import '../../util/platform_info.dart';

class MenuButton extends StatefulWidget {
  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> iconAnimation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    iconAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Refreshing MenuButton ...');

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
          child: AnimatedIcon(
            progress: iconAnimation,
            icon: AnimatedIcons.menu_close,
            // size: PlatformInfo.screenAwareWidth(23),
            size: SizeConfig.screenAwareWidth(7),
          ),
          onTap: () {
            if (controller.status == AnimationStatus.completed) {
              controller.reverse();
            } else if (controller.status == AnimationStatus.dismissed) {
              controller.forward();
            }
          },
        ),
      ),
    );
  }
}
