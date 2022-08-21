import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/user.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/models/mensajes_response.dart';

class ChatServices with ChangeNotifier {

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat( String usuarioID) async { 

    final url = Uri.parse('${Environment.apiURL}/mensajes/$usuarioID');

    final resp = await http.get(url, headers: {
      'Content-Type' : 'application/json',
      'x-token' : await AuthServices.getToken() ?? ''
    });

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;

  }

}