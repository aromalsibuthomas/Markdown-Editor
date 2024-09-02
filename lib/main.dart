import 'package:flutter/material.dart';

import 'package:markdown_editor/views/home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MarkDown Editor',
      theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: Colors.white)),
      home: const HomeScreen(),
    );
  }
}
