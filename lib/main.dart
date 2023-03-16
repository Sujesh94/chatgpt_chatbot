import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'chat_screen.dart';

void main() {
  FlavorConfig(
    name: "Beta",
    color: Colors.red,
    location: BannerLocation.bottomStart,
    variables: {
      "counter": 5,
      "baseUrl": "https://www.oceanix.cloud",
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      color: const Color(0xFF1C24A7),
      location: BannerLocation.topStart,
      child: MaterialApp(
        title: 'ChatGPT Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
