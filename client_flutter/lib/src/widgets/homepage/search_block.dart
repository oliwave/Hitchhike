import 'package:flutter/material.dart';

import 'package:flutter_google_places/flutter_google_places.dart';

import '../../util/platform_info.dart';

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
              // color: Colors.blueGrey,
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
              // color: Colors.blueGrey,
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
  final String placesApiKey = 'AIzaSyB9Ht6FmmPwYbY87YDtM-Krno95W3ozqmM';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          // PlacesAutocomplete.show(
          //   apiKey: placesApiKey, // get api key from auth_provider.dart
          //   context: context,
          //   mode: Mode.overlay,
          //   location: null,
          // );

          // Navigator.pushNamed(
          //   context,
          //   SearchAddressPage.routeName,
          //   arguments: hintText,
          // );
          // state.selectedRole = null;
        },
        child: Container(
          padding: EdgeInsets.all(
            PlatformInfo.screenAwareSize(4),
          ),
          width: PlatformInfo.screenAwareSize(200),
          height: PlatformInfo.screenAwareSize(30),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              hintText,
              style: TextStyle(
                color: Colors.grey,
                fontSize: PlatformInfo.screenAwareSize(12),
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
