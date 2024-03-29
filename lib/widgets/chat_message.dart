import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/auth_services.dart';

class ChatMessage extends StatelessWidget {
  
  final String text;
  final String uid;
  final AnimationController animationController;
  
  const ChatMessage({
    Key? key, 
    required this.text, 
    required this.uid, 
    required this.animationController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController, 
          curve: Curves.easeOut
        ),
        child: Container(
          child: (uid == authServices.usuario!.uid)
            ? _MyMessage(text)
            : _NotMyMessage(text)
        ),
      ),
    );
  }
}

class _MyMessage extends StatelessWidget {
  
  final String text;
  const _MyMessage(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(
          bottom: 5,
          left: 50,
          right: 5
        ),
        decoration: BoxDecoration(
          color: const Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(text, style: const TextStyle(color: Colors.white))
      )
    );
  }
}

class _NotMyMessage extends StatelessWidget {

  final String text;
  const _NotMyMessage(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(
          bottom: 5,
          left: 5,
          right: 50
        ),
        decoration: BoxDecoration(
          color: const Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(text, style: const TextStyle(color: Colors.black87))
      )
    );
  }
}