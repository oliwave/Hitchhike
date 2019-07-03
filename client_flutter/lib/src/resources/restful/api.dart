import 'package:http/http.dart' show Client;

final _rootUrl = 'https://api.hitchhike.ml';

/// The restful api on our server is triggered by the http request.
class Api {
  final client = Client();

  static final _api = Api._();

  static Api getInstance() {
    return _api;
  }

  Api._();

  /// To verify whether the [userId] is the ncnu member.
  ///
  /// return the hased validated code in hex.
  Future<String> verifyUserId(String userId) async {
    final response = await client.get('$_rootUrl/verify/$userId');
    return response.body;
  }

  /// Sign up an user
  Future<int> signUp(String userId, String password, String username) async {
    final response =
        await client.post('$_rootUrl/signUp/$userId/$password/$username');
    return response.statusCode;
  }

  /// Login
  Future<int> login(String userId, String password) async {
    final response = await client.get('$_rootUrl/login/$userId/$password');

    // need to return jwt on http headers
    return response.statusCode;
  }
}
