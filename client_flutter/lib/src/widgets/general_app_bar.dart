import 'package:flutter/material.dart';

class GeneralAppBar extends StatelessWidget {
  GeneralAppBar({
    @required String title,
    @required String heroTag,
    @required IconData icon,
    Key key,
  })  : _title = title,
        _heroTag = heroTag,
        _icon = icon,
        super(key: key);

  final String _title;
  final String _heroTag;
  final IconData _icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          _title,
          style: const TextStyle(
            color: Colors.black,
            letterSpacing: 1,
          ),
        ),
        Hero(
          tag: _heroTag,
          child: Material(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(
                _icon,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
