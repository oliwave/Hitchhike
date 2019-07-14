import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [SecureStorage] is used for saving sensitive information in local.
class SecureStorage {

  SecureStorage._();

  factory SecureStorage() {
    return _secureStorage;
  }

  static final _secureStorage = SecureStorage._();
  static final storage = FlutterSecureStorage();

  Future<void> storeJWT(String jwt) async {
    return await storage.write(key: 'jwt', value: jwt);
  }

  Future<String> getJWT() async {
    return await storage.read(key: 'jwt');
  }

  Future<void> storePwd(String pwd) async {
    return await storage.write(key: 'pwd', value: pwd);
  }

  Future<String> getPwd() async {
    return await storage.read(key: 'pwd');
  }
  
}
