import 'dart:async';

import 'package:flutter/Material.dart';

import 'package:adhara_socket_io/adhara_socket_io.dart';

import '../../resources/repository.dart';

class SocketHandler {
  SocketHandler._();

  factory SocketHandler() {
    return _socketHandler;
  }

  static final _socketHandler = SocketHandler._();

  final SocketIOManager _manager = SocketIOManager();
  SocketIO _socket;
  bool _isConnected;

  final _driverPositionController = StreamController<Map<String, String>>();
  final _revokeDriverPositionController = StreamController<String>();
  final _chatController = StreamController<Map<String, dynamic>>();

  bool get isConnected => _isConnected;

  /// {'lat': XXX, 'lng': XXX, 'heading': XXX}
  Stream<Map<String, String>> get getDriverPositionStream =>
      _driverPositionController.stream;
  Stream<String> get getRevokeDriverPositionStream =>
      _revokeDriverPositionController.stream;
  Stream<Map<String, dynamic>> get getChatStream => _chatController.stream;
  
  Future<SocketIO> connectSocketServer() async {
    if (!_isConnected) {
      _socket = await _manager.createInstance('https://socket.hitchhike.ml');
      _socket.connect();
      _isConnected = true;
      _subscribeEvents();

      return _socket;
    } else {
      return null;
    }
  }

  Future<void> disconnetSocket() async {
    if (_isConnected) {
      _isConnected = false;
      await _manager.clearInstance(_socket);
    }
  }

  void emitEvent({
    @required String eventName,
    @required dynamic content,
  }) {
    _socket.emit(eventName, content);
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
      eventName: SocketEventName.chat,
      sink: _chatController.sink,
    );
  }

  _addDataToSink({
    @required String eventName,
    @required StreamSink sink,
  }) {
    _socket.on(eventName, (data) => sink.add(data));
  }

  dispose() {
    _driverPositionController.close();
    _revokeDriverPositionController.close();
    _chatController.close();
  }
}
