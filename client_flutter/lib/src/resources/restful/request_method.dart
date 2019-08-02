import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;

/// The abstract class that defines the interface of the http request
/// behavior, and all subclasses that inherit from it must implement
/// the particular content of the [request] method.
abstract class RequestMethod {
  RequestMethod({this.jwtToken});

  final Client _client = Client();

  /// [_rooturl] is the target server that client wants to interact with.
  final _rootUrl = 'https://api.hitchhike.ml';

  /// Except login and sign up requests, rest of the requests need to
  /// contain [jwtToken]
  String jwtToken;

  /// Implement your http request code down here!
  Future<Response> request();

  /// [getHeaders] enables client to get different content of headers depends on
  /// whether thers is value assigned to [jwtToken].
  Map<String, String> getHeaders() {
    if (jwtToken == null) {
      return {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: jwtToken,
      };
    } else {
      return {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
    }
  }
}

/// This abstract class defining the basic function for POST request, such as
/// setting the content of a [body]. And it also inherit the [RequestMethod].
abstract class BasePost extends RequestMethod {
  BasePost({
    @required this.body,
    String jwtToken,
  }) : super(
          jwtToken: jwtToken,
        );

  /// Using as request body.
  Map<String, dynamic> body;

  @override
  Future<Response> request();
}

/// To verify whether the [userId] is one of the ncnu members.
///
/// Return the hash validation code in hex.
class VerifyUserIdRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  VerifyUserIdRequest({
    @required String userId,
  }) : super(body: {
          userId: userId,
        });

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/verify',
      body: body,
      headers: getHeaders(),
    );

    return response;
  }
}

/// Sign up an user
class SignUpRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  SignUpRequest({
    @required String userId,
    @required String password,
    @required String username,
  }) : super(body: {
          userId: userId,
          password: password,
          username: username,
        });

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/signUp',
      body: body,
      headers: getHeaders(),
    );
    return response;
  }
}

/// Login
class LoginRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  LoginRequest({
    @required String userId,
    @required String password,
  }) : super(body: {
          userId: userId,
          password: password,
        });

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/login',
      body: body,
      headers: getHeaders(),
    );

    // need to return jwt on http headers
    return response;
  }
}

class ProfilePwdRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  ProfilePwdRequest({
    @required String password,
    @required String jwtToken,
  }) : super(
          body: {
            password: password,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profilePwd',
      body: body,
      headers: getHeaders(),
    );

    return response;
  }
}

class ProfileNameRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  ProfileNameRequest({
    @required String name,
    @required String jwtToken,
  }) : super(
          body: {
            name: name,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profileName',
      body: body,
      headers: getHeaders(),
    );

    return response;
  }
}

class ProfilePhotoRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  ProfilePhotoRequest({
    @required String photo,
    @required String jwtToken,
  }) : super(
          body: {
            photo: photo,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profilePhoto',
      body: body,
      headers: getHeaders(),
    );

    return response;
  }
}

class ProfileDepartmentRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  ProfileDepartmentRequest({
    @required String department,
    @required String jwtToken,
  }) : super(
          body: {
            department: department,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profileDepartment',
      body: body,
      headers: getHeaders(),
    );

    return response;
  }
}

class ProfileCarNumRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  ProfileCarNumRequest({
    @required String carNum,
    @required String jwtToken,
  }) : super(
          body: {
            carNum: carNum,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profileCarNum',
      body: body,
      headers: getHeaders(),
    );
    return response;
  }
}

class PassengerRouteRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  PassengerRouteRequest({
    @required double originX,
    @required double originY,
    @required double destinationX,
    @required double destinationY,
    @required String jwtToken,
  }) : super(
          body: {
            'originX': originX,
            'originY': originY,
            'destinationX': destinationX,
            'destinationY': destinationY,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() async {
    final parsedJson = json.encode(body);

    final response = await _client.post('$_rootUrl/passengerRoute',
        body: parsedJson, headers: getHeaders());

    return response;
  }
}

class DriverRouteRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [BasePost].
  DriverRouteRequest({
    @required double originX,
    @required double originY,
    @required double destinationX,
    @required double destinationY,
    @required String jwtToken,
  }) : super(
          body: {
            'originX': originX,
            'originY': originY,
            'destinationX': destinationX,
            'destinationY': destinationY,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() async {
    final parsedJson = json.encode(body);

    final response = await _client.post('$_rootUrl/driverRoute',
        body: parsedJson, headers: getHeaders());

    return response;
  }
}

class PlacesApiKeyRequest extends RequestMethod {
  PlacesApiKeyRequest({
    @required String jwtToken,
  }) : super(
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() async {
    final response = await _client.get('$_rootUrl/key');

    return response;
  }
}
