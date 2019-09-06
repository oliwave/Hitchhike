import 'package:flutter/material.dart';

import '../notify_manager.dart';
import '../../provider/provider_collection.dart'
    show RoleProvider, LocationProvider;
import '../../resources/restful/request_method.dart'
    show OrderConfirmationRequest;
import '../../resources/repository.dart';

class FcmActionManager extends NotifyManager {
  FcmActionManager(notifyListeners) : super(notifyListeners);

  BuildContext _context;

  final RoleProvider _roleProvider = RoleProvider();
  final LocationProvider _locationProvider = LocationProvider();
  final _api = Repository.getApi;
  final _fs = Repository.getJsonFileHandler;

  /// It's a primary method of consuming fcm event.
  void messageConsumer(Map<String, dynamic> message, BuildContext context) {
    _context = context;

    /**
     * Formal Ccode
     */
    // Data Message
    final String type = message['type'];

    if (message['notification'] == null) {
      final duration = Duration(seconds: message['duration']);

      if (type == FcmEventType.orderConfirmation) {
        _fcmAlertDialog(
          title: const Text('預選乘客'),
          content: Text('離乘客起點尚需 : ${duration.inMinutes}分鐘'),
          confirmButtonName: '開始訂單',
          cancelButtonName: '掰掰',
        );
      } else if (type == FcmEventType.paired) {
        // Assign fcm pairedData to field.
        final Map<String, dynamic> pairedData = message['pairedData'];

        _fcmAlertDialog(
          title: const Text('暨大搭便車'),
          content: Text('已經完成配對囉～'),
          confirmButtonName: '了解',
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
      }
    }

    // TEST
    // Notification Message
    _fcmAlertDialog(
      title: Text(message['notification']['title'] ?? message['data']['name']),
      content: Text(message['notification']['body'] ?? message['data']['name']),
      confirmButtonName: '確認',
      cancelButtonName: '掰掰',
    );
  }

  /// Define a basic UI of alert dialog for incoming fcm event.
  Future<void> _fcmAlertDialog({
    @required Widget title,
    @required Widget content,
    @required String confirmButtonName,
    String cancelButtonName,
    bool barrierDismissible,
  }) {
    return showDialog(
      context: _context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        actions: <Widget>[
          if (cancelButtonName != null)
            FlatButton(
              child: Text(cancelButtonName,
                  style: const TextStyle(
                    color: Colors.grey,
                  )),
              onPressed: _confirmCallback('cancel'),
            ),
          FlatButton(
            child: Text(confirmButtonName),
            onPressed: _confirmCallback('success'),
          )
        ],
        title: title,
        content: content,
      ),
    );
  }

  /// [_confirmCallback] method returns a callback method that conducts
  /// the request of [OrderConfirmationRequest] with a given [status].
  ///
  /// * [status] is String type variable that determines if a paired
  /// order is valid.
  VoidCallback _confirmCallback(String status) => () {
        Navigator.pop(_context);

        _roleProvider.isMatched = (status == 'success');

        _api.sendHttpRequest(
          OrderConfirmationRequest(
            status: status,
            jwtToken: '',
          ),
        );
      };
}
