import 'package:bingo/SignupPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

class SignupPageOne extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const SignupPageOne({required this.name, required this.email, required this.password, Key? key}) : super(key: key);

  @override
  _SignupPageOneState createState() => _SignupPageOneState();
}

class _SignupPageOneState extends State<SignupPageOne> {
  String? _selectedAccountType;
  final List<String> _accountTypes = ['User', 'Driver'];

  Future<void> _createAccount() async {
    if (_selectedAccountType == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please select an account type"),
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
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': widget.name,
        'email': widget.email,
        'accountType': _selectedAccountType,
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print('Error creating account: $e');

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Account Creation Failed"),
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
    double minHeight = screenSize.height * 0.25;
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
                top: screenSize.height * 0.11,
                left: screenSize.width * 0.6,
                child: Text(
                  "1/2",
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w100,
                    fontSize: screenSize.width * 0.05,
                  ),
                ),
              ),
              Positioned(
                top: screenSize.height * 0.1,
                left: screenSize.width * 0.1,
                child: Text(
                  "Just a few \nmore steps",
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.08,
                  ),
                ),
              ),
              Positioned(
                  top: screenSize.height * 0.22,
                  left: screenSize.width * 0.08,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>const SignupPage()),
                        );
                      },
                      child: Image(
                        image: AssetImage('Images/BackButton.png'),
                      ))),
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
                            "Type of account:",
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
                          child: Container(
                            height: screenSize.height * 0.068,
                            width: screenSize.width * 0.85,
                            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
                            decoration: BoxDecoration(
                              color: Color(0xFFF0F0F0), // Background color
                              borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedAccountType,
                                hint: Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text('Select an item'),
                                ),
                                isExpanded: true,
                                items: _accountTypes.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(item),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAccountType = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
                        SizedBox(height: screenSize.height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.3),
                          child: SizedBox(
                            width: screenSize.width * 0.3,
                            height: minButtonHeight,
                            child: TextButton(
                              onPressed: _createAccount,
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
                                  "Create",
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
