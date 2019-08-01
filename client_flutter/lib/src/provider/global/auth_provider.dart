import 'package:flutter/material.dart';

import '../../resources/repository.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider._();

  factory AuthProvider() {
    return _auth;
  }

  static final _auth = AuthProvider._();
  static final _secure = Repository.getSecureStorage;
  static final _api = Repository.getApi;
}
