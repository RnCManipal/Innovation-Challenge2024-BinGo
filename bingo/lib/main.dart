// ignore: unused_import
import 'package:bingo/HomePage.dart';
import 'package:bingo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'LoginPage.dart';
import 'SignupPage.dart';
import 'package:flutter/material.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
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
      initialRoute: '/login', // Initial route should point to your login page
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        // Add other routes if needed
      },
    );
  }
}
