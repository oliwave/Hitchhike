import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Homepage extends StatelessWidget {
  static const String routeName = '/';

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37, -122),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          // location.controller.complete(controller),
        },
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        // markers: Set<Marker>.of(location.markersValue),
        // circles: Set<Circle>.of(location.circlesValue),
      ),
    );
  }
}
