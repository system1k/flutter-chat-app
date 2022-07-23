import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';

class AuthServices with ChangeNotifier {

  late Usuario usuario;
  bool _authenticating = false;
  final _storage = const FlutterSecureStorage();

  bool get authenticating => _authenticating;
  
  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }
  
  Future<bool> login(String email, String password) async {

    authenticating = true;

    final Map data = {
      'email' : email,
      'password' : password
    };

    final url = Uri.parse('${Environment.apiURL}/login');

    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: { 'Content-Type' : 'application/json' }
    ); 

    authenticating = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      return false;
    }

  }

  Future register(String name, String email, String password) async {

    authenticating = true;

    final Map data = {
      'name'  : name,
      'email' : email,
      'password' : password
    };

    final url = Uri.parse('${Environment.apiURL}/login/new');

    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: { 'Content-Type' : 'application/json' }
    ); 

    authenticating = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }

  }

  Future<bool> isLoggedIn() async {

    final token = await _storage.read(key: 'token');

    final url = Uri.parse('${Environment.apiURL}/login/renew');

    final resp = await http.get(
      url,
      headers: { 
        'Content-Type' : 'application/json',
        'x-token' : token! 
      }
    ); 
   
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }

  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    return await _storage.delete(key: 'token');
  }

}