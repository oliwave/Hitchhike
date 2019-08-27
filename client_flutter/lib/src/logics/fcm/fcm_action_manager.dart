import 'package:flutter/material.dart';

import '../notify_manager.dart';
import '../../provider/provider_collection.dart' show RoleProvider;

class FcmActionManager extends NotifyManager {
  FcmActionManager(notifyListeners) : super(notifyListeners);

  Map<String, dynamic> _message;
  BuildContext _context;

  final RoleProvider _roleProvider = RoleProvider();

  void messageConsumer(Map<String, dynamic> message, BuildContext context) {
    _message = message;
    _context = context;

    _roleProvider.isMatched = true;

    /**
     * Formal Ccode
     */
    // Data Message
    if (_message['notification'] == null) {
      _showFcmDialog();
    }
    
    // Notification Message
    _showFcmDialog();
  }

  void _showFcmDialog() {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text('確認'),
            onPressed: () {
              Navigator.pop(_context);
            },
          )
        ],
        title:
            Text(_message['notification']['title'] ?? _message['data']['name']),
        content:
            Text(_message['notification']['body'] ?? _message['data']['name']),
      ),
    );
  }
}
