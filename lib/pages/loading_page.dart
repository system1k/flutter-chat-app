import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/pages/pages.dart';
import 'package:chat_app/services/auth_services.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginState(context),
      builder: (context, snapshot) {
        return const Center(
          child: Text('Espere...') 
        );
      }
    );
  }

  Future checkLoginState(BuildContext context) async {
    
    final authService = Provider.of<AuthServices>(context, listen: false);
    final authenticated = await authService.isLoggedIn();

     if(authenticated) {
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => UsersPage(),
        transitionDuration: const Duration(milliseconds: 0)
      ));
    } else {
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoginPage(),
        transitionDuration: const Duration(milliseconds: 0)
      ));
    }

  }

 
}