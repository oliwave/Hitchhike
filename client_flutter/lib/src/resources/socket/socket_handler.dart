import 'dart:async';

import 'package:flutter/Material.dart';

import 'package:adhara_socket_io/adhara_socket_io.dart';

import '../../provider/provider_collection.dart' show AuthProvider;

import '../../resources/repository.dart';

class SocketHandler {
  SocketHandler._();

  factory SocketHandler() {
    return _socketHandler;
  }

  static final _socketHandler = SocketHandler._();

  final SocketIOManager _manager = SocketIOManager();
  final AuthProvider _auth = AuthProvider();
  SocketIO _socket;
  bool _isConnected = false;

  final _driverPositionController = StreamController<Map<String, String>>();
  final _revokeDriverPositionController = StreamController<String>();
  final _previousMessagesController =
      StreamController<List<Map<String, dynamic>>>();
  final _newMessageController = StreamController<Map<String, dynamic>>();

  bool get isConnected => _isConnected;

  /// {'lat': XXX, 'lng': XXX, 'heading': XXX}
  Stream<Map<String, String>> get getDriverPositionStream =>
      _driverPositionController.stream;
  Stream<String> get getRevokeDriverPositionStream =>
      _revokeDriverPositionController.stream;
  Stream<List<Map<String, dynamic>>> get getPreviousMessagesStream =>
      _previousMessagesController.stream;
  Stream<Map<String, dynamic>> get getNewMessageStream =>
      _newMessageController.stream;

  Future<void> connectSocketServer() async {
    if (!_isConnected && _auth.jwt != 'logout') {
      // await disconnetSocket();

      print('Connect to socket serve. JWT is valid.');
      _socket = await _manager.createInstance(
        'https://socket.hitchhike.ml',
        query: {'token': _auth.jwt},
      );

      _socket.connect();

      _isConnected = true;
      _subscribeEvents();
    } else {
      print('Don\'t connect to socket serve. JWT is logout');
    }
  }

  Future<void> disconnetSocket() async {
    if (_isConnected) {
      _isConnected = false;

      try {
        await _manager.clearInstance(_socket);
      } catch (e) {
        print(e);
      }
    }
  }

  void emitEvent({
    @required String eventName,
    @required dynamic content,
  }) {
    _socket.emit(eventName, [content]);
  }

  _subscribeEvents() {
    // The event that driver needs to listen.
    _addDataToSink(
      eventName: SocketEventName.revokeDriverPosition,
      sink: _revokeDriverPositionController.sink,
    );
    // The event that passenger needs to listen.
    _addDataToSink(
      eventName: SocketEventName.driverPosition,
      sink: _driverPositionController.sink,
    );

    _addDataToSink(
      eventName: SocketEventName.previousMessages,
      sink: _previousMessagesController.sink,
    );

    _addDataToSink(
      eventName: SocketEventName.newMessage,
      sink: _newMessageController.sink,
    );
  }

  _addDataToSink({
    @required String eventName,
    @required StreamSink<dynamic> sink,
  }) {
    _socket.on(
      eventName,
      // Convert a Json object to map type.
      (data) => sink.add(data),
    );
  }

  dispose() {
    _driverPositionController.close();
    _revokeDriverPositionController.close();
    _previousMessagesController.close();
    _newMessageController.close();
  }
}
