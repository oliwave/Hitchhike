import 'package:client_flutter/src/util/util_collection.dart';
import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';

import '../../util/util_collection.dart' show PlatformInfo;
import '../../provider/provider_collection.dart' show FavoriteRoutesProvider;
import '../../model/favorite_route_item.dart';
import './geo_step_tile.dart';

class StepperBody extends StatelessWidget {
  const StepperBody({
    @required this.routeItem,
    Key key,
  }) : super(key: key);

  final FavoriteRouteItem routeItem;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteRoutesProvider>(
      context,
      listen: false,
    );

    return Column(
      children: <Widget>[
        GeoStepTile(
          title: routeItem.nameStart,
          subtitle: routeItem.addressStart,
          isStart: true,
        ),
        Text('lat:${routeItem.geoStart.lat}'),
        Text('lng:${routeItem.geoStart.lng}'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            iconSize: 30,
            icon: Icon(Icons.swap_vert),
            color: Colors.blueGrey[300],
            onPressed: () {
              provider.swapRouteUpdate(
                routeId: routeItem.id,
              );
            },
          ),
        ),
        GeoStepTile(
          title: routeItem.nameEnd,
          subtitle: routeItem.addressEnd,
          isStart: false,
        ),
        Text('lat:${routeItem.geoEnd.lat}'),
        Text('lng:${routeItem.geoEnd.lng}'),
        Divider(
          color: Colors.black,
          // height: PlatformInfo.screenAwareSize(50),
          height: SizeConfig.screenAwareHeight(7),
          indent: 20,
          endIndent: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            OutlineButton(
              onPressed: () {
                provider.deleteRoute(
                  routeId: routeItem.id,
                );
              },
              borderSide: BorderSide(
                color: Colors.red,
              ),
              child: Text(
                '刪除路線',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            OutlineButton(
              onPressed: () {
                provider.changeDefaultRoute(
                  routeId: routeItem.id,
                );
              },
              borderSide: BorderSide(
                color: routeItem.isDefaultRoute ? Colors.green : Colors.blue,
              ),
              child: Text(
                routeItem.isDefaultRoute ? '取消預設路線' : '選為預設路線',
                style: TextStyle(
                  color: routeItem.isDefaultRoute ? Colors.green : Colors.blue,
                ),
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.all(8))
      ],
    );
  }
}
