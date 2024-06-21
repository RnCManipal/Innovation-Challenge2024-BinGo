import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart'; // Replace with your home page import
import 'LoginPage.dart'; // Replace with your login page import

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  User? user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check if the user is already authenticated
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Navigate to HomePage if user is already logged in
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    }
  }

  Future<void> _registerWithEmailAndPassword() async {
    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        throw 'Passwords do not match';
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );

      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text,
        'email': _usernameController.text,
      });

      setState(() {
        user = userCredential.user;
      });

      // Navigate to HomePage after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print('Error registering with email and password: $e');
      // Handle registration failure if needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registration Failed"),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    double minButtonHeight = screenSize.height * 0.06;
    double minHeight = screenSize.height * 0.6;
    if (screenSize.height <= 690) {
      minHeight = screenSize.height * 0.5;
      minButtonHeight = screenSize.height * 0.045;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE0FFFF),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenSize.height,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  'Images/Bg.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: screenSize.height * 0.1,
                left: screenSize.width * 0.1,
                child: Text(
                  "Create a Free\nAccount",
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.08,
                  ),
                ),
              ),
              Positioned(
                top: screenSize.height * 0.225,
                left: screenSize.width * 0.05,
                child: InkWell(
                  onTap: () {
                    // Implement Google sign-in here if needed
                  },
                  child: Ink(
                    width: screenSize.width * 0.9,
                    height: screenSize.height * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
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
                top: screenSize.height * 0.29,
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
                top: screenSize.height * 0.33,
                left: screenSize.width * 0.05,
                child: GestureDetector(
                  child: Container(
                    width: screenSize.width * 0.9,
                    height: minHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(120, 0, 0, 0).withOpacity(0.5),
                          spreadRadius: screenSize.width * 0.005,
                          blurRadius: screenSize.width * 0.02,
                          offset: Offset(0, screenSize.height * 0.01),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: screenSize.height * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: Text(
                            "Name:",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: SizedBox(
                            height: screenSize.height * 0.068,
                            width: screenSize.width * 0.85,
                            child: TextField(
                              controller: _nameController,
                              obscureText: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF0F0F0),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.1),
                                ),
                                hintText: 'Enter your name',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: Text(
                            "Username:",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: SizedBox(
                            height: screenSize.height * 0.068,
                            width: screenSize.width * 0.85,
                            child: TextField(
                              controller: _usernameController,
                              obscureText: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF0F0F0),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.1),
                                ),
                                hintText: 'Enter your username',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: Text(
                            "Password:",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: SizedBox(
                            height: screenSize.height * 0.068,
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
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.1),
                                ),
                                hintText: 'Enter your Password',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: Text(
                            "Confirm Password:",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                          child: SizedBox(
                            height: screenSize.height * 0.068,
                            width: screenSize.width * 0.85,
                            child: TextField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF0F0F0),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.1),
                                ),
                                hintText: 'Enter Password Again',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.3),
                          child: SizedBox(
                            width: screenSize.width * 0.3,
                            height: minButtonHeight,
                            child: TextButton(
                              onPressed: _registerWithEmailAndPassword,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color(0xFF0092D1)),
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
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.042,
                                    fontWeight: FontWeight.normal,
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
              Positioned(
                top: screenSize.height * 0.946,
                left: screenSize.width * 0.15,
                child: Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.normal,
                    fontSize: screenSize.width * 0.04,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Positioned(
                top: screenSize.height * 0.94,
                left: screenSize.width * 0.63,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: screenSize.height * 0.03,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 98, 255, 0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
