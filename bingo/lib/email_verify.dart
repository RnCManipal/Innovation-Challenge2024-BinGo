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
  // final _auth = FirebaseAuth.instance;
  final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  bool _isLoading = false;

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
                          // height: screenSize.height * 0.15,
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
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Resend Email'),
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
