import 'package:flutter/material.dart';

import '../../logics/homepage/homepage_animation_manager.dart';
import '../../logics/homepage/order_manager.dart';
import '../../logics/homepage/autocomplete_manager.dart';

class HomepageProvider with ChangeNotifier {
  HomepageProvider._() {
    _managerInit();
  }

  factory HomepageProvider() => _homepageprovider;

  static final HomepageProvider _homepageprovider = HomepageProvider._();

  /// The class that tackles the logic of homepage animation.
  HomepageAnimationManager _homepageAnimationManager;

  OrderManager _orderManager;

  AutocompleteManager _autocompleteManager;

  /// WARNING : Only for testing
  bool _hasInfo = false;

  bool _mapFirstRendered = true;

  /// Client can launch homepage animation with [HomepageAnimationManager].
  HomepageAnimationManager get animationManager => _homepageAnimationManager;

  OrderManager get orderManager => _orderManager;

  AutocompleteManager get autocompleteManager => _autocompleteManager;

  /// WARNING : Only for testing
  bool get hasInfo => _hasInfo;

  bool get mapFirstRendered {
    bool temp = false;
    if (_mapFirstRendered) {
      temp = _mapFirstRendered;
      _mapFirstRendered = !_mapFirstRendered;
    }
    return temp;
  }

  /// WARNING : Only for testing
  void changeHasInfo() {
    _hasInfo = !hasInfo;
    notifyListeners();
  }

  void _managerInit() {
    _homepageAnimationManager =
        HomepageAnimationManager(_registerNotifyListeners);

    _orderManager = OrderManager(_registerNotifyListeners);

    _autocompleteManager = AutocompleteManager(_registerNotifyListeners);
  }

  void _registerNotifyListeners() {
    notifyListeners();
  }
}
