import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedImageIndex = -1; // Track the index of the selected image

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate responsive positioning and size
    double textTopPadding = screenSize.height * 0.1;
    double textLeftPadding = screenSize.width * 0.1;
    double textWidth = screenSize.width * 0.8;
    double textHeight = screenSize.height * 0.15;

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: textTopPadding,
            left: textLeftPadding,
            child: SizedBox(
              width: textWidth,
              height: textHeight,
              child: Text(
                "Welcome to BinGo",
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.width * 0.1, // Responsive font size
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: screenSize.height * 0.12, // Adjust container height
              width: screenSize.width,
              decoration: BoxDecoration(color: Color(0xffAFFF89)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 0.4,
                  ),
                  _buildImageWithSelectableBackground(
                    'Images/Home.png',
                    0,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(
                    width: 0.4,
                  ),
                  _buildImageWithSelectableBackground(
                    'Images/Location.png',
                    1,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(
                    width: 0.4,
                  ),
                  _buildImageWithSelectableBackground(
                    'Images/Megaphone.png',
                    2,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(
                    width: 0.4,
                  ),
                  _buildImageWithSelectableBackground(
                    'Images/Qr Code.png',
                    3,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(
                    width: 0.4,
                  ),
                  _buildImageWithSelectableBackground(
                    'Images/Discount.png',
                    4,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(
                    width: 0.4,
                  ),
                  _buildImageWithSelectableBackground(
                    'Images/User.png',
                    5,
                    screenSize.height * 0.12,
                    screenSize.width * 0.12,
                    screenSize.height * 0.12,
                  ),
                  SizedBox(
                    width: 0.4,
                  ),
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
