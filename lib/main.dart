import 'package:flutter/material.dart';
import 'screens/login_screens.dart';

void main() {
  runApp(const PapacapimApp());
}

class PapacapimApp extends StatelessWidget {
  const PapacapimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Papacapim',

      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      home: LoginScreens(),
    );
  }
}