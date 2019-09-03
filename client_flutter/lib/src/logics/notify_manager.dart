import 'package:flutter/material.dart';

/// The abstract class that defines the basic [notifyListeners] callback.
///
/// Every subclass inheriting [NotifyManager] should pass a callback function
/// that invoke [notifyListener()].
abstract class NotifyManager {
  NotifyManager(this.notifyListeners);

  final VoidCallback notifyListeners;
}
