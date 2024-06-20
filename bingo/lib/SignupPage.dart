import 'package:bingo/HomePage.dart';
import 'package:bingo/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  User? user;

  @override
  void initState() {
    super.initState();

    // Check if the user is already authenticated
    User? currentUser = FirebaseAuth.instance.currentUser;

    // If user is already authenticated, navigate to HomePage
    if (currentUser != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    }
  }

  void click() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? newUser = userCredential.user;

      if (newUser != null) {
        setState(() {
          user = newUser;
        });
        // Navigate to HomePage after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Handle sign-in failure if needed
        print('Sign-in with Google failed');
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      // Handle sign-in error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Determine a minimum height for the container
    double minButtonHeight = screenSize.height * 0.06;
    double minHeight = screenSize.height * 0.6;
    if (screenSize.height <= 690) {
      // Adjust minimum height for smaller screens
      minHeight = screenSize.height * 0.5;
      minButtonHeight = screenSize.height * 0.045;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE0FFFF),
      resizeToAvoidBottomInset:
          false, // Prevent the keyboard from resizing the screen
      body: SingleChildScrollView(
        // Make the whole screen scrollable
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
                    // Handle tap action here
                    click();
                  },
                  child: Ink(
                    width: screenSize.width * 0.9,
                    height: screenSize.height * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.5),
                          spreadRadius: screenSize.width * 0.005,
                          blurRadius: screenSize.width * 0.02,
                          offset: Offset(0,
                              screenSize.width * 0.01), // Corrected offset type
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
                    height: minHeight, // Set the minimum height here
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(120, 0, 0, 0).withOpacity(0.5),
                          spreadRadius: screenSize.width * 0.005,
                          blurRadius: screenSize.width * 0.02,
                          offset: Offset(
                              0,
                              screenSize.height *
                                  0.01), // Corrected offset type
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: screenSize.height * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: SizedBox(
                            height: screenSize.height * 0.068,
                            width: screenSize.width * 0.85,
                            child: TextField(
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
                                hintText: 'Enter your name',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: SizedBox(
                            height: screenSize.height * 0.068,
                            width: screenSize.width * 0.85,
                            child: TextField(
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
                                hintText: 'Enter your username',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
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
                        SizedBox(height: screenSize.height * 0.01),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: SizedBox(
                            height: screenSize.height * 0.068,
                            width: screenSize.width * 0.85,
                            child: TextField(
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
                                hintText: 'Enter your Password',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: SizedBox(
                            height: screenSize.height * 0.068,
                            width: screenSize.width * 0.85,
                            child: TextField(
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
                                hintText: 'Enter Password Again',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.3),
                          child: SizedBox(
                            width: screenSize.width * 0.3,
                            height: minButtonHeight, // Adjust height here
                            child: TextButton(
                              onPressed: () {
                                // Handle login button action
                                print("Conitnue button clicked!");
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF0092D1)),
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
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
              Positioned(
                  top: screenSize.height * 0.94,
                  left: screenSize.width * 0.63,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the login page when tapped
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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
