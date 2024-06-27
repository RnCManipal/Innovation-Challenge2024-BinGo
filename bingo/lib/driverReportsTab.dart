import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bingo/ViewReportsPage.dart'; // Import your ViewPage implementation

class DriverReportTab extends StatefulWidget {
  const DriverReportTab({Key? key}) : super(key: key);

  @override
  State<DriverReportTab> createState() => _DriverReportTabState();
}

class _DriverReportTabState extends State<DriverReportTab> {
  Map<String, dynamic>? selectedReport; // Track selected report details

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return selectedReport != null
        ? ViewPage(
            report: selectedReport!,
            onClose: () {
              setState(() {
                selectedReport = null;
              });
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
                    height: screenHeight * 0.6,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: const Color(0xffE0FFFF),
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('reports')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        var reports = snapshot.data!.docs;

                        // Sorting reports based on severity
                        reports.sort(
                            (a, b) => a['severity'].compareTo(b['severity']));

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reports.length,
                          itemBuilder: (context, index) {
                            var report = reports[index];

                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: screenWidth * 0.04),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedReport = {
                                      'id': report.id, // Store document ID
                                      'title': report['title'],
                                      'description': report['description'],
                                      'severity': report['severity'],
                                      'imageUrl': report['imageUrl'],
                                      'location': report['location'],
                                    };
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE0FFFF),
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.02),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: screenWidth * 0.01,
                                        blurRadius: screenWidth * 0.035,
                                        offset: Offset(0, screenWidth * 0.02),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.04),
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
                                                  'id': report
                                                      .id, // Store document ID
                                                  'title': report['title'],
                                                  'description':
                                                      report['description'],
                                                  'severity':
                                                      report['severity'],
                                                  'imageUrl':
                                                      report['imageUrl'],
                                                  'location':
                                                      report['location'],
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
                                                    width: screenWidth * 0.01),
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
                          },
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
