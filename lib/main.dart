import 'package:flutter/material.dart';

import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Perfect Ad',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        brightness: Brightness.dark,
        canvasColor: Colors.black87,
        // dividerTheme: const DividerThemeData(
        //   thickness: 1,
        //   color: Colors.cyanAccent,
        // ),
      ),
      home: HomePage(),
    );
  }
}