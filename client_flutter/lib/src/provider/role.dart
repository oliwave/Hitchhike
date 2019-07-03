import 'package:flutter/material.dart';

/// Recording the current client information
/// 
/// The [isMatched] is used to judge whether the client is in the matched mode. And
/// if the client is in the matched mode, the [isDriver] can determine what role the 
/// client is.
class Role extends ChangeNotifier {
  bool _isMatched;
  bool _isDriver;

  bool get isMatched => _isMatched;
  bool get isDriver => _isDriver;

  
}