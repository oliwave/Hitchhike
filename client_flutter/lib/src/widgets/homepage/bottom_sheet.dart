import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart';
import '../../util/platform_info.dart';

import './role_navigator_bar.dart';
import './order_panel.dart';

class HomepageBottomSheet extends StatefulWidget {
  @override
  _HomepageBottomSheetState createState() => _HomepageBottomSheetState();
}

class _HomepageBottomSheetState extends State<HomepageBottomSheet>
    with SingleTickerProviderStateMixin {
  AnimationController _bottomSheetController;
  Animation<double> _sheetHeightAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    print('AnimtionController is in initState!!!');

    _bottomSheetController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    CurvedAnimation curvedAnimation = CurvedAnimation(
      curve: Curves.ease,
      parent: _bottomSheetController,
      reverseCurve: Curves.ease,
    );

    _sheetHeightAnimation = curvedAnimation.drive(Tween<double>(
      begin: PlatformInfo.screenAwareSize(60),
      end: PlatformInfo.screenAwareSize(250),
    ));

    curvedAnimation = CurvedAnimation(
      curve: Curves.easeIn,
      parent: _bottomSheetController,
      reverseCurve: Curves.easeOut,
    );

    _opacityAnimation = curvedAnimation.drive(
      Tween<double>(
        begin: 1,
        end: 0,
      ),
    );

    final state = Provider.of<HomepageProvider>(context, listen: false);

    // 'sheetHeightAnimation' and 'opacityAnimation' are triggered at
    // very deep widget tree. Therefore, we hold the reference of
    // 'AnimationController' in 'HomepageProvider'.
    state.bottomSheetController = _bottomSheetController;

    super.initState();
  }

  @override
  void dispose() {
    print('AnimationController has been disposed!!!');
    // Controller should be dispose before the ticker was disposed,
    // because it may cause memory leak.
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Refreshing HomepageBottomSheetState ... ');

    return AnimatedBuilder(
      animation: _sheetHeightAnimation,
      builder: (BuildContext context, Widget bottomSheetContent) {
        return Container(
          // The decoration of bottom sheet
          height: _sheetHeightAnimation.value,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(PlatformInfo.screenAwareSize(50)),
              topRight: Radius.circular(PlatformInfo.screenAwareSize(50)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 3,
              )
            ],
          ),
          // The content of bottomSheet
          child: bottomSheetContent,
        );
      },
      child: Consumer<HomepageProvider>(
        builder: (_, HomepageProvider value, Widget panel) {
          // To determine which view should show on the screen.
          return value.isOrderPanel
              ? panel
              : RoleNavigatorBar(
                  opacityAnimation: _opacityAnimation,
                );
        },
        child: OrderPanel(
          opacityAnimation: _opacityAnimation,
        ),
      ),
    );
  }
}
