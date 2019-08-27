import 'package:client_flutter/src/provider/provider_collection.dart';
import 'package:client_flutter/src/screen/favorite_routes_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteFloatingActionButton extends StatefulWidget {
  @override
  _FavoriteFloatingActionButtonState createState() =>
      _FavoriteFloatingActionButtonState();
}

class _FavoriteFloatingActionButtonState
    extends State<FavoriteFloatingActionButton>
    with SingleTickerProviderStateMixin {
  AnimationController _favoriteButtonController;
  Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    _favoriteButtonController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );

    _alignmentAnimation = _favoriteButtonController.drive(
      AlignmentTween(
        begin: Alignment(0.875, -0.6),
        end: Alignment(2, -0.6),
      ),
    );

    final manager = Provider.of<HomepageProvider>(
      context,
      listen: false,
    ).animationManager;

    manager.favoriteButtonController = _favoriteButtonController;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _alignmentAnimation,
      builder: (BuildContext context, Widget floatingButton) {
        return Align(
          alignment: _alignmentAnimation.value,
          child: floatingButton,
        );
      },
      child: Hero(
        tag: 'bookmark',
        child: Material(
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
            child: IconButton(
              icon: Icon(
                Icons.bookmark,
                // color: Colors.blue[600],
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pushNamed(context, FavoriteRoutesPage.routeName);
              },
            ),
          ),
        ),
      ),
    );
  }
}
