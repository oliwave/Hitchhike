import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart'
    show AuthProvider, HomepageProvider, MenuProvider;
import '../../screen/page_collection.dart'
    show FriendListPage, ProfilePage, LoginPage;
import '../../util/util_collection.dart' show SizeConfig;

class MenuView extends StatefulWidget {
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> with TickerProviderStateMixin {
  AnimationController _menuHeightController;
  Animation<double> _heightAnimation;

  @override
  void initState() {
    _menuHeightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _heightAnimation = _menuHeightController.drive(
      Tween<double>(
        begin: SizeConfig.screenAwareHeight(0),
        end: SizeConfig.screenAwareHeight(40),
      ),
    );

    final menuProvider = Provider.of<MenuProvider>(
      context,
      listen: false,
    );

    menuProvider.menuHeightController = _menuHeightController;

    super.initState();
  }

  @override
  void dispose() {
    _menuHeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, menuContent) {
        return Container(
          width: double.infinity,
          height: _heightAnimation.value,
          decoration: BoxDecoration(
            color: Colors.white,
            // color: Colors.teal[400],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeConfig.screenAwareWidth(50)),
              bottomRight: Radius.circular(SizeConfig.screenAwareWidth(50)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
              )
            ],
          ),
          child: menuContent,
        );
      },
      child: Consumer<MenuProvider>(
        builder: (context, provider, _) {
          return SafeArea(
            child: Opacity(
              opacity: provider.menuOpacity,
              child: Column(
                children: <Widget>[
                  MenuAppBar(),
                  MenuListView(),
                ],
              ),
            ),
          );
        },
      ),
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

    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => menuProvider.setMenuVisible(false, homeProvider),
        ),
        Expanded(
          child: Text(
            '選單',
            style: TextStyle(letterSpacing: 2.0, fontSize: 20),
          ),
        ),
      ],
    );
  }
}

class MenuListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          OptionFlatbutton(
            icon: Icons.portrait,
            routeName: ProfilePage.routeName,
            text: '編輯個人',
          ),
          OptionFlatbutton(
            icon: Icons.chat,
            routeName: FriendListPage.routeName,
            text: '聊天室',
          ),
          OptionFlatbutton(
            icon: Icons.add_to_home_screen,
            routeName: LoginPage.routeName,
            text: '登出',
          ),
        ],
      ),
    );
  }
}

class OptionFlatbutton extends StatelessWidget {
  OptionFlatbutton({
    @required this.routeName,
    @required this.icon,
    @required this.text,
  });

  final String routeName;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: SizeConfig.screenAwareWidth(6),
            color: Colors.blueGrey[400],
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: SizeConfig.screenAwareWidth(5),
              color: Colors.blueGrey[400],
            ),
          )
        ],
      ),
      onPressed: () {
        if (text == '登出') {
          Provider.of<AuthProvider>(
            context,
            listen: false,
          ).invokeLogout();

          Navigator.pushNamedAndRemoveUntil(
            context,
            routeName,
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pushNamed(context, routeName);
        }

        Provider.of<MenuProvider>(
          context,
          listen: false,
        ).setMenuVisible(
          false,
          Provider.of<HomepageProvider>(context, listen: false),
        );
      },
    );
  }
}
