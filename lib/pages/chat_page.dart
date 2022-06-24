import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWritting = false;
  
  final List<ChatMessage> _messages = [];  

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
    return AppBar(
      centerTitle: true,
      elevation: 1,
      backgroundColor: Colors.white,
      title: Column(
        children: [

          CircleAvatar(
            backgroundColor: Colors.blue[100],
            maxRadius: 14,
            child: const Text('JF', style: TextStyle(fontSize: 12, color: Colors.black87))
          ),

          const SizedBox(height: 3),

          const Text('Julio Fermín', style: TextStyle(fontSize: 12, color: Colors.black87))

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
      uid: '123',
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 400))
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWritting = false;
    });

  }

  @override
  void dispose() {
    
    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}