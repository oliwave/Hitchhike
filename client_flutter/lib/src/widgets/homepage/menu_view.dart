import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../provider/provider_collection.dart'
    show MenuProvider, HomepageProvider;
import '../../util/util_collection.dart' show SizeConfig;

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        return provider.menuVisible
            ? Container(
                width: double.infinity,
                color: Colors.teal[400],
                // color: Colors.grey[300],
                // height: SizeConfig.screenAwareHeight(75),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      MenuAppBar(),
                      MenuListView(),
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }
}

class MenuAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomepageProvider>(
      context,
      listen: false,
    );

    final menuProvider = Provider.of<MenuProvider>(
      context,
      listen: false,
    );

    return Align(
      alignment: Alignment(-0.95, -1),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => menuProvider.setMenuVisible(false, homeProvider),
          ),
          Text(
            '選單',
            style: TextStyle(letterSpacing: 2.0, fontSize: 20),
          )
        ],
      ),
    );
  }
}

class MenuListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(
      context,
      listen: false,
    );

    return Container(
      height: SizeConfig.screenAwareHeight(50),
      child: ListView.builder(
        itemCount: provider.menuListData.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(provider.menuListData[index].keys.toList()[0]),
                    Text(provider.menuListData[index].values.toList()[0]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
