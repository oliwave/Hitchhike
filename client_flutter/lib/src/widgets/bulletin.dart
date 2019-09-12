import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_collection.dart';
import '../util/platform_info.dart';

class Bulletin extends StatefulWidget {
  @override
  _BulletinState createState() => _BulletinState();
}

class _BulletinState extends State<Bulletin>
    with SingleTickerProviderStateMixin {
  AnimationController _bulletinSizeController;
  Animation<double> _bulletinHeight;

  @override
  void initState() {
    _bulletinSizeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _bulletinHeight = _bulletinSizeController.drive(
      Tween<double>(
        begin: 0,
        end: 30,
      ),
    );

    final bulletinProvider = Provider.of<BulletinProvider>(
      context,
      listen: false,
    );

    bulletinProvider.bulletinSizeController = _bulletinSizeController;

    super.initState();
  }

  @override
  void dispose() {
    _bulletinSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bulletinHeight,
      builder: (context, bulletin) {
        return Align(
          alignment: Alignment(0, -0.4),
          child: Container(
            height: PlatformInfo.screenAwareSize(_bulletinHeight.value),
            child: bulletin,
          ),
        );
      },
      child: Consumer<BulletinProvider>(
        builder: (context, provider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Image.asset(
                  'assets/icons/bullhorn/bullhorn.png',
                  height: PlatformInfo.screenAwareSize(20),
                  width: PlatformInfo.screenAwareSize(20),
                  color: provider.iconColor,
                ),
              ),
              Text(
                provider.showText,
                style: TextStyle(
                  color: provider.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 2,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
