import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({Key? key, required this.screenSize}) : super(key: key);

  final Size screenSize;

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
              const SizedBox(height: 20), // Example spacing
              CustomContainer(
                height: screenSize.height*0.32,
                screenSize: screenSize,
                children: [
                  Padding(
                          padding: EdgeInsets.only(top: screenSize.height * 0.04, left: screenSize.width * 0.1),
                          child: Text(
                            "1500",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: screenSize.width * 0.1,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 15, 191, 38),
                            ),
                          ),
                        ),
                  Padding(
                          padding: EdgeInsets.only(top: screenSize.height *0, left: screenSize.width * 0.57),
                          child: Text(
                            "points",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                  const SizedBox(height: 5),
                  Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
                          child: SizedBox(
                            width: screenSize.width * 0.6,
                            height: screenSize.height *0.06,
                            child: TextButton(
                              onPressed: (){print("button pressed");},
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 255, 153, 1)),
                                foregroundColor: WidgetStateProperty.all(Colors.white),
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                                  ),
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
                  const SizedBox(height: 10),
                  Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
                          child: SizedBox(
                            width: screenSize.width * 0.6,
                            height: screenSize.height *0.06,
                            child: TextButton(
                              onPressed: (){print("button pressed");},
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 255, 153, 1)),
                                foregroundColor: WidgetStateProperty.all(Colors.white),
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Earn More",
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
                            "Support you community's health by reporting any spills and also earn reward points",
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
 // Example spacing
            ],
          ),
        ),
      ),
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