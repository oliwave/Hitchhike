import 'dart:async';

import 'package:flutter/Material.dart';

import 'package:geolocator/geolocator.dart';

import '../../logics/notify_manager.dart';
import '../../resources/repository.dart';
import '../../provider/provider_collection.dart'
    show RoleProvider, LocationProvider;

class LocationStreamManager extends NotifyManager {
  LocationStreamManager({
    @required VoidCallback notifyListeners,
    @required LocationProvider locationProvider,
  })  : _locationProvider = locationProvider,
        super(notifyListeners);

  final LocationProvider _locationProvider;
  final _socketHandler = Repository.getSocketHandler;

  final _roleProvider = RoleProvider();
  final _geolocator = Geolocator();
  final _locationOptions = LocationOptions(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1,
  );

  /// [_driverCurrentPosition] is recorded for passenger to caculate the
  /// distance from driver.
  Position _driverCurrentPosition;

  /// WARNING : Only for testing
  Position _positionInfo;
  // LocationUpdateManager _locationUpdateManager = LocationUpdateManager();

  StreamSubscription<Position> _myPositionStream;
  StreamSubscription<Map<String, String>> _driverPositionStream;
  StreamSubscription<String> _revokePositionStream;

  /// WARNING : Only for testing
  Position get positionInfo => _positionInfo;

  /// WARNING : Only for testing
  set positionInfo(Position position) {
    _positionInfo = position;
    notifyListeners();
  }

  /// This method will subscribe the position Stream, so every time when an event
  /// emits, we have to update the google map with the latest position.
  void listenMyPositionStream() {
    _myPositionStream = _geolocator.getPositionStream(_locationOptions).listen(
      (Position position) async {
        positionInfo = position; // WARNING : Only for testing

        print('activatePositionStream has been triggered!!!\n');

        _locationProvider.locationUpdateManager.updateCharacterPosition(
          character: Character.me,
          position: position,
        );

        if (_roleProvider.isMatched &&
            !_roleProvider.hasRevokedDriverPosition) {
          if (_roleProvider.role == '司機') {
            // You are driver and passenger didn't revoke the request of
            // your current position.
            _socketHandler.emitEvent(
              eventName: SocketEventName.driverPosition,
              content: {
                'lat': '${position.latitude}',
                'lng': '${position.longitude}',
                'heading': '${position.heading}',
              },
            );
          } else {
            // You are passenger.

            // Caculate the distance between driver and passenger.
            final _distance = await _geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              _driverCurrentPosition.latitude,
              _driverCurrentPosition.longitude,
            );

            // If the distance is smaller than 5 meters, then we
            // assume that driver has meet passenger.
            if (_distance < 5.0) {
              _socketHandler.emitEvent(
                content: SocketEventName.revokeDriverPosition,
                eventName: 'Get on car!',
              );
              _roleProvider.hasRevokedDriverPosition = true;
              // _driverPositionStream.cancel();
            }
          }
        }
      },
    );
  }

  /// You should not call this method to listen to driver's
  /// position stream if your role is driver. Instead, passenger
  /// should listen to this stream.
  void listenDriverPositionStream() {
    _driverPositionStream = _socketHandler.getDriverPositionStream.listen(
      (Map<String, String> data) {
        final lat = double.parse(data['lat']);
        final lng = double.parse(data['lng']);
        _driverCurrentPosition = Position(
          latitude: lat,
          longitude: lng,
        );

        // Record the latest coordinates of driver to ensure that they can be
        // the initial position of driver when you launch the app next time.
        _roleProvider.driverLat = lat;
        _roleProvider.driverLng = lng;

        _locationProvider.locationUpdateManager.updateCharacterPosition(
          character: Character.otherSide,
          position: _driverCurrentPosition,
        );
      },
    );
  }

  /// Driver should listen to this stream when passenger don't need your current
  /// location anymore.
  void listenRevokeDriverPositionStream() {
    _revokePositionStream = _socketHandler.getRevokeDriverPositionStream.listen(
      (_) {
        _roleProvider.hasRevokedDriverPosition = true;
        // _revokePositionStream.cancel();
      },
    );
  }

  /// This method enable client to unsubscrible the position Stream at any time.
  void cancelMyPositionStream() {
    print('Just triggered cancelPositionStream!!! on tap');
    _myPositionStream.cancel();
  }

  dispose() {
    _myPositionStream.cancel();
    _driverPositionStream.cancel();
    _revokePositionStream.cancel();
  }
}
