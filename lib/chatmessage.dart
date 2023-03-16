import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
       this.text,
      required this.sender,
      this.isImage = false,  this.userDefault});

  final String? text;
  final List<String>? userDefault;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
      child: Align(
        alignment: (sender == "user"?Alignment.topRight:Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (sender  == "user"?Colors.red.shade100:Colors.blue[200]),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(text!, style: const TextStyle(fontSize: 15),)
        ),
      ),
    );
  }
}
