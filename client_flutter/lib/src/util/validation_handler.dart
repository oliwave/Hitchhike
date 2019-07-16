import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

/// [ValidationHandler] can help client to manipulate the existing
/// hash validation code.
class ValidationHandler {
  const ValidationHandler._();

  factory ValidationHandler() {
    return _validationHandler;
  }

  static final _validationHandler = ValidationHandler._();

  /// For instance, client can use [verifySixDigitsCode] to check whether
  /// the [hashedSixDigits] is the same value as [rawSixDigits] after hashing.
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

/// The class that holds the hash validation code in run time only.
/// 
/// That is, when user closes the app at the stage of validating the membership of
/// ncnu , user has .....
class HashValidationCode {
  HashValidationCode._();

  factory HashValidationCode() {
    return _hashValidationCode;
  }

  static final _hashValidationCode = HashValidationCode._();

  String _hashedSixDigits;
  DateTime _getHashCodeTime;

  void setCode(String data) {
    _getHashCodeTime = DateTime.now();
    _hashedSixDigits = data;
  }

  String getCode() {
    return _hashedSixDigits;
  }

  String getHashCodeTime() {
    return _getHashCodeTime.toString();
  }
}
