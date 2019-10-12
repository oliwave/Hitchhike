import 'package:client_flutter/src/provider/local/homepage_provider.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  AnimationController menuHeightController;

  bool _menuVisible = false;

  double _menuOpacity = 0.0;

  final _menuListData = <Map<IconData, String>>[
    {Icons.chat_bubble_outline: '聊天'},
    {Icons.perm_identity: '編輯個人'},
    {Icons.settings: '設定'},
  ];

  bool get menuVisible => _menuVisible;

  double get menuOpacity => _menuOpacity;

  List<Map<IconData, String>> get menuListData => _menuListData;

  set menuOpacity(double opacity) {
    _menuOpacity = opacity;
    notifyListeners();
  }

  void setMenuVisible(bool visible, HomepageProvider homeProvider) async {
    _menuVisible = visible;
    if (_menuVisible) {
      await Future.wait([
        menuHeightController.forward(),
        homeProvider.animationManager.bottomSheetOpacityController.forward()
      ]);

      menuOpacity = 1;
      homeProvider.animationManager.bottomSheetHeightByMenuController.forward();
    } else {
      menuOpacity = 0;
      menuHeightController.reverse();

      await homeProvider.animationManager.bottomSheetHeightByMenuController
          .reverse();
      homeProvider.animationManager.bottomSheetOpacityController.reverse();
    }

    homeProvider.animationManager.menuTriggered = true;

    notifyListeners();
  }
}
