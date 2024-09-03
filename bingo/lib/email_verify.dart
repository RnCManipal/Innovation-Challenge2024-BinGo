import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({super.key});

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  bool _isLoading = false;
 Future<void> resendVerificationEmail(String email) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('Current user: ${user.email}');
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        print('Verification email sent.');
      } else {
        print('User is already verified.');
      }
    } else {
      print('No user is signed in.');
    }
  } catch (e) {
    print('Error sending email verification: $e');
    throw e;
  }
}


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();

      try {
        // Sending verification email
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification email sent to $email.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User is already verified or not logged in.')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFFFF3E0), // Light orange background
      appBar: AppBar(
        title: Text('Email Verification'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenSize.height * 0.2,
            left: screenSize.width * 0.1,
            right: screenSize.width * 0.1,
          ),
          child: Container(
            width: screenSize.width * 0.8,
            height: screenSize.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenSize.width * 0.02),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  spreadRadius: screenSize.width * 0.005,
                  blurRadius: screenSize.width * 0.02,
                  offset: Offset(0, screenSize.width * 0.01),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenSize.width * 0.3,
                      width: screenSize.height * 0.18,
                      child: Image.asset(
                        'Images/User.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    Text(
                      "Email Verification",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.bold,
                        fontSize: screenSize.width * 0.07,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      "Enter your email to resend the verification email.",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.normal,
                        fontSize: screenSize.width * 0.03,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    TextFormField(
                      controller: _emailController,
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
                        hintText: 'Enter your email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!_emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    ElevatedButton(
                      onPressed: () async {
                        final email = _emailController.text.trim();

                        if (email.isEmpty) {
                          // Show an error dialog if the email is empty
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Please enter an email address.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (!_emailRegex.hasMatch(email)) {
                          // Added: Show an error dialog if the email format is invalid
                          showDialog(

                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Please enter a valid email address.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          try {
                            // Call the resendVerificationEmail method with the entered email
                            await resendVerificationEmail(email);

                            // Show a success dialog indicating that the email has been sent
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Email Sent'),
                                  content: const Text('A verification email has been sent to your email address.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            // Show an error dialog if there was a problem sending the email
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('There was an error sending the email. Please try again.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      child: const Text("Resend Email"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
