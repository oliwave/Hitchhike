import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart' show LocationProvider;

class PositionFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.9, 0.65),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey,
            ),
          ],
        ),
        child: Consumer<LocationProvider>(
          builder: (context, locationProvider, _) {
            return IconButton(
              color:
                  locationProvider.hasMoved ? Colors.black : Colors.blue[600],
              icon: Icon(Icons.my_location),
              onPressed: () {
                if (locationProvider.hasMoved) {
                  locationProvider.locationStreamManager
                      .listenMyPositionStream();
                  locationProvider.hasMoved = false;
                }
              },
            );
          },
        ),
      ),
    );
  }
}
