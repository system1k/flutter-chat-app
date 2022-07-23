import 'dart:io';

class Environment {

  static String apiURL = Platform.isAndroid ? 'http://10.25.1.22:8080/3000/api' : 'http://localhost/3000/api';
  static String socketURL = Platform.isAndroid ? 'http://10.25.1.22:8080/3000' : 'http://localhost/3000'; 

}