import 'package:flutter/material.dart';
import 'HomeTab.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({Key? key, required this.screenSize}) : super(key: key);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final Size screenSize;
  
  @override
  Widget build(BuildContext context) {
    double textLeftPadding = screenSize.width * 0.1;
    double textWidth = screenSize.width * 0.8;

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                              padding: EdgeInsets.only(top: screenSize.height * 0.02,),
                              child: SizedBox(
                                  width: screenSize.width * 0.3,
                                  child: Text(
                                  "BinGo",
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize.width *0.1, // Responsive font size
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
              Padding(
                              padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02,horizontal: screenSize.width*0.23),
                                  child: SizedBox(
                                  width: screenSize.width * 0.8,
                                  child: Text(
                                  "Update Profile",
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize.width *0.07, // Responsive font size
                                 
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
                    height: screenSize.height *0.6,
                    decoration: BoxDecoration(
                      color: const Color(0xffE0FFFF),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                      color: Color.fromARGB(255, 152, 152, 152),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: Offset(0, 3), // changes position of shadow
                      ),]
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
                              fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.bold,
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
                            height: screenSize.height*0.06,
                            child: TextButton(
                              onPressed: (){print("button pressed");},
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 255, 153, 1)),
                                foregroundColor: WidgetStateProperty.all(Colors.white),
                                padding: WidgetStateProperty.all(
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
                                  "Update",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}