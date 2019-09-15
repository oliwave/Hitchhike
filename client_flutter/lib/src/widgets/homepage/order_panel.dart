import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart' show HomepageProvider;
import '../../util/platform_info.dart';
import '../../widgets/favorite_routes_page/geo_step_tile.dart';

class OrderPanel extends StatelessWidget {
  OrderPanel({@required this.opacityAnimation});

  final Animation opacityAnimation;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomepageProvider>(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (state.orderManager.hasCompleteOrderInfo())
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GeoStepTile(
                      title: state.orderManager.orderInfo.nameStart,
                      subtitle: state.orderManager.orderInfo.addressStart,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.blueGrey[300],
                      ),
                    ),
                    GeoStepTile(
                      title: state.orderManager.orderInfo.nameEnd,
                      subtitle: state.orderManager.orderInfo.addressEnd,
                    ),
                  ],
                ),
              ),
            if (!state.orderManager.hasCompleteOrderInfo())
              Expanded(
                child: Center(
                  child: Text(
                    '你想去哪ㄦ～～',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _OrderButton(
                    buttonName: '返回',
                  ),
                  _OrderButton(
                    buttonName: '建立訂單',
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
            buttonName == '建立訂單' ? Colors.green[700] : Colors.redAccent[700],
        buttonIcon = buttonName == '建立訂單' ? Icons.send : Icons.cancel;

  final String buttonName;
  final Color buttonColor;
  final IconData buttonIcon;

  @override
  Widget build(BuildContext context) {
    final homepageProvider = Provider.of<HomepageProvider>(
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

        homepageProvider.animationManager.showBarHidePanel();

        homepageProvider.orderManager.sendOrder(context, buttonName);
      },
    );
  }
}
