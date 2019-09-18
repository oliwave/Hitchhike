import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/provider_collection.dart' show CloudMessageProvider;
import '../widgets/general_app_bar.dart';
import '../widgets/favorite_routes_page/routes_list_view.dart';

class FavoriteRoutesPage extends StatelessWidget {
  static const String routeName = '/favorite_routes_page';

  @override
  Widget build(BuildContext context) {
    Provider.of<CloudMessageProvider>(
      context,
      listen: false,
    ).context = context;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        title: GeneralAppBar(
          title: '最愛路線',
          heroTag: 'bookmark',
          icon: Icons.bookmark_border,
        ),
      ),
      body: RoutesListView(),
    );
  }
}
