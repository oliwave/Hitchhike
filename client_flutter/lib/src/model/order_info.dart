import 'package:google_maps_webservice/places.dart';

class OrderInfo {
  OrderInfo._();

  factory OrderInfo() {
    return _orderInfo;
  }

  static final _orderInfo = OrderInfo._();

  Location geoStart;
  Location geoEnd;
  String nameStart;
  String nameEnd;
  String addressStart;
  String addressEnd;
}
