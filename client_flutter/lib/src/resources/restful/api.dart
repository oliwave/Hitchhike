import 'dart:convert';

import 'package:client_flutter/src/provider/provider_collection.dart';
import 'package:http/http.dart' show Response;

import './request_method.dart' show RequestMethod;
import '../../provider/provider_collection.dart' show ConnectivityProvider;

/// This class manages every http request from our client to server.
class Api {
  Api._();

  factory Api() {
    return _api;
  }

  static final Api _api = Api._();
  static final _connect = ConnectivityProvider();

  /// Send a specific http request assigned by the client to our server.
  ///
  /// Assign an instance of the inherited [RequestMethod] to [action].
  /// This technique utilized the concept of upcasting in OO to implement
  /// the polymorphism.
  ///
  /// e.g., [VerifyUserId], [SignUp], etc. are all instances that is defined
  /// in [request_method.dart] that actually call http api.
  Future<Map<String, dynamic>> sendHttpRequest(RequestMethod action) async {
    if (!_connect.checkNetworkStatus()) return null;

    final response = await action.request();

    print('the response body is ' + response.body + ' ${action.runtimeType}');
    print('statusCode ' + '${response.statusCode}');

    Map<String, dynamic> parsedJson = {};
    if (response.statusCode == 200) {
      parsedJson = json.decode(response.body);
    }
    parsedJson['statusCode'] = response.statusCode;
    return parsedJson;
  }
}
