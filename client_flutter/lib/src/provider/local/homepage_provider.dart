import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import '../../model/order_info.dart';
import '../../resources/repository.dart';
import '../../resources/restful/request_method.dart';
import '../../util/uuid.dart';

class HomepageProvider with ChangeNotifier {
  HomepageProvider() {
    // init();
  }

  /// [init] method is used for getting the reference of [_placesApiKey].
  void init() async {
    /// TODO : I need a bool type [hasJwtToken] in AuthProvider to check if
    /// the client has a jwt token locally. Return null value if not.
    _placesApiKey = await _requestPlacesApiKey();
  }

  static final _api = Repository.getApi;

  /// Enable the bottom sheet to animate its heitght.
  AnimationController bottomSheetController;

  /// Enable the customized [PositionFloatingActionButton] to animate its height
  /// when the [bottomSheetController] call the method of foreword or reverse.
  AnimationController floatingButtonController;

  /// Enable the [LocationAppBar] to animate its height when the
  /// [bottomSheetController] call the method of foreword or reverse.
  AnimationController appBarController;

  /// Use boolean value to switch the UI between [RoleNavigatorBar]
  /// and [OrderPanel].
  bool _isOrderPanel = false;

  /// Don't explicitly access [_placesApiKey]. Instead, call [_getPlacesApiKey]
  /// method to retrieve the key.
  String _placesApiKey;

  /// Used to detect whether the google map has been dragged.
  bool _hasMoved = false;

  /// WARNING : Only for testing
  bool _hasInfo = false;

  /// The object that records some geo-relative information.
  final OrderInfo _orderInfo = OrderInfo();

  /// It is used to switch the bottom sheet.
  bool get isOrderPanel => _isOrderPanel;

  bool get hasMoved => _hasMoved;

  /// WARNING : Only for testing
  bool get hasInfo => _hasInfo;

  set hasMoved(bool moved) {
    _hasMoved = moved;
    notifyListeners();
  }

  /// WARNING : Only for testing
  changeHasInfo() {
    _hasInfo = !hasInfo;
    notifyListeners();
  }

  /// It is used to switch the bottom sheet.
  set isOrderPanel(bool isOrderPanel) {
    _isOrderPanel = isOrderPanel;
    notifyListeners();
  }

  OrderInfo get orderInfo => _orderInfo;

  /// Trigger places autocomplete.
  /// 
  /// [target]
  Future<void> startAutocomplete(BuildContext context, String target) async {
    final token = Uuid().generateV4();
    // final key = await _getPlacesApiKey(); // uncomment this when api key development is done.
    final key = 'AIzaSyB9Ht6FmmPwYbY87YDtM-Krno95W3ozqmM';

    print('The stage of Places autocomplete!!!');

    final prediction = await PlacesAutocomplete.show(
      apiKey: key,
      sessionToken: token,
      context: context,
      mode: Mode.overlay,
      // location: null,
      language: 'zh-TW',
      components: [Component(Component.country, 'tw')],
    );

    /// WARNING : You have to manually debug by adding '?' before line 567 to 569
    /// at [places.dart] in [google_maps_webservice] package.
    ///
    /// ```dart=
    /// ?.map((addr) => AddressComponent.fromJson(addr)) // My modification.
    /// ?.toList() // My modification.
    /// ?.cast<AddressComponent>(), // My modification.
    /// ```
    if (prediction != null) {
      print('Retrieve details to get lat and lng!!!');
      final detail = await GoogleMapsPlaces(apiKey: key).getDetailsByPlaceId(
        prediction.placeId,
        sessionToken: token,
        language: 'zh-TW',
        fields: ['geometry', 'name'],
      );

      if (target != '終點') {
        _orderInfo.nameStart = detail.result.name;
        _orderInfo.geoStart = detail.result.geometry.location;
      } else {
        _orderInfo.nameEnd = detail.result.name;
        _orderInfo.geoEnd = detail.result.geometry.location;
      }

      notifyListeners();

      print(
        'name: ${detail.result.name}'
        'lng: ${detail.result.geometry.location.lng},'
        'lat: ${detail.result.geometry.location.lat}',
      );
    }
  }

  /// Always retrieve the key by calling this method.
  Future<String> _getPlacesApiKey() async {
    if (_placesApiKey == null) {
      _placesApiKey = await _requestPlacesApiKey();
    }
    return _placesApiKey;
  }

  /// Call the [_requestPlacesApiKey] to access places api key from server.
  Future<String> _requestPlacesApiKey() async {
    final response = await _api.sendHttpRequest(
      PlacesApiKeyRequest(
        // AuthProvider().jwtToken
        jwtToken: 'Get jwt Token from AuthProvider',
      ),
    );

    final Map<String, dynamic> parsedJson = json.decode(response.body);

    return parsedJson['key'];
  }
}
