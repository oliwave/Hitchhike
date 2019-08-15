/// WARNING : Developers have to manually modify the source code in both
/// [flutter_google_places] and [google_maps_webservice] packages,
/// because the default UI of the autocomplete dialog doesn't fit
/// our needs.
///
/// See https://hackmd.io/z0H-ESBKR1OU3cA4D1Ta8A
import 'package:flutter/material.dart';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

import '../../model/order_info.dart';
import '../../util/util_collection.dart' show Uuid, PlacesHandler;

import '../notify_manager.dart';

/// [AutocompleteManager] is responsible for processing the logic of
/// Google Places Autocomplete API.
class AutocompleteManager extends NotifyManager {
  AutocompleteManager(notifyListeners) : super(notifyListeners);

  final OrderInfo _orderInfo = OrderInfo();

  /// Holds the reference of google places api key.
  final PlacesHandler _placesHandler = PlacesHandler();

  /// It's the status of the [currentPositionButton] and determines
  /// if client is using the current location for ordering.
  bool _usingCurrentLocation = true;

  /// To judge if client is using current location for ordering.
  bool get usingCurrentLocation => _usingCurrentLocation;

  /// To judge if client is using current location for ordering.
  set usingCurrentLocation(bool using) {
    _usingCurrentLocation = using;
    notifyListeners();
  }

  /// Trigger places autocomplete.
  ///
  /// [context] is used to build a ListView in current screen.
  /// [target] is used to judge which kind of [SearchField] it is.
  /// [futurePosition] is used to provide clients with more accurate
  /// search results based on current location.
  Future<void> startAutocomplete({
    @required BuildContext context,
    @required String target,
    @required Future<Position> futurePosition,
  }) async {
    final token = Uuid().generateV4();
    // final key = await _getPlacesApiKey(); // uncomment this when api key development is done.
    final key = 'AIzaSyB9Ht6FmmPwYbY87YDtM-Krno95W3ozqmM';

    print('places api key is ${PlacesHandler().placesKey}');

    print('The stage of Places autocomplete!!!');

    final position = await futurePosition;

    print('Places Autocomplete latitude : ${position.latitude}');
    print('Places Autocomplete longitude : ${position.longitude}');

    final prediction = await PlacesAutocomplete.show(
      apiKey: key,
      sessionToken: token,
      context: context,
      mode: Mode.overlay,
      location: Location(position.latitude, position.longitude),
      origin: Location(position.latitude, position.longitude),
      radius: 1000, // 1km
      language: 'zh-TW',
      components: [Component(Component.country, 'tw')],
    );

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

        // Notify currentLocationButton in _SearchField not to use
        // current location for ordering.
        usingCurrentLocation = false;
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

  /// [useCurrentLocation] method triggered in the onTap callback of 
  /// [_CurrentLocationButton] is responsible for handling the status of 
  /// button. 
  Future<void> useCurrentLocation({
    @required Future<Position> futurePosition,
  }) async {
    if (!usingCurrentLocation) {
      usingCurrentLocation = true;
      _orderInfo.nameStart = null;

      print('Use current location for address order!');

      final position = await futurePosition;

      _orderInfo.geoStart = Location(position.latitude, position.longitude);
    }
    print('onTap');
  }
}
