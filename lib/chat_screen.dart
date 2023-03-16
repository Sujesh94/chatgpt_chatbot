import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chatmessage.dart';
import 'threedots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;
  bool _isImageSearch = false;

  StreamSubscription? _subscription;
  bool _isTyping = false;

  List<String> listTile = [
    "Vessel Performance ",
    "CII in vessel",
    "Environmental restriction by European union",
    "Fuel consumption",
    "Add your own query?"
  ];

  @override
  void initState() {
    super.initState();

    chatGPT = ChatGPT.instance.builder(
        "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",
        orgId: "");
  }

  @override
  void dispose() {
    chatGPT!.genImgClose();
    _subscription?.cancel();
    super.dispose();
  }

  // Link for api - https://beta.openai.com/account/api-keys

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
      isImage: false,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    if (_isImageSearch) {
      final request = GenerateImage(message.text.toString(), 1, size: "256x256");

      _subscription = chatGPT
          ?.builder("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",
              orgId: "")
          .generateImageStream(request)
          .asBroadcastStream()
          .listen((response) {
        Vx.log(response.data!.last!.url!);
        insertNewData(response.data!.last!.url!, isImage: true);
      });
    } else {
      final request = CompleteReq(
          prompt: message.text.toString() , model: kTranslateModelV3, max_tokens: 200);

      _subscription = chatGPT
          ?.builder("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",
              orgId: "")
          .onCompleteStream(request: request)
          .asBroadcastStream()
          .listen((response) {
        Vx.log(response!.choices[0].text);
        insertNewData(response.choices[0].text, isImage: false);
      });
    }
  }

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "bot",
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: const InputDecoration.collapsed(
                hintText: "Question/description"),
          ),
        ),
        ButtonBar(
          children: [
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _isImageSearch = false;
                _sendMessage();
              },
            ),
            TextButton(
                onPressed: () {
                  _isImageSearch = true;
                  _sendMessage();
                },
                child: const Icon(
                  Icons.image_search,
                  color: Colors.black,
                ))
          ],
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("ChatBot"),
            //Icon(Icons.chat_outlined)
          ],
        )),
        body: SafeArea(
          child: Column(
            children: [
              // Flexible(
              //   child: GridView.builder(
              //     //shrinkWrap: true,
              //     padding: EdgeInsets.zero,
              //     physics: const NeverScrollableScrollPhysics(),
              //     //reverse: true,
              //     //padding: Vx.m8,
              //     itemCount: listTile.length,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         dense: true,
              //         visualDensity: const VisualDensity(vertical: -3),
              //         // shape: RoundedRectangleBorder(
              //         //   side: BorderSide(width: 1),
              //         //   borderRadius: BorderRadius.circular(30),
              //         // ),
              //         //tileColor: Colors.red,
              //         title: Text(listTile[index]),
              //         onTap: () {
              //           setState(() {
              //             _controller.text = listTile[index];
              //           });
              //         },
              //       );
              //     },
              //     gridDelegate:
              //         const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 3,
              //       crossAxisSpacing: 1.0,
              //       mainAxisSpacing: 1.0,
              //     ),
              //   ),
              // ),
              Flexible(
                  child: ListView.builder(
                //shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                // physics: const NeverScrollableScrollPhysics(),
                reverse: true,
                // padding: Vx.m8,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
              ),
              if (_isTyping) const ThreeDots(),
              const Divider(
                height: 1.0,

              ),
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                ),
                child: _buildTextComposer(),
              )
            ],
          ),
        ));
  }
}
