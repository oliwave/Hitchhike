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
    with TickerProviderStateMixin {
  AnimationController _bottomSheetHeightByItselfController;
  AnimationController _bottomSheetHeightByMenuController;
  Animation<double> _sheetHeightByItselfAnimation;
  Animation<double> _sheetHeightByMenuAnimation;
  AnimationController _bottomSheetOpacityController;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    print('AnimtionController is in initState!!!');

    _bottomSheetHeightByItselfController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _bottomSheetHeightByMenuController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _bottomSheetOpacityController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _sheetHeightByItselfAnimation = CurvedAnimation(
      curve: Curves.ease,
      parent: _bottomSheetHeightByItselfController,
      reverseCurve: Curves.ease,
    ).drive(Tween<double>(
      begin: SizeConfig.screenAwareHeight(10),
      end: SizeConfig.screenAwareHeight(40),
    ));

    _sheetHeightByMenuAnimation = CurvedAnimation(
      curve: Curves.ease,
      parent: _bottomSheetHeightByMenuController,
      reverseCurve: Curves.ease,
    ).drive(Tween<double>(
      begin: SizeConfig.screenAwareHeight(10),
      end: SizeConfig.screenAwareHeight(0),
    ));

    _opacityAnimation = CurvedAnimation(
      curve: Curves.easeIn,
      parent: _bottomSheetOpacityController,
      reverseCurve: Curves.easeOut,
    ).drive(
      Tween<double>(
        begin: 1,
        end: 0,
      ),
    );

    final provider = Provider.of<HomepageProvider>(
      context,
      listen: false,
    );

    // 'sheetHeightAnimation' and 'opacityAnimation' are triggered at
    // very deep widget tree. Therefore, we hold the reference of
    // 'AnimationController' in 'HomepageProvider'.
    provider.animationManager.bottomSheetHeightByItselfController =
        _bottomSheetHeightByItselfController;

    provider.animationManager.bottomSheetHeightByMenuController =
        _bottomSheetHeightByMenuController;

    provider.animationManager.bottomSheetOpacityController =
        _bottomSheetOpacityController;

    provider.bottomSheetContext = context;

    super.initState();
  }

  @override
  void dispose() {
    print('AnimationController has been disposed!!!');
    // Controller should be dispose before the ticker was disposed,
    // because it may cause memory leak.
    _bottomSheetHeightByItselfController.dispose();
    _bottomSheetHeightByMenuController.dispose();
    _bottomSheetOpacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Refreshing HomepageBottomSheetState ... ');

    return AnimatedBuilder(
      animation: _sheetHeightByItselfAnimation,
      builder: (BuildContext context, Widget child) {
        return AnimatedBuilder(
          animation: _sheetHeightByMenuAnimation,
          builder: (BuildContext context, Widget bottomSheetContent) {
            final provider = Provider.of<HomepageProvider>(
              context,
              listen: false,
            );

            final value = provider.animationManager.menuTriggered
                ? _sheetHeightByMenuAnimation.value
                : _sheetHeightByItselfAnimation.value;

            return Container(
              // The decoration of bottom sheet
              height: value,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  // topLeft: Radius.circular(PlatformInfo.screenAwareSize(50)),
                  // topRight: Radius.circular(PlatformInfo.screenAwareSize(50)),
                  topLeft: Radius.circular(SizeConfig.screenAwareWidth(15)),
                  topRight: Radius.circular(SizeConfig.screenAwareWidth(15)),
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
              // return value.isOrderPanel
              return Stack(
                children: <Widget>[
                  value.animationManager.isOrderPanel
                      ? panel
                      : RoleNavigatorBar(
                          opacityAnimation: _opacityAnimation,
                        ),
                ],
              );
            },
            child: OrderPanel(
              opacityAnimation: _opacityAnimation,
            ),
          ),
        );
      },
    );
  }
}
