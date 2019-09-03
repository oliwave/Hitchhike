import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/provider_collection.dart';
import '../util/platform_info.dart';

class TestingGeoInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomepageProvider>(context);

    return provider.hasInfo
        ? Align(
            alignment: Alignment(-0.2, -0.5),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                  ),
                ],
              ),
              width: PlatformInfo.screenAwareSize(160),
              height: PlatformInfo.screenAwareSize(90),
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, _) {
                  final info =
                      locationProvider.locationStreamManager.positionInfo;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      geoText('經度', info.latitude),
                      geoText('緯度', info.longitude),
                      geoText('方向', info.heading),
                      geoText('速度', info.speed),
                    ],
                  );
                },
              ),
            ),
          )
        : Container();
  }

  Widget geoText(String name, double value) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        '$name : $value',
      ),
    );
  }
}
