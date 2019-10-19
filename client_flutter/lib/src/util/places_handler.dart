import 'package:http/http.dart';

import '../../src/resources/repository.dart';
import '../../src/resources/restful/request_method.dart'
    show PlacesApiKeyRequest;

/// [PlacesHandler] have reference to Google Places Api key.
class PlacesHandler {
  PlacesHandler._() {
    // _init();
    print('Initialize the PlacesHandler!');

    test();
  }

  factory PlacesHandler() {
    return _placesHandler;
  }

  static final _placesHandler = PlacesHandler._();

  static final _api = Repository.getApi;

  String _placesKey;

  String get placesKey => _placesKey;

  void _init() {
    if (_placesKey != null) {
      print('PlacesHandler had been initialized since the app was launched!');
      return;
    }

    _requestPlacesApiKey().then((response) {
      print('response.body : ${response['statusCode']}');

      // final Map<String, dynamic> parsedJson = json.decode(response.body);

      // return parsedJson['key'];

      _placesKey = 'FAKE_PLACES_API_KEY';
      print('PlacesHandler has been resolved !!!');
    });
  }

  /// TODO : I need a bool type [hasJwtToken] in AuthProvider to check if
  /// the client has a jwt token locally. Return null value if not.

  /// Call the [_requestPlacesApiKey] to access places api key from server.
  Future<Map<String, dynamic>> _requestPlacesApiKey() {
    final response = _api.sendHttpRequest(
      PlacesApiKeyRequest(
        // AuthProvider().jwtToken
        jwtToken: 'Get jwt Token from AuthProvider',
      ),
    );

    return response;
  }

  void test() {
    Future(() {
      print('places_handler!!!!!!!!!!!!');
    });
  }
}
