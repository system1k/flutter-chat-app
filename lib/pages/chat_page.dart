import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:chat_app/services/socket_services.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/models/mensajes_response.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWritting = false;

  late ChatServices chatServices;
  late SocketServices socketServices;
  late AuthServices authServices;
  
  final List<ChatMessage> _messages = [];  

  @override
  void initState() {    
    super.initState();

    chatServices   = Provider.of<ChatServices>(context, listen: false);
    socketServices =  Provider.of<SocketServices>(context, listen: false);
    authServices =  Provider.of<AuthServices>(context, listen: false);

    socketServices.socket.on('mensaje-personal', _listenMessage);

    _cargarHistorial(chatServices.usuarioPara.uid);
  }

  void _listenMessage(dynamic payload){
    
    ChatMessage message = ChatMessage(
      text: payload['mensaje'],
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  void _cargarHistorial(String uid) async {

    List<Mensaje> chat = await chatServices.getChat(uid);

    final history = chat.map((msg) => ChatMessage(
      text: msg.mensaje,
      uid: msg.de,
      animationController: AnimationController(
        vsync: this, 
        duration: const Duration(milliseconds: 0)
      )..forward()
    ));

    setState( () => _messages.insertAll(0, history) );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: Column(
        children: [
          
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true
            )
          ),

          const Divider(height: 1),

          Container(
            color: Colors.white,
            child: _inputChat()
          )

        ],
      )
    );
  }

  AppBar _customAppBar() {

    final usuarioPara = chatServices.usuarioPara;

    return AppBar(
      centerTitle: true,
      elevation: 1,
      backgroundColor: Colors.white,
      title: Column(
        children: [

          CircleAvatar(
            backgroundColor: Colors.blue[100],
            maxRadius: 14,
            child: Text(
              usuarioPara.nombre.substring(0,2), 
              style: const TextStyle(fontSize: 12, color: Colors.black87)
            )
          ),

          const SizedBox(height: 3),

          Text(usuarioPara.nombre, style: const TextStyle(fontSize: 12, color: Colors.black87))

        ],
      ),
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (text) {
                  setState(() {
                    if(_textController.text.trim().isNotEmpty) {
                      _isWritting = true;
                    } else {
                      _isWritting = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _isWritting
                      ? () => _handleSubmit(_textController.text.trim())
                      : null,
                    child: const Text('Enviar')
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
                        onPressed: _isWritting
                          ? () => _handleSubmit(_textController.text.trim())
                          : null
                      ),
                    ),
                  )  
            )

          ],
        ),
      )
    );
  }

  _handleSubmit(String text){

    if(text.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: text, 
      uid: authServices.usuario!.uid,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 400))
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState( () => _isWritting = false );

    socketServices.emit('mensaje-personal', {
      'de' : authServices.usuario!.uid,
      'para' : chatServices.usuarioPara.uid,
      'mensaje' : text
    });

  }

  @override
  void dispose() {
    
    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    socketServices.socket.off('mensaje-personal');

    super.dispose();
  }  
  
}