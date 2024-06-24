import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UserReportTab extends StatefulWidget {
  const UserReportTab({Key? key}) : super(key: key);

  @override
  State<UserReportTab> createState() => _UserReportTabState();
}

class _UserReportTabState extends State<UserReportTab> {
  File? image;
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController severityController = TextEditingController();
  bool uploading = false; // Flag to track image upload state

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isButtonDisabled =
        image == null; // Disable button if no image is selected

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
                color: Color(0xffE0FFFF),
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: screenWidth * 0.01,
                    blurRadius: screenWidth * 0.035,
                    offset: Offset(0, screenWidth * 0.02),
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
                    controller: locationController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: BorderSide.none,
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
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: BorderSide.none,
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
                    controller: severityController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter severity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFBBC05),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.02),
                          ),
                        ),
                        onPressed: () async {
                          final picture = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          if (picture != null) {
                            image = File(picture.path);
                            setState(() {});
                          }
                        },
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        label: Text(
                          'Camera',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFBBC05),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.02),
                          ),
                        ),
                        onPressed: () async {
                          final picture = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (picture != null) {
                            image = File(picture.path);
                            setState(() {});
                          }
                        },
                        icon: Icon(Icons.upload, color: Colors.white),
                        label: Text(
                          'Upload',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  uploading
                      ? Center(child: CircularProgressIndicator())
                      : Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffF79839),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.02),
                              ),
                            ),
                            onPressed: isButtonDisabled
                                ? null // Disable button if no image selected
                                : () {
                                    // Handle "File a Report" button press
                                    saveReportToFirestore();
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

  Future<void> saveReportToFirestore() async {
    String location = locationController.text.trim();
    String description = descriptionController.text.trim();
    String severity = severityController.text.trim();

    if (location.isEmpty || description.isEmpty || severity.isEmpty) {
      // Show an error dialog if any of the fields are empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill out all fields.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      uploading = true; // Start showing loader while uploading
    });

    try {
      // Access Firestore instance and collection
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference reports = firestore.collection('reports');

      // Add a new document with auto-generated ID
      DocumentReference ref = await reports.add({
        'location': location,
        'description': description,
        'severity': severity,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Upload image if available
      if (image != null) {
        String fileName =
            '${ref.id}_${DateTime.now().millisecondsSinceEpoch}.png'; // Using Firestore document ID and timestamp
        Reference storageRef =
            FirebaseStorage.instance.ref().child('images/reports/$fileName');
        await storageRef.putFile(image!);

        // Update Firestore document with image URL
        String imageUrl = await storageRef.getDownloadURL();
        await ref.update({'imageUrl': imageUrl});
      }

      // Clear input fields after saving
      locationController.clear();
      descriptionController.clear();
      severityController.clear();
      image = null;

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Report filed successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error saving report: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to file report. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        uploading = false; // Stop showing loader after uploading
      });
    }
  }
}
