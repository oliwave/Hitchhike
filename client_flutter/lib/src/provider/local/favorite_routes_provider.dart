import 'package:client_flutter/src/model/order_info.dart';
import 'package:flutter/Material.dart';

import 'package:sqflite/sql.dart';

import '../../model/favorite_route_item.dart';
import '../../resources/repository.dart';
import '../../resources/source_collection.dart' show DatabaseHandler;

class FavoriteRoutesProvider with ChangeNotifier {
  FavoriteRoutesProvider._();

  factory FavoriteRoutesProvider() {
    return _favoriteRoutesProvider;
  }

  static final _handler = Repository.getDatabaseHandler;

  static final _favoriteRoutesProvider = FavoriteRoutesProvider._();

  bool _isFirst = true;

  Map<String, FavoriteRouteItem> _routesMaps = {};

  /// Get a list of your [FavoriteRouteItem] that stores in the database.
  List<FavoriteRouteItem> get favoriteRoutesList => [..._routesMaps.values];

  /// Get a boolean value to determine if the [favoriteRoutesList] is empty.
  bool get isEmptyRoutesList => _routesMaps.isEmpty;

  /// Get the length of [favoriteRoutesList].
  int get routesListLength => _routesMaps.length;

  /// Get the user default selected [FavoriteRouteItem].
  ///
  /// Return `null` if no element satisfy this condition which
  /// [FavoriteRouteItem.isDefaultRoute] is `false`.
  FavoriteRouteItem get defaultFavoriteRouteItem =>
      _routesMaps.values.firstWhere(
        (routeItem) => routeItem.isDefaultRoute,
        orElse: () => null,
      );

  /// This method provider user to add their favorite route with specified
  /// [FavoriteRouteItem] object.
  bool addRoute({
    @required FavoriteRouteItem targetRoute,
  }) {
    if (_routesMaps[targetRoute.id] != null) return false;

    // To inspect if there is the same route.
    final machingList = _routesMaps.keys.where((routeItem) =>
        routeItem.contains(targetRoute.nameStart) &&
        routeItem.contains(targetRoute.nameEnd));

    // Return `false` if no element is in matchingList.
    if (machingList.isNotEmpty) return false;

    // 1. Insert the given route into database.
    _handler.db.insert(
      DatabaseHandler.favoriteRoutes,
      targetRoute.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    // 2. Insert the given route into runtime list.
    _routesMaps[targetRoute.id] = targetRoute;

    notifyListeners();

    return true;
  }

  /// The feature of this method is to expand the tapped panel and
  /// close the rest.
  ///
  /// * [index] enable this method to find the target panel in the list,
  /// and assign the [isExpanded] value to panel's field.
  void setExpasionPanelState(int index, bool isExpanded) {
    for (int i = 0; i < favoriteRoutesList.length; i++) {
      if (i == index) {
        favoriteRoutesList[i].isExpanded = !isExpanded;
      } else {
        favoriteRoutesList[i].isExpanded = false;
      }
    }
    notifyListeners();
  }

  /// With the given [routeId], [changeDefaultRoute] method can help user
  /// to change the default [FavoriteRouteItem] to the specified one.
  bool changeDefaultRoute({
    @required String routeId,
  }) {
    final targetRoute = _routesMaps[routeId];
    FavoriteRouteItem originRoute;

    if (targetRoute == null) return false;

    final originDefaultRouteId = defaultFavoriteRouteItem?.id;

    /// [originDefaultRouteId] is not the parameter, nor a null value.
    if (originDefaultRouteId != routeId && originDefaultRouteId != null) {
      originRoute = _routesMaps[originDefaultRouteId];
      originRoute.isDefaultRoute = !originRoute.isDefaultRoute;

      _handler.db.update(
        DatabaseHandler.favoriteRoutes,
        originRoute.toMapForDb(),
        where: 'id = ?',
        whereArgs: [originRoute.id],
      );

      _routesMaps[originDefaultRouteId].isDefaultRoute =
          originRoute.isDefaultRoute;
    }
    targetRoute.isDefaultRoute = !targetRoute.isDefaultRoute;

    _handler.db.update(
      DatabaseHandler.favoriteRoutes,
      targetRoute.toMapForDb(),
      where: 'id = ?',
      whereArgs: [targetRoute.id],
    );

    _routesMaps[routeId].isDefaultRoute = targetRoute.isDefaultRoute;
    _routesMaps[routeId].isExpanded = false;

    FavoriteRouteItem currentDefaultRoute;

    if (targetRoute.isDefaultRoute) {
      currentDefaultRoute = targetRoute;
    } else if (originRoute != null) {
      if (originRoute.isDefaultRoute) {
        currentDefaultRoute = originRoute;
      }
    }

    _updateOrderInfo(
      currentDefaultRoute,
    );

    notifyListeners();

    return true;
  }

  /// Delete the [FavoriteRouteItem] with given [routeId].
  bool deleteRoute({
    @required String routeId,
  }) {
    final targetRoute = _routesMaps[routeId];

    if (targetRoute == null) return false;

    _routesMaps[routeId].isExpanded = false;
    notifyListeners();

    _handler.db.delete(
      DatabaseHandler.favoriteRoutes,
      where: 'id = ?',
      whereArgs: [routeId],
    );

    _routesMaps.remove(routeId);
    notifyListeners();

    return true;
  }

  /// Swap the start and the end location in a route.
  bool swapRouteUpdate({
    @required String routeId,
  }) {
    final targetRoute = _routesMaps[routeId];

    if (targetRoute == null) return false;

    final tempAdStart = targetRoute.addressStart;
    final tempGeoStart = targetRoute.geoStart;
    final tempNameStart = targetRoute.nameStart;

    targetRoute
      ..geoStart = _routesMaps[routeId].geoEnd
      ..geoEnd = tempGeoStart
      ..nameStart = _routesMaps[routeId].nameEnd
      ..nameEnd = tempNameStart
      ..addressStart = _routesMaps[routeId].addressEnd
      ..addressEnd = tempAdStart;

    _handler.db.update(
      DatabaseHandler.favoriteRoutes,
      targetRoute.toMapForDb(),
      where: 'id = ?',
      whereArgs: [targetRoute.id],
    );

    _routesMaps[routeId] = targetRoute;

    notifyListeners();

    _updateOrderInfo(targetRoute);

    return true;
  }

  Future<void> initRoutesList() async {
    if (_isFirst) {
      List<Map<String, dynamic>> maps = [];

      try {
        maps = await _handler.db.query(
          DatabaseHandler.favoriteRoutes,
        );

        if (maps.isEmpty) {
          print('FavoriteRoutesList is Empty!');
          return;
        }
      } catch (e) {
        print(e);
      }

      FavoriteRouteItem defaultRoute;

      for (final rawItem in maps) {
        final route = FavoriteRouteItem.fromDB(rawItem);

        /// Initialize [_routesMap] and record [defaultRoute]
        /// at the same time.
        if (route.isDefaultRoute) {
          defaultRoute = route;
        }

        _routesMaps[route.id] = route;
      }

      _updateOrderInfo(defaultRoute);

      _isFirst = false;
    }
  }

  void _updateOrderInfo(FavoriteRouteItem defaultRoute) {
    OrderInfo()
      ..addressEnd = defaultRoute?.addressEnd
      ..addressStart = defaultRoute?.addressStart
      ..nameEnd = defaultRoute?.nameEnd
      ..nameStart = defaultRoute?.nameStart
      ..geoEnd = defaultRoute?.geoEnd
      ..geoStart = defaultRoute?.geoStart;
  }
}
