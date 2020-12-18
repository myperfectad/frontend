import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          headline1: GoogleFonts.righteous(),
          headline2: GoogleFonts.righteous(),
          headline3: GoogleFonts.righteous(),
          headline4: GoogleFonts.righteous(),
          headline5: GoogleFonts.righteous(),
          headline6: GoogleFonts.righteous(),
        )),
      home: ChangeNotifierProvider(
        create: (context) => SearchModel(),
        child: HomePage(),
      ),
    );
  }
}
