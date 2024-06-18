import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // useMaterial3 is deprecated, no longer needed
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Determine a minimum height for the container
    double minButtonHeight = screenSize.height * 0.055;
    double minHeight = screenSize.height * 0.42;
    if (screenSize.height <= 690) {
      // Adjust minimum height for smaller screens
      minHeight = screenSize.height * 0.48;
      minButtonHeight = screenSize.height * 0.063;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE0FFFF),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image(image: AssetImage('Images/Ellipse 1.png'), height: screenSize.height * 0.15),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image(image: AssetImage('Images/Bonsai.png'), height: screenSize.height * 0.15),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image(image: AssetImage('Images/Natural Food.png'), height: screenSize.height * 0.16),
          ),
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
              onTap: () {
                // Handle tap action here
                print("Container clicked!");
              },
              child: Ink(
                width: screenSize.width * 0.9,
                height: screenSize.height * 0.07,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: screenSize.width * 0.005,
                      blurRadius: screenSize.width * 0.02,
                      offset: Offset(0, screenSize.width * 0.01), // Corrected offset type
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
                // Implement the forgot password action
                print("Forgot password clicked!");
              },
              child: Container(
                width: screenSize.width * 0.9,
                height: minHeight, // Set the minimum height here
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: screenSize.width * 0.005,
                      blurRadius: screenSize.width * 0.02,
                      offset: Offset(0, screenSize.width * 0.01), // Corrected offset type
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: screenSize.height * 0.03),
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
                    SizedBox(height: screenSize.height * 0.015),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                      child: SizedBox(
                        width: screenSize.width * 0.85,
                        child: TextField(
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
                              borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                            ),
                            hintText: 'Enter your username',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.03),
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
                    SizedBox(height: screenSize.height * 0.015),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                      child: SizedBox(
                        width: screenSize.width * 0.85,
                        child: TextField(
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
                              borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                            ),
                            hintText: 'Enter your password',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
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
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.3),
                      child: SizedBox(
                        width: screenSize.width * 0.3,
                        height: minButtonHeight, // Adjust height here
                        child: TextButton(
                          onPressed: () {
                            // Handle login button action
                            print("Login button clicked!");
                          },
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
    );
  }
}
