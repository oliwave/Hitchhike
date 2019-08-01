import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart';
import '../../util/platform_info.dart';
import '../../model/order_info.dart';

class SearchBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          _LocationIndicatorIcons(),
          _LocationSearchList(),
        ],
      ),
    );
  }
}

class _LocationIndicatorIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Refreshing LocationIndicatorIcons ...');

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: PlatformInfo.screenAwareSize(5),
        vertical: PlatformInfo.screenAwareSize(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Icon(
              Icons.location_searching,
              color: Colors.blue[700],
              size: 19,
            ),
          ),
          Container(
            color: Colors.grey,
            height: PlatformInfo.screenAwareSize(15),
            width: 2,
          ),
          Expanded(
            flex: 3,
            child: Icon(
              Icons.location_on,
              color: Colors.red[700],
              size: 19,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationSearchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _SearchField(hintText: '你的位置'),
          SizedBox(height: PlatformInfo.screenAwareSize(10)),
          _SearchField(hintText: '終點'),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  _SearchField({@required this.hintText});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomepageProvider>(
      context,
      listen: false,
    );

    print('Refreshing SeachField ... $hintText 1');

    return Material(
      child: InkWell(
        onTap: () async => await state.startAutocomplete(context, hintText),
        child: Container(
          padding: EdgeInsets.all(
            PlatformInfo.screenAwareSize(4),
          ),
          width: PlatformInfo.screenAwareSize(Platform.isIOS ? 175 : 200),
          height: PlatformInfo.screenAwareSize(30),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Consumer<HomepageProvider>(
              builder: (context, HomepageProvider value, Widget child) {
                print('Refreshing SeachField ... $hintText 2');
                final target = _endOrStart(value.orderInfo);

                return Text(
                  target,
                  style: TextStyle(
                    color: target == hintText ? Colors.grey : Colors.black87,
                    fontSize: PlatformInfo.screenAwareSize(12),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _endOrStart(OrderInfo info) {
    String targetText;

    if (hintText != '終點') {
      if (info.nameStart != null) {
        targetText = info.nameStart;
      } else {
        targetText = hintText;
      }
    } else {
      if (info.nameEnd != null) {
        targetText = info.nameEnd;
      } else {
        targetText = hintText;
      }
    }
    return targetText;
  }
}
