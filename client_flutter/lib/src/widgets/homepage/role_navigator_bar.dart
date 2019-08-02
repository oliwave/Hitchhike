import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../util/platform_info.dart';
import '../../provider/provider_collection.dart';

class RoleNavigatorBar extends StatelessWidget {
  RoleNavigatorBar({@required this.opacityAnimation});

  final Animation opacityAnimation;

  @override
  Widget build(BuildContext context) {
    print('Refreshing RoleNavigatorBar ... ');

    return AnimatedBuilder(
      animation: opacityAnimation,
      builder: (BuildContext context, Widget rowOfRoleButtons) {
        return SafeArea(
          child: Opacity(
            opacity: opacityAnimation.value,
            child: rowOfRoleButtons,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: _RoleButton(
              roleName: '乘客',
              roleIcon: Icons.person,
            ),
          ),
          Expanded(
            child: _RoleButton(
              roleName: '司機',
              roleIcon: Icons.drive_eta,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  _RoleButton({@required this.roleName, @required this.roleIcon});

  final String roleName;
  final IconData roleIcon;

  @override
  Widget build(BuildContext context) {
    final homepageProvider = Provider.of<HomepageProvider>(
      context,
      listen: false,
    );

    final roleProvider = Provider.of<RoleProvider>(
      context,
      listen: false,
    );

    print('Refreshing RoleButton .... $roleName');

    return RaisedButton(
      // The decoration of role button
      textColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            roleName == '司機' ? 0 : PlatformInfo.screenAwareSize(35),
          ),
          topRight: Radius.circular(
            roleName == '司機' ? PlatformInfo.screenAwareSize(35) : 0,
          ),
        ),
      ),
      elevation: 2,
      color: Colors.white,
      // The content of role button
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(roleIcon),
          Text(
            roleName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
      onPressed: () {
        print('The AnimationController is great in RoleNavigatorBar');

        roleProvider.role = roleName;

        homepageProvider.showPanelHideBar();
      },
    );
  }
}
