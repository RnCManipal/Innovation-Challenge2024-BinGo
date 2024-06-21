import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SignupPage.dart'; // Import your SignupPage.dart file

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedImageIndex = 0; // Track the index of the selected image
  late User loggedInUser; // Variable to hold logged-in user details
  late DocumentSnapshot userDoc; // Variable to hold user document from Firestore

  @override
  void initState() {
    super.initState();
    // Get the currently logged-in user
    loggedInUser = FirebaseAuth.instance.currentUser!;
    // Fetch user document from Firestore using the UID
    FirebaseFirestore.instance.collection('users').doc(loggedInUser.uid).get().then((doc) {
      setState(() {
        userDoc = doc; // Store the fetched document
      });
    }).catchError((error) {
      print('Error fetching user data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate responsive positioning and size
    double textTopPadding = screenSize.height * 0.1;

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: textTopPadding, // Top space before text
                ),
                if (selectedImageIndex == 0) Home(screenSize: screenSize),
              ],
            ),
          ),
          Center(
            child: selectedImageIndex == 5 // Assuming selectedImageIndex 5 is for "User.png"
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile information
                      if (userDoc != null)
                        Column(
                          children: [
                            Text(
                              'Name: ${userDoc['name']}',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Email: ${userDoc['email']}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignupPage()),
                            );
                          },
                          child: Text('Logout'),
                        ),
                      ),
                    ],
                  )
                : Container(), // Empty container if selectedImageIndex is not 5
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenSize.height * 0.12, // Adjust container height
              width: screenSize.width,
              decoration: BoxDecoration(color: Color(0xffAFFF89)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 0.4),
                  _buildImageWithSelectableBackground(
                    'Images/Home.png',
                    0,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(width: 0.4),
                  _buildImageWithSelectableBackground(
                    'Images/Location.png',
                    1,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(width: 0.4),
                  _buildImageWithSelectableBackground(
                    'Images/Megaphone.png',
                    2,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(width: 0.4),
                  _buildImageWithSelectableBackground(
                    'Images/Qr Code.png',
                    3,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(width: 0.4),
                  _buildImageWithSelectableBackground(
                    'Images/Discount.png',
                    4,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(width: 0.4),
                  _buildImageWithSelectableBackground(
                    'Images/User.png',
                    5,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(width: 0.4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithSelectableBackground(
      String imagePath, int index, double height, double width, double radius) {
    bool isSelected = selectedImageIndex == index;

    return GestureDetector(
      onTap: () {
        // Update selected image index when tapped
        setState(() {
          selectedImageIndex = index;
        });
        print(selectedImageIndex);
      },
      child: Container(
        margin: EdgeInsets.all(8.0), // Adjust margin as needed
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Color(0xffE0FFFF) : Colors.transparent,
        ),
        child: Image.asset(
          imagePath,
          height: height,
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key, required this.screenSize}) : super(key: key);

  final Size screenSize;

  Widget _buildContainer() {
    return Container(
      height: 200, // Example height, adjust as needed
      width: screenSize.width * 0.8,
      decoration: BoxDecoration(
        color: Color(0xffE0FFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text("Scrollable Container"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double textLeftPadding = screenSize.width * 0.1;
    double textWidth = screenSize.width * 0.8;

    return Expanded(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: textLeftPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: textWidth,
                      child: Text(
                        "Welcome to",
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.bold,
                          fontSize:
                              screenSize.width * 0.1, // Responsive font size
                        ),
                      ),
                    ),
                    SizedBox(
                      width: textWidth,
                      child: Text(
                        "BinGo",
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.bold,
                          fontSize:
                              screenSize.width * 0.1, // Responsive font size
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Example spacing
              _buildContainer(),
              SizedBox(height: 20), // Example spacing
              _buildContainer(),
              SizedBox(height: 20), // Example spacing
              _buildContainer(),
              SizedBox(height: 20),
              _buildContainer(),
              SizedBox(height: 20),
              _buildContainer(),
              SizedBox(height: 20),
              _buildContainer(),
              SizedBox(height: 140), // Example spacing
            ],
          ),
        ),
      ),
    );
  }
}
