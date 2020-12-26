import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'homepage/homepage.dart';
import 'homepage/search_model.dart';

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
        accentColor: Colors.cyanAccent,
        brightness: Brightness.dark,
        canvasColor: Colors.black87,
        // dividerTheme: const DividerThemeData(
        //   thickness: 1,
        //   color: Colors.cyanAccent,
        // ),
        fontFamily: 'OpenSans',
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: 'RingBells', color: Colors.white),
          headline2: TextStyle(fontFamily: 'RingBells', color: Colors.white),
          headline3: TextStyle(fontFamily: 'RingBells', color: Colors.white),
          headline4: TextStyle(fontFamily: 'RingBells', color: Colors.white),
        )),
      home: ChangeNotifierProvider(
        create: (context) => SearchModel(),
        child: HomePage(),
      ),
    );
  }
}
