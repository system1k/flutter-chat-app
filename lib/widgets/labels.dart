import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  
  final String routeName;
  final String text1;
  final String text2;
  
  const Labels({
    Key? key, 
    required this.routeName, 
    required this.text1, 
    required this.text2
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
          text1, 
          style: const TextStyle(
            color: Colors.black54, 
            fontSize: 15, fontWeight: 
            FontWeight.w300
          )
        ),

        const SizedBox(height: 10),

        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, routeName),
          child: Text(
            text2, 
            style: TextStyle(
              color: Colors.blue[600], 
              fontSize: 18, 
              fontWeight: FontWeight.bold
            )
          ),
        )

      ],
    );
  }
}