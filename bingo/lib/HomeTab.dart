import 'package:flutter/material.dart';

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
