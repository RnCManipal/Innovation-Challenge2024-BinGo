import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResendEmailVerifyPage extends StatefulWidget {
  const ResendEmailVerifyPage({Key? key}) : super(key: key);

  @override
  _ResendEmailVerifyPageState createState() => _ResendEmailVerifyPageState();
}

class _ResendEmailVerifyPageState extends State<ResendEmailVerifyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isProcessing = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    User? user = _auth.currentUser;

    if (user == null) {
      setState(() {
        _message = 'No user is signed in. Please sign in.';
      });
    } else if (user.emailVerified) {
      setState(() {
        _message = 'Your email is already verified.';
      });
    } else {
      setState(() {
        _message = 'Your email is not verified. Please request a new verification email.';
      });
    }
  }

  Future<void> _handleLoginAndResendEmail() async {
    setState(() {
      _isProcessing = true;
      _message = ''; // Clear previous message
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() {
          _message = 'Verification email sent. Please check your inbox.';
        });
      } else if (user != null && user.emailVerified) {
        setState(() {
          _message = 'Your email is already verified.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Failed to sign in or send verification email. Please check your credentials and try again.';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE0FFFF),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Resend Verification",
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.width * 0.08,
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              Container(
                padding: EdgeInsets.all(screenSize.width * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: screenSize.width * 0.005,
                      blurRadius: screenSize.width * 0.02,
                      offset: Offset(0, screenSize.width * 0.01),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      "We need you to sign in to verify your email.",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: screenSize.width * 0.04,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    ElevatedButton(
                      onPressed: _isProcessing ? null : _handleLoginAndResendEmail,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF0092D1)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                          ),
                        ),
                      ),
                      child: Center(
                        child: _isProcessing
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Resend Email",
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      _message,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: screenSize.width * 0.04,
                        fontWeight: FontWeight.normal,
                        color: _message.contains('Failed') ? Colors.red : Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
