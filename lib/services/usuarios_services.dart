import 'package:http/http.dart' as http;

import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/usuarios_response.dart';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_services.dart';

class UsuariosService {

  Future<List<Usuario>> getUsuarios() async {

    final url = Uri.parse('${Environment.apiURL}/usuarios');

    try {

      final resp = await http.get(url, headers : {
        'Content-Type' : 'application/json',
        'x-token' : await AuthServices.getToken() ?? ''
      });

      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios;
      
    } catch (e) {
      return [];
    }

  }

}