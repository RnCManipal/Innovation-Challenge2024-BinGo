import 'package:bingo/SignupPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart'; // Import your HomePage
import 'ResetPasswordPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Google login
  // void click() async {
  //   try {
  //     final User? googleUser = await signInWithGoogle();

  //     if (googleUser != null) {
  //       setState(() {
  //         user = googleUser;
  //       });

  //       // Navigate to HomePage after successful login
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomePage()),
  //       );
  //     } else {
  //       // Handle sign-in failure if needed
  //       print('Sign-in with Google failed');
  //     }
  //   } catch (e) {
  //     print('Error signing in with Google: $e');
  //     // Handle sign-in error
  //   }
  // }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      if (!mounted){
        showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Creating account..."),
          ],
        ),
      );
    },
  );

      };
      print('Error signing in with email and password: $e');
      throw e; // Re-throw the exception to handle it in the UI if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    double minButtonHeight = screenSize.height * 0.055;
    double minHeight = screenSize.height * 0.42;
    if (screenSize.height <= 690) {
      minHeight = screenSize.height * 0.48;
      minButtonHeight = screenSize.height * 0.063;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE0FFFF),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenSize.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset('Images/Ellipse 1.png',
                    height: screenSize.height * 0.15),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset('Images/Bonsai.png',
                    height: screenSize.height * 0.15),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset('Images/Natural Food.png',
                    height: screenSize.height * 0.16),
              ),
              Positioned(
                  top: screenSize.height * 0.05,
                  left: screenSize.width * 0.05,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        );
                      },
                      child: const Image(
                        image: AssetImage('Images/BackButton.png'),
                      ))),
              Positioned(
                top: screenSize.height * 0.15,
                left: screenSize.width * 0.1,
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.1,
                  ),
                ),
              ),
              Positioned(
                top: screenSize.height * 0.25,
                left: screenSize.width * 0.05,
                child: InkWell(
                  // onTap: () {click},
                  child: Ink(
                    width: screenSize.width * 0.9,
                    height: screenSize.height * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: screenSize.width * 0.005,
                          blurRadius: screenSize.width * 0.02,
                          offset: Offset(0, screenSize.width * 0.01),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'Images/glogo.png',
                          width: screenSize.width * 0.06,
                          height: screenSize.width * 0.06,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Continue with Google",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.54),
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenSize.height * 0.33,
                left: screenSize.width * 0.15,
                child: SizedBox(
                  width: screenSize.width * 0.9,
                  height: screenSize.height * 0.04,
                  child: Text(
                    "-----------------  or  -----------------",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      fontSize: screenSize.width * 0.05,
                      color: Colors.black.withOpacity(0.80),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenSize.height * 0.38,
                left: screenSize.width * 0.05,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Container(
                    width: screenSize.width * 0.9,
                    height: minHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: screenSize.height * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: Text(
                            "Email:",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: SizedBox(
                            width: screenSize.width * 0.85,
                            child: TextField(
                              controller: _emailController,
                              obscureText: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF0F0F0),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(
                                      screenSize.width * 0.02),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(
                                      screenSize.width * 0.1),
                                ),
                                hintText: 'Enter your username',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: Text(
                            "Password:",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: SizedBox(
                            width: screenSize.width * 0.85,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF0F0F0),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(
                                      screenSize.width * 0.02),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(
                                      screenSize.width * 0.1),
                                ),
                                hintText: 'Enter your password',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: screenSize.width * 0.03,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.3),
                          child: SizedBox(
                            width: screenSize.width * 0.3,
                            height: minButtonHeight,
                            child: TextButton(
                              onPressed: () {
                                signInWithEmailAndPassword(
                                        _emailController.text,
                                        _passwordController.text)
                                    .then((user) {
                                  if (user != null) {
                                    // Navigate to HomePage after successful login
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()),
                                    );
                                  } else {
                                    // Handle sign-in failure if needed
                                    print(
                                        'Sign-in with email and password failed');
                                  }
                                }).catchError((e) {
                                  // Handle sign-in error
                                  print(
                                      'Error signing in with email and password: $e');
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Login Failed"),
                                        content: Text(e.toString()),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF0092D1)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: screenSize.height * 0.015),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width * 0.02),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
