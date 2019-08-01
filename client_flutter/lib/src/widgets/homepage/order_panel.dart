import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart';
import '../../util/platform_info.dart';

class OrderPanel extends StatelessWidget {
  OrderPanel({@required this.opacityAnimation});

  final Animation opacityAnimation;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RoleProvider>(
      context,
      listen: false,
    );

    return SafeArea(
      child: AnimatedBuilder(
        animation: opacityAnimation,
        builder: (BuildContext context, Widget panel) {
          return Opacity(
            opacity: 1 - opacityAnimation.value,
            child: panel,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (state.role == '司機') ...[
              Expanded(
                child: Icon(Icons.motorcycle),
              ),
            ],
            if (state.role != '司機') ...[
              Icon(Icons.motorcycle),
            ],
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _OrderButton(
                    buttonName: '取消訂單',
                  ),
                  _OrderButton(
                    buttonName: '送出訂單',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderButton extends StatelessWidget {
  _OrderButton({@required this.buttonName})
      : buttonColor =
            buttonName == '送出訂單' ? Colors.green[700] : Colors.redAccent[700],
        buttonIcon = buttonName == '送出訂單' ? Icons.send : Icons.cancel;

  final String buttonName;
  final Color buttonColor;
  final IconData buttonIcon;

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

    print('Refreshing OrderButton .... $buttonName');

    return OutlineButton(
      color: buttonColor,
      borderSide: BorderSide(color: buttonColor),
      child: Row(
        children: <Widget>[
          Text(
            buttonName,
            style: TextStyle(
              color: buttonColor,
              fontSize: 17,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              buttonIcon,
              size: 20,
              color: buttonColor,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(PlatformInfo.screenAwareSize(15)),
        ),
      ),
      onPressed: () {
        print('The AnimationController is great in OrderPanel');

        homepageProvider.bottomSheetController.reverse();
        homepageProvider.floatingButtonController.reverse();
        homepageProvider.appBarController.reverse();
        homepageProvider.isOrderPanel = false;

        if (buttonName != '送出訂單') {
          roleProvider.role = null;
        } else {
          roleProvider.isMatched = true;
        }
      },
    );
  }
}
