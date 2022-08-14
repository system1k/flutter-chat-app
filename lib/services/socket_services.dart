import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/global/environment.dart';
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

  void connect() async {

    final token = await AuthServices.getToken();
    
    // Dart client
    _socket = io.io(Environment.socketURL, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew' : true,
      'extraHeaders' : {
        'x-token' : token
      }
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

  void disconnect(){
    _socket.disconnect();
  }

}