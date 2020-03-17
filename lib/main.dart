import 'package:flutter/material.dart';
import './Splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LeanEdit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splashscreen(),
    );
  }
}


