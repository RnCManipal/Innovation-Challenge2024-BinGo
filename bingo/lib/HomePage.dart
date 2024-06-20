import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedImageIndex = 0; // Track the index of the selected image

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
                if (selectedImageIndex == 0) Home(),
              ],
            ),
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
  const Home({Key? key}) : super(key: key);

  Widget _buildContainer(Size screenSize) {
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
    final Size screenSize = MediaQuery.of(context).size;
    double textLeftPadding = screenSize.width * 0.1;
    double textWidth = screenSize.width * 0.8;
    double textHeight = screenSize.height * 0.15;
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
              _buildContainer(screenSize),
              SizedBox(height: 20), // Example spacing
              _buildContainer(screenSize),
              SizedBox(height: 20), // Example spacing
              _buildContainer(screenSize),
              SizedBox(height: 20),
              _buildContainer(screenSize),
              SizedBox(height: 20),
              _buildContainer(screenSize),
              SizedBox(height: 20),
              _buildContainer(screenSize),
              SizedBox(height: 140), // Example spacing
            ],
          ),
        ),
      ),
    );
  }
}
