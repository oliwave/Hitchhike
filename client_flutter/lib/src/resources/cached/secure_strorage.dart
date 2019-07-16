import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [SecureStorage] is used for saving sensitive information in local.
class SecureStorage {
  SecureStorage._();

  factory SecureStorage() {
    return _secureStorage;
  }

  static final _secureStorage = SecureStorage._();
  static final storage = FlutterSecureStorage();

  Future<void> storeSecret(String target, String value) async {
    return await storage.write(key: target, value: value);
  }

  Future<String> getSecret(String target) async {
    return await storage.read(key: target);
  }

}
