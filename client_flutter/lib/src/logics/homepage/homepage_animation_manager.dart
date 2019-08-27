import 'package:flutter/material.dart';

import '../notify_manager.dart';

/// Every animation in Homepage will be managed in this class.
class HomepageAnimationManager extends NotifyManager {
  HomepageAnimationManager(
    VoidCallback notifyListeners,
  ) : super(notifyListeners);

  /// Enable the bottom sheet to animate its heitght.
  AnimationController bottomSheetController;

  /// Enable the customized [PositionFloatingActionButton] to animate its height
  /// when the [bottomSheetController] call the method of foreword or reverse.
  AnimationController positionButtonController;

  AnimationController favoriteButtonController;

  /// Enable the [LocationAppBar] to animate its height when the
  /// [bottomSheetController] call the method of foreword or reverse.
  AnimationController appBarController;

  /// Use boolean value to switch the UI between [RoleNavigatorBar]
  /// and [OrderPanel].
  bool _isOrderPanel = false;

  /// It is used to switch the bottom sheet.
  bool get isOrderPanel => _isOrderPanel;

  /// It is used to switch the bottom sheet.
  set isOrderPanel(bool isOrderPanel) {
    _isOrderPanel = isOrderPanel;
    notifyListeners();
  }

  void showPanelHideBar() {
    isOrderPanel = true;
    bottomSheetController.forward();
    positionButtonController.forward();
    favoriteButtonController.forward();
    appBarController.forward();
  }

  void showBarHidePanel() {
    bottomSheetController.reverse();
    positionButtonController.reverse();
    favoriteButtonController.reverse();
    appBarController.reverse();
    isOrderPanel = false;
  }
}
