import 'package:bingo/createreport.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:http/http.dart' as http;

class ViewUserReportsTab extends StatefulWidget {
  @override
  _ViewUserReportsTabState createState() => _ViewUserReportsTabState();
}

class _ViewUserReportsTabState extends State<ViewUserReportsTab> {
  Map<String, dynamic>? selectedReport; // Track selected report details
  String? userEmail; // Store user's email
  int selectedImageIndex =
      0; // Track selected image index for the navigation bar

  @override
  void initState() {
    super.initState();
    fetchUserEmail().then((email) {
      setState(() {
        userEmail = email; // Update the state with the email
      });
    });
  }

  Future<String?> fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser; // Get current user
    if (user != null) {
      return user.email;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return selectedReport != null
        ? selectedReport!['isResolved']
            ? ViewPageResolved(
                report: selectedReport!,
                onClose: () {
                  setState(() {
                    selectedReport = null;
                  });
                },
              )
            : ViewPage(
                report: selectedReport!,
                onClose: () {
                  setState(() {
                    selectedReport = null;
                  });
                },
                onResolve: () async {
                  if (selectedReport != null) {
                    await FirebaseFirestore.instance
                        .collection('reports')
                        .doc(selectedReport!['id'])
                        .update({'isResolved': true});
                    setState(() {
                      selectedReport =
                          null; // Clear selected report after resolving
                    });
                  }
                },
              )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.08,
                  left: screenWidth * 0.05,
                  child: Text(
                    "Reports",
                    style: TextStyle(
                      color: const Color(0xffF79839),
                      fontSize: screenWidth * 0.12,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.17,
                  left: screenWidth * 0.6,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserReportTab()),
                      );
                    },
                    child: const Text('Create Report'),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.21,
                  left: screenWidth * 0.05,
                  child: Text(
                    "Resolve",
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
                    height: screenHeight * 0.25,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xffE0FFFF),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 4.0,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: userEmail == null
                        ? Center(child: CircularProgressIndicator())
                        : StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('reports')
                                .where('userEmail', isEqualTo: userEmail)
                                .where('isResolved',
                                    isEqualTo:
                                        false) // Fetch unresolved reports
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              var reports = snapshot.data!.docs;

                              // Sorting reports based on severity
                              reports.sort((a, b) =>
                                  a['severity'].compareTo(b['severity']));

                              return SingleChildScrollView(
                                child: Column(
                                  children:
                                      List.generate(reports.length, (index) {
                                    var report = reports[index];

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: screenWidth * 0.04),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedReport = {
                                              'id': report.id,
                                              'title': report['title'],
                                              'description':
                                                  report['description'],
                                              'severity': report['severity'],
                                              'imageUrl': report['imageUrl'],
                                              'location': report['location'],
                                              'isResolved':
                                                  report['isResolved'],
                                            };
                                          });
                                        },
                                        child: Container(
                                          width: screenWidth * 0.6,
                                          height: screenHeight * 0.07,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffE0FFFF),
                                            borderRadius: BorderRadius.circular(
                                                screenWidth * 0.02),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 3.0,
                                                blurRadius: 6.0,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                screenWidth * 0.04),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    report['title'],
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize:
                                                          screenWidth * 0.04,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: screenWidth * 0.28,
                                                  height: screenHeight * 0.04,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFFFBBC05),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    screenWidth *
                                                                        0.02),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedReport = {
                                                          'id': report.id,
                                                          'title':
                                                              report['title'],
                                                          'description': report[
                                                              'description'],
                                                          'severity': report[
                                                              'severity'],
                                                          'imageUrl': report[
                                                              'imageUrl'],
                                                          'location': report[
                                                              'location'],
                                                          'isResolved': report[
                                                              'isResolved'],
                                                        };
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.remove_red_eye,
                                                          size: screenHeight *
                                                              0.02,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                            width: screenWidth *
                                                                0.01),
                                                        Text(
                                                          'View',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                screenWidth *
                                                                    0.04,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.56,
                  left: screenWidth * 0.05,
                  child: Text(
                    "Resolved",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.09,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight *
                      0.65, // Adjusted position for resolved reports
                  left: screenWidth * 0.1,
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.25,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xffE0FFFF),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 4.0,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('reports')
                          .where('userEmail', isEqualTo: userEmail)
                          .where('isResolved',
                              isEqualTo: true) // Fetch resolved reports
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        var resolvedReports = snapshot.data!.docs;

                        return SingleChildScrollView(
                          child: Column(
                            children:
                                List.generate(resolvedReports.length, (index) {
                              var report = resolvedReports[index];

                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: screenWidth * 0.04),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedReport = {
                                        'id': report.id,
                                        'title': report['title'],
                                        'description': report['description'],
                                        'severity': report['severity'],
                                        'imageUrl': report['imageUrl'],
                                        'location': report['location'],
                                        'isResolved': report['isResolved'],
                                      };
                                    });
                                  },
                                  child: Container(
                                    width: screenWidth * 0.6,
                                    height: screenHeight * 0.07,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffE0FFFF),
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.02),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3.0,
                                          blurRadius: 6.0,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.04),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              report['title'],
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: screenWidth * 0.04,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.28,
                                            height: screenHeight * 0.04,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFFFBBC05),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          screenWidth * 0.02),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedReport = {
                                                    'id': report.id,
                                                    'title': report['title'],
                                                    'description':
                                                        report['description'],
                                                    'severity':
                                                        report['severity'],
                                                    'imageUrl':
                                                        report['imageUrl'],
                                                    'location':
                                                        report['location'],
                                                    'isResolved':
                                                        report['isResolved'],
                                                  };
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.remove_red_eye,
                                                    size: screenHeight * 0.02,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          screenWidth * 0.01),
                                                  Text(
                                                    'View',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          screenWidth * 0.04,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class ViewPage extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback onClose;
  final VoidCallback onResolve;

  ViewPage(
      {required this.report, required this.onClose, required this.onResolve});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onClose,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${report['title']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Description: ${report['description']}'),
            SizedBox(height: 10),
            Text('Severity: ${report['severity']}'),
            SizedBox(height: 10),
            Text('Location: ${report['location']}'),
            SizedBox(height: 10),
            report['imageUrl'] != null
                ? Image.network(report['imageUrl'])
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onResolve,
              child: Text('Mark as Resolved'),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewPageResolved extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback onClose;

  ViewPageResolved({required this.report, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onClose,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${report['title']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Description: ${report['description']}'),
            SizedBox(height: 10),
            Text('Severity: ${report['severity']}'),
            SizedBox(height: 10),
            Text('Location: ${report['location']}'),
            SizedBox(height: 10),
            report['imageUrl'] != null
                ? Image.network(report['imageUrl'])
                : Container(),
            SizedBox(height: 20),
            Text('Status: Resolved',
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
