import 'dart:convert';
import 'dart:io';

import 'package:client_flutter/src/model/order_info.dart';
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
    if (jwtToken != null) {
      print('verify with jwtToken');
      return {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: jwtToken,
      };
    } else {
      print('verify without jwtToken');
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

class IdentifyRegisteredIDRequest extends BasePost {
  IdentifyRegisteredIDRequest({
    @required String userId,
  }) : super(body: {
          'uid': userId,
        });

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/identify',
      body: json.encode(body),
      headers: getHeaders(),
    );

    return response;
  }
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
          'uid': userId,
        });

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/verify',
      body: json.encode(body),
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
    @required int gender,
    @required String birthday,
  }) : super(body: {
          'uid': userId,
          'pwd': password,
          'name': username,
          'gender': gender,
          'birthday': birthday,
        });

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/signUp',
      body: json.encode(body),
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
          'uid': userId,
          'pwd': password,
        });

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/login',
      body: json.encode(body),
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
            'pwd': password,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profilePwd',
      body: json.encode(body),
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
            'name': name,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profileName',
      body: json.encode(body),
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
            'photo': photo,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profilePhoto',
      body: json.encode(body),
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
            'department': department,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profileDepartment',
      body: json.encode(body),
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
            'carNum': carNum,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profileCarNum',
      body: json.encode(body),
      headers: getHeaders(),
    );
    return response;
  }
}

class ProfileBirthdayRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  ProfileBirthdayRequest({
    @required String birthday,
    @required String jwtToken,
  }) : super(
          body: {
            'birthday': birthday,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/profileBirthday',
      body: json.encode(body),
      headers: getHeaders(),
    );
    return response;
  }
}

class PassengerRouteRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [RequestMethod].
  PassengerRouteRequest({
    @required OrderInfo orderInfo,
    @required String jwtToken,
  }) : super(
          body: {
            'originY': orderInfo.geoStart.lat,
            'originX': orderInfo.geoStart.lng,
            'destinationY': orderInfo.geoEnd.lat,
            'destinationX': orderInfo.geoEnd.lng,
            'originName': orderInfo.nameStart,
            'destinationName': orderInfo.nameEnd,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/passenger_route',
      body: json.encode(body),
      headers: getHeaders(),
    );

    return response;
  }
}

class OrderConfirmationRequest extends RequestMethod {
  OrderConfirmationRequest({
    @required this.status,
    @required String jwtToken,
  }) : super(
          jwtToken: jwtToken,
        );

  final String status;

  @override
  Future<Response> request() async {
    final response = await _client.get(
      '$_rootUrl/orderConfirmation/$status',
      headers: getHeaders(),
    );

    return response;
  }
}

class DriverRouteRequest extends BasePost {
  /// Create an intance of a concrete http request behavior that
  /// inherits [BasePost].
  DriverRouteRequest({
    @required OrderInfo orderInfo,
    @required String jwtToken,
  }) : super(
          body: {
            'originY': orderInfo.geoStart.lat,
            'originX': orderInfo.geoStart.lng,
            'destinationY': orderInfo.geoEnd.lat,
            'destinationX': orderInfo.geoEnd.lng,
            'originName': orderInfo.nameStart,
            'destinationName': orderInfo.nameEnd,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/driver_route',
      body: json.encode(body),
      headers: getHeaders(),
    );

    return response;
  }
}

class FetchPairedDataRequest extends BasePost {
  FetchPairedDataRequest({
    @required String driverId,
    @required String jwtToken,
  }) : super(
          body: {
            'uid': driverId,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() async {
    final response = await _client.post(
      '$_rootUrl/fetchPairedData',
      body: json.encode(body),
      headers: getHeaders(),
    );

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
    final response = await _client.get('$_rootUrl/places');

    return response;
  }
}

class FcmTokenRequest extends BasePost {
  FcmTokenRequest({
    @required String jwtToken,
    @required String fcmToken,
  }) : super(
          body: {
            'fcmToken': fcmToken,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/fcmToken',
      body: json.encode(body),
      headers: getHeaders(),
    );

    return response;
  }
}

class GetUserInfoRequest extends BasePost {
  GetUserInfoRequest({
    @required String jwtToken,
  }) : super(
          body: {},
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/userInfo',
      body: json.encode(body),
      headers: getHeaders(),
    );

    return response;
  }
}

class GetUserDeviceRequest extends RequestMethod {
  GetUserDeviceRequest({
    @required String jwtToken,
  }) : super(
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.get(
      '$_rootUrl/getDevice',
      headers: getHeaders(),
    );

    return response;
  }
}

class SetUserDeviceRequest extends BasePost {
  SetUserDeviceRequest({
    @required String currentDevice,
    @required String jwtToken,
  }) : super(
          body: {
            'device': currentDevice,
          },
          jwtToken: jwtToken,
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/setDevice',
      body: json.encode(body),
      headers: getHeaders(),
    );

    return response;
  }
}

class GetUserStateRequest extends BasePost {
  GetUserStateRequest({
    @required String userID,
  }) : super(
          body: {
            'uid': userID,
          },
        );

  @override
  Future<Response> request() {
    final response = _client.post(
      '$_rootUrl/userState',
      body: json.encode(body),
      headers: getHeaders(),
    );

    return response;
  }
}
