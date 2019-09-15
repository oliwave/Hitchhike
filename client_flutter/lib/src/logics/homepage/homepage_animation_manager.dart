import 'package:flutter/material.dart';

import '../notify_manager.dart';

/// Every animation in Homepage will be managed in this class.
class HomepageAnimationManager extends NotifyManager {
  HomepageAnimationManager(
    VoidCallback notifyListeners,
  ) : super(notifyListeners);

  /// Enable the bottom sheet to animate its heitght.
  AnimationController bottomSheetHeightController;

  AnimationController bottomSheetOpacityController;

  /// Enable the customized [PositionFloatingActionButton] to animate its height
  /// when the [bottomSheetController] call the method of foreword or reverse.
  AnimationController positionButtonController;

  AnimationController favoriteButtonController;

  /// Enable the [LocationAppBar] to animate its height when the
  /// [bottomSheetController] call the method of foreword or reverse.
  AnimationController appBarController;

  /// Use boolean value to switch the UI between [RoleNavigatorBar]
  /// and [OrderPanel].
  bool isOrderPanel = false;

  // /// It is used to switch the bottom sheet.
  // bool get isOrderPanel => _isOrderPanel;

  // /// It is used to switch the bottom sheet.
  // set isOrderPanel(bool isOrderPanel) {
  //   _isOrderPanel = isOrderPanel;
  //   // notifyListeners();
  // }

  Future<void> showPanelHideBar() async {
    isOrderPanel = true;
    positionButtonController.forward();
    favoriteButtonController.forward();
    appBarController.forward();
    notifyListeners();
    await bottomSheetHeightController.forward();
    bottomSheetOpacityController.forward();
  }

  Future<void> showBarHidePanel() async {
    isOrderPanel = false;
    positionButtonController.reverse();
    favoriteButtonController.reverse();
    appBarController.reverse();
    bottomSheetOpacityController.reverse();
    bottomSheetHeightController.reverse();
    notifyListeners();
  }
}
