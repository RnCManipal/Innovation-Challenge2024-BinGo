import 'package:flutter/material.dart';

class UserReportTab extends StatefulWidget {
  const UserReportTab({Key? key}) : super(key: key);

  @override
  State<UserReportTab> createState() => _UserReportTabState();
}

class _UserReportTabState extends State<UserReportTab> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.08,
            left: screenWidth * 0.05,
            child: Text(
              "Reports",
              style: TextStyle(
                color: Color(0xffF79839),
                fontSize: screenWidth * 0.12,
                fontFamily: 'Jost',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.155,
            left: screenWidth * 0.05,
            child: Text(
              "and earn rewards",
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.05,
                fontFamily: 'Glory',
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.21,
            left: screenWidth * 0.05,
            child: Text(
              "Create a Report",
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.09,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.3,
            left: screenWidth * 0.1,
            child: Container(
              width: screenWidth * 0.8,
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Color(0xffE0FFFF), // Light cyan background color
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: screenWidth * 0.01,
                    blurRadius: screenWidth * 0.035,
                    offset: Offset(
                        0, screenWidth * 0.02), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // White background color
                      hintText: 'Enter location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: BorderSide.none, // No border side
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // White background color
                      hintText: 'Enter description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: BorderSide.none, // No border side
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  Text(
                    "Severity",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // White background color
                      hintText: 'Enter severity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: BorderSide.none, // No border side
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFFFBBC05), // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                screenWidth * 0.02), // Rounded corners
                          ),
                        ),
                        onPressed: () {
                          // Handle camera button press
                        },
                        icon: Icon(Icons.camera_alt,
                            color: Colors.white), // Camera icon
                        label: Text(
                          'Camera',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFFFBBC05), // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                screenWidth * 0.02), // Rounded corners
                          ),
                        ),
                        onPressed: () {
                          // Handle upload button press
                        },
                        icon: Icon(Icons.upload,
                            color: Colors.white), // Upload icon
                        label: Text(
                          'Upload',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffF79839), // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              screenWidth * 0.02), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        // Handle "File a Report" button press
                      },
                      child: Text(
                        'File a Report',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
