import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        // Navigate to login page or any other initial page after logout
        // For example, navigate to LoginPage:
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
      child: Text('Logout'),
    );
  }
}
