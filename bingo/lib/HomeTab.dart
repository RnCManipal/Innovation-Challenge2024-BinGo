import 'package:bingo/offers_page.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

class Home extends StatelessWidget {
  Home({Key? key, required this.screenSize}) : super(key: key);
  
  final Size screenSize;
  
void _showPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Color(0xFFFF9900), width: 3),
        ),
        title: Text(
          "BinGo User Guide",
          style: TextStyle(
            fontFamily: 'Jost',
            fontWeight: FontWeight.bold,
            fontSize: screenSize.width * 0.06,
            color: Color(0xFFFF9900),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection("How to Earn Points:", [
                "For Users:",
                "• Report trash: If you see litter or an overflowing bin, report it in the app.",
                "• Each valid report earns you points.",
                "\nFor Drivers:",
                "• Resolve reports: Clean up reported areas or empty full bins.",
                "• Each resolved report earns you points.",
              ]),
              SizedBox(height: 20),
              _buildSection("Using Your Points:", [
                "1. Go to the 'Offers' page.",
                "2. Browse available rewards.",
                "3. Redeem your points for eco-friendly products, discounts, or other exciting offers!",
              ]),
              SizedBox(height: 20),
              Text(
                "Remember, your actions help keep our community clean. Thank you for using BinGo!",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                  fontSize: screenSize.width * 0.035,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Close",
              style: TextStyle(color: Color(0xFFFF9900)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  Widget _buildSection(String title, List<String> points) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenSize.width * 0.045,
          color: Color(0xFFFF9900),
        ),
      ),
      SizedBox(height: 10),
      ...points.map((point) => Padding(
            padding: EdgeInsets.only(left: 10, bottom: 5),
            child: Text(
              point,
              style: TextStyle(
                fontSize: screenSize.width * 0.04,
                color: Colors.black87,
              ),
            ),
          )),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    double textLeftPadding = screenSize.width * 0.1;
    double textWidth = screenSize.width * 0.8;

    return Expanded(
      child: SingleChildScrollView(
        child: Stack(
        children: [Center(
          child: Column(
            children: [
              
              Padding(
                padding: EdgeInsets.only(left: screenSize.width*0.224),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(
                      width: textWidth,
                      child:Text(
                        "Welcome to",
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.bold,
                          fontSize:
                              screenSize.width * 0.1, // Responsive font size
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width*0.135),
                      child:
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Example spacingq
              CustomContainer(
              height: screenSize.height * 0.25,
              screenSize: screenSize,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenSize.height * 0.02, left: screenSize.width * 0.1),
                  child: Row(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: screenSize.width * 0.1,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 15, 191, 38),
                        ),
                      ),
                      SizedBox(width: 20), // Add some space between "0" and "points"
                      Text(
                        "points",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: screenSize.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15), // Adjusted spacing
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
                  child: SizedBox(
                    width: screenSize.width * 0.6,
                    height: screenSize.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        HomePage.homePageKey.currentState?.updateSelectedIndex(4);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 153, 1),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "View Offers",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.049,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]
              ),
              const SizedBox(height: 20), // Example spacing
              CustomContainer(
              height:screenSize.height*0.5,
              screenSize: screenSize,
              children: [
              Padding(
                          padding: EdgeInsets.symmetric(vertical: screenSize.height *0.04, horizontal: screenSize.width * 0.06),
                          child: Image.asset(
                            'Images/TruckPhoto.png',
                            height: screenSize.height*0.25,
                            fit: BoxFit.cover,
                          ),
              ),
              Padding(
                          padding: EdgeInsets.only(top: screenSize.height *0, left: screenSize.width * 0),
                          child: Text(
                            "Help us make the waste management process more efficient",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontSize: screenSize.width * 0.06,
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 0, 0, 0),       
                            ),
                          ),
                        ),
              ]
               ),
              const SizedBox(height: 20), // Example spacing
              
              CustomContainer(
              screenSize: screenSize,
              height:screenSize.height*0.5,
              children: [
                Padding(
                          padding: EdgeInsets.symmetric(vertical: screenSize.height *0.03, horizontal: screenSize.width * 0.04),
                          child: Image.asset(
                            'Images/Community.png',
                            height: screenSize.height*0.25,
                            fit: BoxFit.cover,
                          ),
                ),
                
                Padding(
                          padding: EdgeInsets.only(top: screenSize.height *0, ),
                          child: Text(
                            "Support your community's health by reporting any spills and also earn reward points",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontSize: screenSize.width * 0.06,
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 0, 0, 0),       
                            ),
                          ),
                        ),
      
                  ]
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.info_rounded, color: Colors.orange),
              onPressed: () => _showPopup(context))),
      ]
      ),
      ) 
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Size screenSize;
  final List<Widget> children;
  final double height;

  // Predefined properties for box shadow
  static const List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Color.fromARGB(255, 152, 152, 152),
      spreadRadius: 3,
      blurRadius: 4,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ];

  CustomContainer({
    required this.screenSize,
    required this.children,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate height and width based on screen size
    double width = screenSize.width * 0.8;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xffE0FFFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
        )
    );
  }
}
