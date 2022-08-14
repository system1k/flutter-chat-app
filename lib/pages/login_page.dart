import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/helpers/mostar_alerta.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/socket_services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [      
                
                Logo(title: 'Messenger'),
                _Form(),
                Labels(
                  routeName: 'register', 
                  text1: '¿No tienes cuenta?', 
                  text2: '¡Crea una ahora!',
                ),
                _CustomText(),
                                
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthServices>(context);
    final socketService = Provider.of<SocketServices>(context);

    void _verificacion(bool value) {
      if (value) {
        socketService.connect();
        Navigator.pushReplacementNamed(context, 'users');
      } else {
        mostarAlerta(context, 'Login incorrecto', 'Revise sus credenciales de acceso');
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            controller: emailCtrl,
          ),

          CustomInput(
            icon: Icons.lock_outlined,
            placeholder: 'Contraseña',
            isPassword: true,
            controller: passCtrl,
          ),

          BlueButton(
            text: 'Ingresar', 
            onPressed: authService.authenticating 
              ? () => null 
              : () async {
                  FocusScope.of(context).unfocus();
                  final loginOk = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());

                  _verificacion(loginOk);

                }
          )

        ],
      ),
    );
  }
}

class _CustomText extends StatelessWidget {
  const _CustomText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Términos y condiciones de uso',
      style: TextStyle(fontWeight: FontWeight.w200)
    );
  }
}
