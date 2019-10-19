import 'package:client_flutter/src/model/order_info.dart';
import 'package:flutter/Material.dart';
import 'package:google_maps_webservice/geolocation.dart';

class FavoriteRouteItem {
  FavoriteRouteItem({
    @required this.geoStart,
    @required this.geoEnd,
    @required this.nameStart,
    @required this.nameEnd,
    @required this.addressStart,
    @required this.addressEnd,
  })  : id = '$nameStart,$nameEnd',
        isDefaultRoute = false,
        isExpanded = false;

  FavoriteRouteItem.fromInstance({@required OrderInfo order})
      : id = '${order.nameStart},${order.nameEnd}',
        isDefaultRoute = false,
        isExpanded = false,
        geoStart = order.geoStart,
        geoEnd = order.geoEnd,
        nameStart = order.nameStart,
        nameEnd = order.nameEnd,
        addressStart = order.addressStart,
        addressEnd = order.addressEnd;

  FavoriteRouteItem.fromDB(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        isDefaultRoute = parsedJson['isDefaultRoute'] == 1,
        isExpanded = false,
        geoStart = _convertToLocation(parsedJson['geoStart']),
        geoEnd = _convertToLocation(parsedJson['geoEnd']),
        nameStart = parsedJson['nameStart'],
        nameEnd = parsedJson['nameEnd'],
        addressStart = parsedJson['addressStart'],
        addressEnd = parsedJson['addressEnd'];

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      'id': id,
      'isDefaultRoute': isDefaultRoute ? 1 : 0,
      'geoStart': geoStart.toString(),
      'geoEnd': geoEnd.toString(),
      'nameStart': nameStart,
      'nameEnd': nameEnd,
      'addressStart': addressStart,
      'addressEnd': addressEnd,
    };
  }

  static Location _convertToLocation(String locationString) {
    final coordinates = locationString
        .split(',')
        .map(
          (text) => double.parse(text),
        )
        .toList();
    return Location(coordinates[0], coordinates[1]);
  }

  final String id;
  bool isDefaultRoute;
  bool isExpanded;
  Location geoStart;
  Location geoEnd;
  String nameStart;
  String nameEnd;
  String addressStart;
  String addressEnd;
}
