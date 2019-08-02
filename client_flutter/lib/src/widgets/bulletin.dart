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
  Animation<double> _bulletinWidth;

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

    _bulletinWidth = _bulletinSizeController.drive(
      Tween<double>(
        begin: 0,
        end: 150,
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
      animation: _bulletinWidth,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _bulletinHeight,
          builder: (context, bulletin) {
            return Align(
              alignment: Alignment(0, -0.4),
              child: Container(
                width: PlatformInfo.screenAwareSize(_bulletinWidth.value),
                height: PlatformInfo.screenAwareSize(_bulletinHeight.value),
                decoration: BoxDecoration(
                  color: Colors.grey[400].withOpacity(0.54),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: bulletin,
              ),
            );
          },
          child: Visibility(
            // Don't take up space when animate the bulletin.
            visible: !_bulletinSizeController.isAnimating,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/icons/bullhorn/bullhorn.png',
                    height: PlatformInfo.screenAwareSize(20),
                    width: PlatformInfo.screenAwareSize(20),
                    color: Colors.orange.withOpacity(0.65),
                  ),
                ),
                bulletinContent(),
              ],
            ),
          ),
        );
      },
    );
  }

  Consumer<BulletinProvider> bulletinContent() {
    return Consumer<BulletinProvider>(
      builder: (_, BulletinProvider value, child) {
        return Text(
          value.showText,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 2,
          ),
        );
      },
    );
  }
}
