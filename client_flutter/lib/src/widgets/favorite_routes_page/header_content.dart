import 'package:flutter/Material.dart';

import '../../model/favorite_route_item.dart';

import './cutomized_divider.dart';
import './brief_text.dart';

class HeaderContent extends StatelessWidget {
  const HeaderContent({
    @required this.startBreifText,
    @required this.endBreifText,
    @required this.isExpanded,
    @required this.routeItem,
  });

  final BriefText startBreifText;
  final BriefText endBreifText;
  final bool isExpanded;
  final FavoriteRouteItem routeItem;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isExpanded) {
      content = Row(
        children: <Widget>[
          startBreifText,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const CustomizedDivider(
                padding: 12,
                height: 1,
                width: 8,
              ),
            ),
          ),
          endBreifText,
        ],
      );
    } else {
      content = Row(
        children: <Widget>[
          Icon(
            Icons.directions,
            color: Colors.black26,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                startBreifText,
                const CustomizedDivider(
                  padding: 8,
                  height: 22,
                  width: 1,
                ),
                endBreifText,
              ],
            ),
          ),
          Visibility(
            visible: routeItem.isDefaultRoute,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: const Text(
              '預設',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      );
    }

    final paddingValue = isExpanded ? 8.0 : 16.0;

    return Padding(
      padding: EdgeInsets.only(
        left: paddingValue,
        top: paddingValue,
        bottom: paddingValue,
      ),
      child: content,
    );
  }
}
