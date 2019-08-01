import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import './marker_bitmap.dart';

class MapComponent {
  MapComponent._();

  factory MapComponent() {
    return mapComponent;
  }

  static final mapComponent = MapComponent._();

  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Map<CircleId, Circle> circles = <CircleId, Circle>{};

  /// Record a key-value data, which client can get the instance of [MarkerId]
  /// by specified a specific String
  final Map<String, MarkerId> markersId = <String, MarkerId>{};

  /// Record a key-value data, which client can get the instance of [CircleId]
  /// by specified a specific String
  final Map<String, CircleId> circlesId = <String, CircleId>{};

  Iterable<Marker> get markersValue => markers.values;
  Iterable<Circle> get circlesValue => circles.values;

  void createCircle({
    @required String id,
    @required Position position,
    Color color = Colors.black,
    int strokeWidth = 0,
    Color strokeColor = Colors.transparent,
  }) {
    final CircleId circleId = CircleId(id);

    circlesId[id] = circleId;

    final Circle circle = Circle(
      circleId: circleId,
      center: LatLng(position.latitude, position.longitude),
      radius: 80,
      fillColor: color,
      strokeWidth: strokeWidth,
      strokeColor: strokeColor,
    );

    circles[circleId] = circle;
  }

  void createMarker({
    @required String id,
    @required String icon,
    @required Position position,
  }) {
    final MarkerId markerId = MarkerId(id);

    markersId[id] = markerId;

    print('icon is String : $icon');

    BitmapDescriptor bitmap;
    if (icon == MarkerBitmap.motorText) {
      bitmap = MarkerBitmap().motor;
    } else if (icon == MarkerBitmap.carText) {
      bitmap = MarkerBitmap().car;
    } else if (icon == MarkerBitmap.compassText) {
      bitmap = MarkerBitmap().compass;
    }

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(position.latitude, position.longitude),
      anchor: Offset(0.5, 0.5),
      icon: bitmap,
      rotation: position.heading - 45,
    );

    markers[markerId] = marker;
  }
}
