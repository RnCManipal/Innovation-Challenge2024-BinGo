// ignore: unused_import
import 'package:bingo/HomePage.dart';

import 'LoginPage.dart';
import 'SignupPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const int _customLightCyanPrimaryValue = 0xFFE0FFFF;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
      ),
      home: const HomePage(),
    );
  }
}
