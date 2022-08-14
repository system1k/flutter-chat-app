import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/pages/pages.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/socket_services.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginState(context),
      builder: (context, snapshot) {
        return const Scaffold(
          body: Center(
            child: Text('Espere...') 
          )
        );
      }
    );
  }

  Future checkLoginState(BuildContext context) async {
    
    final authService = Provider.of<AuthServices>(context, listen: false);
    final socketService = Provider.of<SocketServices>(context, listen: false);
    final authenticated = await authService.isLoggedIn();

     if(authenticated) {
      socketService.connect();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => const UsersPage(),
        transitionDuration: const Duration(milliseconds: 0)
      ));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionDuration: const Duration(milliseconds: 0)
      ));
    }

  }

 
}