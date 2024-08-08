import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'HomePage.dart'; // Assuming you have a HomePage widget definedgit 
import 'SignupPage.dart'; // Assuming you have a SignupPage widget defined

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              // User is authenticated, navigate to HomePage
              return HomePage();
            } else {
              // No user authenticated, navigate to SignupPage or LoginPage
              return const SignupPage(); // You can replace this with LoginPage or any other widget
            }
          }
        },
      ),
    );
  }
}
