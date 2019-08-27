import 'package:flutter/Material.dart';

import 'package:provider/provider.dart';

import '../../model/favorite_route_item.dart';
import '../../provider/provider_collection.dart' show FavoriteRoutesProvider;

import './brief_text.dart';
import './header_content.dart';
import './stepper_body.dart';

class RoutesListView extends StatelessWidget {
  const RoutesListView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteRoutesProvider>(
      builder: (_, FavoriteRoutesProvider provider, Widget child) {
        Widget _favoriteContent;

        if (provider.isEmptyRoutesList) {
          _favoriteContent = Center(
            child: Text(
              '儲存您最愛的路線吧!',
              style: TextStyle(letterSpacing: 1, fontSize: 16),
            ),
          );
        } else {
          _favoriteContent = SingleChildScrollView(
            child: _buildExpansionPanelList(provider),
          );
        }

        return _favoriteContent;
      },
    );
  }

  Widget _buildExpansionPanelList(FavoriteRoutesProvider provider) {
    return ExpansionPanelList(
      animationDuration: const Duration(
        milliseconds: 800,
      ),
      children: <ExpansionPanel>[
        ...provider.favoriteRoutesList
            .map((route) => _buildExpansionPanel(route))
            .toList(),
      ],
      expansionCallback: (int index, bool isExpanded) {
        print('isExpanded : $isExpanded');
        provider.setExpasionPanelState(index, isExpanded);
      },
    );
  }

  ExpansionPanel _buildExpansionPanel(FavoriteRouteItem routeItem) {
    return ExpansionPanel(
      headerBuilder: (_, bool isExpanded) => HeaderContent(
        startBreifText: BriefText(
          text: routeItem.nameStart,
          isExpanded: isExpanded,
        ),
        endBreifText: BriefText(
          text: routeItem.nameEnd,
          isExpanded: isExpanded,
        ),
        routeItem: routeItem,
        isExpanded: isExpanded,
      ),
      body: StepperBody(
        routeItem: routeItem,
      ),
      isExpanded: routeItem.isExpanded,
    );
  }
}
