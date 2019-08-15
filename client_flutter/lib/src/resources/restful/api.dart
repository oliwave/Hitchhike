import 'package:http/http.dart' show Response;

import './request_method.dart';

/// This class manages every http request from our client to server.
class Api {
  Api._();

  factory Api() {
    return _api;
  }

  static final Api _api = Api._();

  /// Send a specific http request assigned by the client to our server.
  ///
  /// Assign an instance of the inherited [RequestMethod] to [action].
  /// This technique utilized the concept of upcasting in OO to implement
  /// the polymorphism.
  ///
  /// e.g., [VerifyUserId], [SignUp], etc. are all instances that is defined
  /// in [request_method.dart] that actually call http api.
  Future<Response> sendHttpRequest(RequestMethod action) async {
    final response = await action.request();

    // print('Let me check : ${response.body}');

    return response;
  }
}
