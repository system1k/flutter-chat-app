import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus {
  online,
  offline,
  connecting
}


class SocketServices with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  
  io.Socket get socket => _socket;
  Function get emit => _socket.emit;


  SocketServices(){
    _initConfig();
  }

  void _initConfig() {
    
    // Dart client
    _socket = io.io('http://localhost:3000/', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

  }

}