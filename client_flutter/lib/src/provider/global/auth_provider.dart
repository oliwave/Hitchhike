import 'dart:convert';

import 'package:flutter/material.dart';

import '../../resources/repository.dart';
import '../../resources/restful/request_method.dart';

class AuthProvider with ChangeNotifier {

  static final _api = Repository.getApi;

  String _placesApiKey;

  void init() async {
    _placesApiKey = await placesApiKey();
  }

  String get getPlacesApiKey => _placesApiKey;

  Future<String> placesApiKey() async {
    final response = await _api.sendHttpRequest(
      PlacesApiKeyRequest(
        jwtToken: '',
      ),
    );

    final parsedJson = json.decode(response.body);

    return parsedJson['key'];
  }

}
