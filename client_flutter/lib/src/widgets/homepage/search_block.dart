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
          _SearchField(hintText: '起點'),
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
    final manager = Provider.of<HomepageProvider>(
      context,
      listen: false,
    ).autocompleteManager;

    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );

    print('Refreshing SeachField ... $hintText 1');

    return Container(
      width: PlatformInfo.screenAwareSize(175),
      height: PlatformInfo.screenAwareSize(30),
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Material(
              child: InkWell(
                onTap: () async {
                  await manager.startAutocomplete(
                    context: context,
                    target: hintText,
                    futurePosition: locationProvider.currentPosition,
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _addressText(),
                ),
              ),
            ),
          ),
          // if (hintText == '你的位置') _CurrentLocationButton()
        ],
      ),
    );
  }

  Widget _addressText() {
    return Consumer<HomepageProvider>(
      builder: (context, HomepageProvider value, Widget child) {
        print('Refreshing SeachField ... $hintText 2');
        final target = _endOrStart(value.orderManager.orderInfo);

        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            target['text'],
            style: TextStyle(
              color: target['color'],
              fontSize: PlatformInfo.screenAwareSize(12),
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> _endOrStart(OrderInfo info) {
    String targetText;
    Color targetColor;

    if (hintText != '終點') {
      if (info.nameStart != null) {
        targetText = info.nameStart;
        targetColor = Colors.black87;
      } else {
        targetText = hintText;
        targetColor = Colors.grey;
      }
    } else {
      if (info.nameEnd != null) {
        targetText = info.nameEnd;
        targetColor = Colors.black87;
      } else {
        targetText = hintText;
        targetColor = Colors.grey;
      }
    }
    return {'text': targetText, 'color': targetColor};
  }
}

// class _CurrentLocationButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final manager = Provider.of<HomepageProvider>(
//       context,
//       listen: false,
//     ).autocompleteManager;

//     final locationProvider = Provider.of<LocationProvider>(
//       context,
//       listen: false,
//     );

//     return Expanded(
//       flex: 1,
//       child: Material(
//         child: InkWell(
//           onTap: () async {
//             manager.useCurrentLocation(
//               futurePosition: locationProvider.currentPosition,
//             );
//           },
//           child: Align(
//             child: Container(
//               child: Consumer<HomepageProvider>(
//                 builder: (_, HomepageProvider value, Widget child) {
//                   return Icon(
//                     Icons.my_location,
//                     color: manager.usingCurrentLocation
//                         ? Colors.blue
//                         : Colors.black,
//                     size: 15,
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
