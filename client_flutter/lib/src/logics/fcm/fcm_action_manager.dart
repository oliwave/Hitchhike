// import 'package:client_flutter/src/util/platform_info.dart';
import 'package:flutter/material.dart';

import '../notify_manager.dart';
import '../../provider/provider_collection.dart'
    show RoleProvider, LocationProvider, FriendListProvider;
import '../../resources/restful/request_method.dart'
    show OrderConfirmationRequest;
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
  final _api = Repository.getApi;
  final _fs = Repository.getJsonFileHandler;

  /// It's a primary method of consuming fcm event.
  void messageConsumer(Map<String, dynamic> message, BuildContext context) {
    _context = context;

    /**
     * Formal Ccode
     */
    // Data Message
    if (message.containsKey('data')) {
      final String type = message['data']['type'];
      final duration =
          Duration(seconds: int.parse(message['data']['duration']));

      /// TODO : Filter the following messages when user is in paired mode.
      if (type == FcmEventType.orderConfirmation) {
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
                        message['data']['startName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        color: Colors.grey,
                        height: 1,
                        width: 8,
                      ),
                      Text(
                        message['data']['endName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text('離乘客起點尚需 ${duration.inMinutes} 分鐘'),
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
        final Map<String, dynamic> pairedData = message['data'];

        ///TODO : the fcm api should reconsider.
        // _friendListProvider.addFriend(FriendItem());

        customizedAlertDialog(
          context: context,
          title: const Text('暨大搭便車'),
          content: Text('已經完成配對囉～'),
          confirmButtonName: '了解',
          confirmCallback: () => Navigator.pop(_context),
          barrierDismissible: true,
        );

        // Assign the reference of pairedData to pairedDataManager in
        // LocationProvider.
        _locationProvider.pairedDataManager.initPairingRoute(pairedData);

        // Write pairedData to json file without waiting it.
        _fs.writeToFile(
          fileName: FileName.pairedData,
          data: pairedData,
        );

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

  /// [_confirmCallback] method returns a callback method that conducts
  /// the request of [OrderConfirmationRequest] with a given [status].
  ///
  /// * [status] is String type variable that determines if a paired
  /// order is valid.
  VoidCallback _confirmCallback(String status) => () async {
        Navigator.pop(_context);

        _roleProvider.isMatched = (status == 'success');

        final response = await _api.sendHttpRequest(
          OrderConfirmationRequest(
            status: status,
            jwtToken: '',
          ),
        );
      };
}
