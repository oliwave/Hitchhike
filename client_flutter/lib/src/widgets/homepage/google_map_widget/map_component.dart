import 'package:client_flutter/src/util/platform_info.dart';
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
  final Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  /// Record a key-value data, which client can get the instance of [MarkerId]
  /// by specified a specific String
  final Map<String, MarkerId> markersId = <String, MarkerId>{};

  /// Record a key-value data, which client can get the instance of [CircleId]
  /// by specified a specific String
  final Map<String, CircleId> circlesId = <String, CircleId>{};

  final Map<String, PolylineId> polylinesId = <String, PolylineId>{};

  Iterable<Marker> get markersValue => markers.values;
  Iterable<Circle> get circlesValue => circles.values;
  Iterable<Polyline> get polylinesValue => polylines.values;

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
      radius: PlatformInfo.screenAwareSize(70),
      fillColor: color,
      strokeWidth: strokeWidth,
      strokeColor: strokeColor,
    );

    circles[circleId] = circle;
  }

  void createMarker({
    @required String id,
    @required Position position,
    String iconName,
    String windowTitle,
  }) {
    final MarkerId markerId = MarkerId(id);

    markersId[id] = markerId;

    print('icon is String : $iconName');

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(position.latitude, position.longitude),
      anchor: Offset(0.5, 0.5),
      icon: iconName == null && windowTitle != null
          ? BitmapDescriptor.defaultMarker
          : MarkerBitmap().bitmaps[iconName],
      infoWindow: windowTitle == null && iconName != null
          ? InfoWindow.noText
          : InfoWindow(title: windowTitle),
      rotation: position.heading - 45,
    );

    markers[markerId] = marker;
  }

  void createPolyline({
    @required String id,
    @required List<Position> points,
  }) {
    final PolylineId polylineId = PolylineId(id);

    polylinesId[id] = polylineId;

    final polyline = Polyline(
      polylineId: polylineId,
      points: points
          .map((position) => LatLng(position.latitude, position.longitude))
          .toList(),
    );

    polylines[polylineId] = polyline;
  }
}
