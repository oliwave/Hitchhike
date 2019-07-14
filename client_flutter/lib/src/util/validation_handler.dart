import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ValidationHandler {
  ValidationHandler._();

  factory ValidationHandler() {
    return _validationHandler;
  }

  static final _validationHandler = ValidationHandler._();

  bool verifySixDigitsCode({
    @required String rawSixDigits,
    @required String hashedSixDigits,
  }) {
    if (rawSixDigits.length != 6) {
      return false;
    }

    List<int> bytes = utf8.encode(rawSixDigits);
    final digest = sha256.convert(bytes);

    print(bytes);
    print(digest);

    // print(base64.encode(digest.bytes));
    return digest.toString() == hashedSixDigits ? true : false;
  }
}

class HashValidationCode {
  HashValidationCode._();

  factory HashValidationCode() {
    return _hashValidationCode;
  }

  static final _hashValidationCode = HashValidationCode._();

  String _hashedSixDigits;

  void setCode(String data) {
    _hashedSixDigits = data;
  }

  String getCode() {
    return _hashedSixDigits;
  }
}
