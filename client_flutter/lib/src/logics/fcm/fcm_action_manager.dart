// import 'package:client_flutter/src/util/platform_info.dart';
import 'package:flutter/material.dart';

import '../notify_manager.dart';
import '../../provider/provider_collection.dart'
    show RoleProvider, LocationProvider, FriendListProvider, AuthProvider;
import '../../resources/restful/request_method.dart'
    show OrderConfirmationRequest, FetchPairedDataRequest;
import '../../util/util_collection.dart' show SizeConfig;
import '../../resources/repository.dart';
import '../../widgets/customized_alert_dialog.dart';
import '../../model/friend_item.dart';

class FcmActionManager extends NotifyManager {
  FcmActionManager(notifyListeners) : super(notifyListeners);

  BuildContext _context;

  final RoleProvider _roleProvider = RoleProvider();
  final LocationProvider _locationProvider = LocationProvider();
  final FriendListProvider _friendListProvider = FriendListProvider();
  final AuthProvider _auth = AuthProvider();
  final _api = Repository.getApi;
  final _fs = Repository.getJsonFileHandler;

  /// It's a primary method of consuming fcm event.
  Future<void> messageConsumer(
    Map<String, dynamic> message,
    BuildContext context,
  ) async {
    _context = context;

    /**
     * Formal Ccode
     */
    // Data Message
    if (message.containsKey('data')) {
      final String type = message['data']['type'];

      /// TODO : Filter the following messages when user is in paired mode.
      if (type == FcmEventType.orderConfirmation) {
        final costTime =
            Duration(seconds: int.parse(message['data']['costTime']));

        customizedAlertDialog(
          context: context,
          barrierDismissible: false,
          title: const Text('乘客資訊'),
          content: Container(
            height: SizeConfig.screenAwareHeight(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        message['data']['passengerStartName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        color: Colors.grey,
                        height: 1,
                        width: 8,
                      ),
                      Text(
                        message['data']['passengerEndName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text('總路程需要多花 ${costTime.inMinutes} 分鐘'),
              ],
            ),
          ),
          confirmButtonName: '開始訂單',
          cancelButtonName: '掰掰',
          confirmCallback: _confirmCallback('success'),
          cancelCallback: _confirmCallback('fail'),
        );

        return;
      } else if (type == FcmEventType.paired) {
        // Assign fcm pairedData to field.
        // Map<String, dynamic> pairedData = message['data'];

        final String driverId = message['data']['driverId'];

        await customizedAlertDialog(
          context: context,
          title: const Text('暨大搭便車'),
          content: Text('已經完成配對囉～'),
          confirmButtonName: '了解',
          confirmCallback: _fetchPairedData(driverId),
        );

        print('Still sync');

        return;
      }
    }

    // TEST
    // Notification Message
    customizedAlertDialog(
      context: context,
      title: Text(message['notification']['title'] ?? message['data']['name']),
      content: Text(message['notification']['body'] ?? message['data']['name']),
      confirmButtonName: '確認',
      confirmCallback: () => Navigator.pop(_context),
      cancelButtonName: '掰掰',
      cancelCallback: () => Navigator.pop(_context),
    );
  }

  void _setEndTimeOfTrip(int duration, int pairedTime) {
    final travelingTime = Duration(seconds: duration);

    final startTime = DateTime.fromMillisecondsSinceEpoch(pairedTime);

    print('The start time is $startTime');

    // _roleProvider.endTimeOfTrip = startTime.add(travelingTime); // PRODUCTION
    _roleProvider.endTimeOfTrip =
        DateTime.now().add(Duration(seconds: 1)); // TEST
  }

  void _addNewFriend(Map<String, dynamic> message) {
    print(
        'The type of avatar is ${message['avatar']['data'].runtimeType}. And ${message['avatar']['data']}');

    _friendListProvider.addFriend(FriendItem(
      // avatar: message['avatar'],
      avatar: 'TEST',
      name: message['name'],
      room: message['roomId'],
    ));
  }

  void _removeRedundantField(Map<String, dynamic> message) {
    message.remove('avatar')
      ..remove('type')
      ..remove('roomId')
      ..remove('isFriend')
      ..remove('duration')
      ..remove('pairedTime');
  }

  /// [_confirmCallback] method returns a callback method that conducts
  /// the request of [OrderConfirmationRequest] with a given [status].
  ///
  /// * [status] is String type variable that determines if a paired
  /// order is valid.
  VoidCallback _confirmCallback(String status) => () {
        Navigator.pop(_context);

        print('Order Confirmation request> jwt is ${_auth.jwt}');

        _api.sendHttpRequest(
          OrderConfirmationRequest(
            status: status,
            jwtToken: _auth.jwt,
          ),
        );
      };

  VoidCallback _fetchPairedData(String driverId) => () async {
        Navigator.pop(
          _context,
        );

        Map<String, dynamic> pairedData = await _api.sendHttpRequest(
          FetchPairedDataRequest(
            jwtToken: _auth.jwt,
            driverId: driverId,
          ),
        );

        print(pairedData['type']);
        print(pairedData['isFriend']);
        print(pairedData['roomId']);
        print(pairedData['avatar']);
        print(pairedData['carDescripition']);
        print(pairedData['carNum']);
        print(pairedData['duration']);
        print(pairedData['pairedTime']);
        print(pairedData['startName']);
        print(pairedData['endName']);
        print(pairedData['northeastLat']);
        print(pairedData['northeastLng']);
        print(pairedData['southwestLat']);
        print(pairedData['southwestLng']);
        print(pairedData['legs']);

        ///TODO : the fcm api should reconsider.
        if (pairedData['isFriend']) _addNewFriend(pairedData);

        // It's dedicated to chattingFloatingActionButton
        _roleProvider.newTravelRoom = pairedData['roomId'];

        _setEndTimeOfTrip(pairedData['duration'], pairedData['pairedTime']);

        // Remove redundent field.
        // _removeRedundantField(pairedData);

        pairedData.remove('avatar');
        pairedData.remove('type');
        pairedData.remove('roomId');
        pairedData.remove('isFriend');
        pairedData.remove('duration');
        pairedData.remove('pairedTime');

        _roleProvider.isMatched = true;

        // Assign the reference of pairedData to pairedDataManager in
        // LocationProvider.
        _locationProvider.pairedDataManager.initPairingRoute(pairedData);

        // Write pairedData to json file without waiting it.
        _fs.writeToFile(
          fileName: FileName.pairedData,
          data: pairedData,
        );
      };
}
