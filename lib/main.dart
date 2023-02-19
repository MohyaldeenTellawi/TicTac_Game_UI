import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromRGBO(225, 193, 110, 1),
        shadowColor: const Color.fromRGBO(53, 57, 53, 1),
        splashColor: Colors.blue
      ),
      home: const HomePage(),
    );
  }
}

