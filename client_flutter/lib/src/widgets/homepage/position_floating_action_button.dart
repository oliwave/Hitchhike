import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart';

class PositionFloatingActionButton extends StatefulWidget {
  @override
  _PositionFloatingActionButtonState createState() =>
      _PositionFloatingActionButtonState();
}

class _PositionFloatingActionButtonState
    extends State<PositionFloatingActionButton>
    with SingleTickerProviderStateMixin {
  AnimationController _positionButtonController;
  Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    _positionButtonController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );

    _alignmentAnimation = _positionButtonController.drive(
      AlignmentTween(
        begin: Alignment(0.875, 0.7),
        end: Alignment(0.875, -0.15),
      ),
    );

    final manager = Provider.of<HomepageProvider>(
      context,
      listen: false,
    ).animationManager;

    manager.positionButtonController = _positionButtonController;

    super.initState();
  }

  @override
  void dispose() {
    _positionButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );

    return AnimatedBuilder(
      animation: _alignmentAnimation,
      builder: (BuildContext context, Widget floatingButton) {
        return Align(
          alignment: _alignmentAnimation.value,
          child: floatingButton,
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey,
            ),
          ],
        ),
        child: Consumer<HomepageProvider>(
          builder: (context, homepageProvider, _) {
            return IconButton(
              disabledColor: Colors.blue[600],
              icon: Icon(Icons.my_location),
              onPressed: homepageProvider.hasMoved
                  ? () {
                      homepageProvider.hasMoved = false;
                      locationProvider.activatePositionStream();
                    }
                  : null,
            );
          },
        ),
      ),
    );
  }
}
