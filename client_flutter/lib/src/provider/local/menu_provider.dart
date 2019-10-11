import 'package:client_flutter/src/provider/local/homepage_provider.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  bool _menuVisible = false;

  final _menuListData = <Map<IconData, String>>[
    {Icons.chat_bubble_outline: '聊天'},
    {Icons.perm_identity: '編輯個人'},
    {Icons.settings: '設定'},
  ];

  bool get menuVisible => _menuVisible;

  List<Map<IconData, String>> get menuListData => _menuListData;

  void setMenuVisible(bool visible, HomepageProvider homeProvider) async {
    _menuVisible = visible;

    if (_menuVisible) {
      await homeProvider.animationManager.bottomSheetOpacityController
          .forward();
      homeProvider.animationManager.bottomSheetHeightByMenuController.forward();
    } else {
      await homeProvider.animationManager.bottomSheetHeightByMenuController
          .reverse();
      homeProvider.animationManager.bottomSheetOpacityController.reverse();
    }

    homeProvider.animationManager.menuTriggered = true;

    print(visible);

    notifyListeners();
  }
}


