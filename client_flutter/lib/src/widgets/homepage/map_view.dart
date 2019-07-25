import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  static const CameraPosition _defaultPostion = CameraPosition(
    target: LatLng(23.9933, 120.9647), // 預設埔里經緯度
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _defaultPostion,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        // location.controller.complete(controller),
      },
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      // markers: Set<Marker>.of(location.markersValue),
      // circles: Set<Circle>.of(location.circlesValue),
    );
  }
}
