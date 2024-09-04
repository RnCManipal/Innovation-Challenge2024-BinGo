import 'package:bingo/MapTabDriver.dart';
import 'package:bingo/MapTabUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth if needed
import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore if needed

class MapTab extends StatefulWidget {
  const MapTab({Key? key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  String accountType =
      ''; // Variable to hold account type fetched from Firestore

  @override
  void initState() {
    super.initState();
    // Fetch accountType from Firestore when the widget initializes
    fetchAccountType();
  }

  Future<void> fetchAccountType() async {
    try {
      // Replace with your method of fetching accountType from Firestore
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          accountType = userDoc[
              'accountType']; // Update accountType from Firestore document
        });
      }
    } catch (error) {
      print('Error fetching account type: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (accountType.isEmpty) {
      return const Center(
        child:
            CircularProgressIndicator(), // Show a loading indicator while fetching accountType
      );
    } else {
      // Conditional rendering based on accountType
      return Center(
        child: accountType == 'User' ||accountType == 'Worker'
            ? const BinMap()
            : accountType == 'Driver'
                ? const BinMapDriver()
                : Text(
                    'Unknown account type: $accountType',
                    style: const TextStyle(fontSize: 18),
                  ),
      );
    }
  }
}
