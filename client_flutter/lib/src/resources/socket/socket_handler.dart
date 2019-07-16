import 'package:adhara_socket_io/adhara_socket_io.dart';

class SocketHandler {
  SocketHandler._();

  factory SocketHandler() {
    return _socketHandler;
  }

  static final _socketHandler = SocketHandler._();

  final SocketIOManager _manager = SocketIOManager();
  SocketIO _socket;
  bool _isConnected;

  bool get isConnected => _isConnected;

  Future<SocketIO> connectSocketServer() async {
    _socket = await _manager.createInstance('https://socket.hitchhike.ml');
    _socket.connect();
    _isConnected = true;
    return _socket;
  }

  Future<void> disconnetSocket() async {
    if (_isConnected) {
      _isConnected = false;
      await _manager.clearInstance(_socket);
    }
  }
}
