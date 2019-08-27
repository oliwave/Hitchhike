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

  List<FavoriteRouteItem> get favoriteRoutesList => [..._routesMaps.values];

  bool get isEmptyRoutesList => _routesMaps.isEmpty;

  FavoriteRouteItem get defaultFavoriteRouteItem =>
      _routesMaps.values.firstWhere((routeItem) => routeItem.isDefaultRoute);

  bool addRoute({
    @required FavoriteRouteItem targetRoute,
  }) {
    if (_routesMaps[targetRoute.id] != null) return false;

    _handler.db.insert(
      DatabaseHandler.favoriteRoutes,
      targetRoute.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    _routesMaps[targetRoute.id] = targetRoute;

    notifyListeners();

    return true;
  }

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

  bool changeDefaultRoute({
    @required String routeId,
  }) {
    final targetRoute = _routesMaps[routeId];
    FavoriteRouteItem originRoute;

    if (targetRoute == null) return false;

    final originDefaultRouteId = _routesMaps.values
        .firstWhere(
          (routeItem) => routeItem.isDefaultRoute,
          orElse: () => null,
        )
        ?.id;

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

    notifyListeners();

    return true;
  }

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

  bool swapRouteUpdate({
    @required String routeId,
  }) {
    final targetRoute = _routesMaps[routeId];

    if (targetRoute == null) return false;

    final tempAdStart = targetRoute.addressStart;
    final tempGeoStart = targetRoute.geoStart;
    final tempNameStart = targetRoute.nameStart;

    targetRoute.geoStart = _routesMaps[routeId].geoEnd;
    targetRoute.geoEnd = tempGeoStart;
    targetRoute.nameStart = _routesMaps[routeId].nameEnd;
    targetRoute.nameEnd = tempNameStart;
    targetRoute.addressStart = _routesMaps[routeId].addressEnd;
    targetRoute.addressEnd = tempAdStart;

    _handler.db.update(
      DatabaseHandler.favoriteRoutes,
      targetRoute.toMapForDb(),
      where: 'id = ?',
      whereArgs: [targetRoute.id],
    );

    _routesMaps[routeId] = targetRoute;

    notifyListeners();

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

      for (final rawItem in maps) {
        final route = FavoriteRouteItem.fromDB(rawItem);
        _routesMaps[route.id] = route;
      }

      _isFirst = false;
    }
  }
}
