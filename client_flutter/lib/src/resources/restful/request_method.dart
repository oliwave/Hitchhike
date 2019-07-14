import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;

/// The abstract class that defines the interface of the http request
/// behavior, and all subclasses that inherit from it must implement
/// the particular content of the [request] method.
abstract class RequestMethod {
  final Client _client = Client();
  final _rootUrl = 'https://api.hitchhike.ml';

  /// Implement your http request code down here!
  Future<Response> request();
}

/// To verify whether the [userId] is one of the ncnu members.
///
/// Return the hash validation code in hex.
class VerifyUserIdRequest extends RequestMethod {
  VerifyUserIdRequest._(
    this.userId,
  );

  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  factory VerifyUserIdRequest({
    @required String userId,
  }) {
    if (_verifyUserId == null) {
      _verifyUserId = VerifyUserIdRequest._(userId);
    } else {
      _verifyUserId.userId = userId;
    }
    return _verifyUserId;
  }

  static VerifyUserIdRequest _verifyUserId;
  String userId;

  @override
  Future<Response> request() async {
    final response = await _client.get(
      '$_rootUrl/verify/$userId',
    );

    return response;
  }
}

/// Sign up an user
class SignUpRequest extends RequestMethod {
  SignUpRequest._(
    this.userId,
    this.password,
    this.username,
  );

  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  factory SignUpRequest({
    @required String userId,
    @required String password,
    @required String username,
  }) {
    if (_signUp == null) {
      _signUp = SignUpRequest._(userId, password, username);
    } else {
      _signUp.userId = userId;
      _signUp.password = password;
      _signUp.username = username;
    }
    return _signUp;
  }

  static SignUpRequest _signUp;
  String userId;
  String password;
  String username;

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/signUp/$userId/$password/$username',
    );
    return response;
  }
}

/// Login
class LoginRequest extends RequestMethod {
  LoginRequest._(
    this.userId,
    this.password,
  );

  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  factory LoginRequest({
    @required String userId,
    @required String password,
  }) {
    if (_login == null) {
      _login = LoginRequest._(userId, password);
    } else {
      _login.userId = userId;
      _login.password = password;
    }
    return _login;
  }

  static LoginRequest _login;
  String userId;
  String password;

  @override
  Future<Response> request() async {
    final response = await _client.get('$_rootUrl/login/$userId/$password');

    // need to return jwt on http headers
    return response;
  }
}
