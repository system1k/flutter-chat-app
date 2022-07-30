import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/helpers/mostar_alerta.dart';



class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
                
                Logo(title: 'Registro'),
                _Form(),
                Labels(
                  routeName: 'login', 
                  text1: '¿Ya tienes cuenta?', 
                  text2: '¡Iniciar sesión!',
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

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthServices>(context);

    void _verificacion(dynamic value) {
      if (value == true) {
        Navigator.pushReplacementNamed(context, 'users');
      } else {
        mostarAlerta(context, 'Registro incorrecto', value ?? '');      
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            controller: nameCtrl,
          ),
          
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
            text: 'Crear cuenta', 
            onPressed: authService.authenticating 
              ? () => null 
              : () async {
                final registerOk = await authService.register(
                  nameCtrl.text.trim(), 
                  emailCtrl.text.trim(), 
                  passCtrl.text.trim()
                );
                _verificacion(registerOk);
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
