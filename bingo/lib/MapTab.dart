import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class BinMap extends StatefulWidget {
  const BinMap({super.key});

  @override
  State<BinMap> createState() => _BinMapState();
}

class _BinMapState extends State<BinMap> {
  late Future<void> _mapFuture;
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(13.3525, 74.7928),
    zoom: 15,
  );

  List<Marker> _markers = [];
  List<Marker> list = const [
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(13.3525, 74.7928),
      infoWindow: InfoWindow(title: "MIT Manipal"),
    ),
  ];

  LocationData? _currentLocation;
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _mapFuture = _loadMap();
    _markers.addAll(list);
    _getCurrentLocation();
  }

  Future<void> _loadMap() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay for loading
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await _location.getLocation();
    if (_currentLocation != null) {
      _updateCameraPosition();
    }

    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
        _updateCameraPosition();
      });
    });
  }

  Future<void> _updateCameraPosition() async {
    final GoogleMapController controller = await _controller.future;
    if (_currentLocation != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentLocation!.latitude!,
              _currentLocation!.longitude!,
            ),
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<void>(
        future: _mapFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Show loading indicator while waiting
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _updateCameraPosition();
              },
              myLocationEnabled: true,
              markers: Set<Marker>.of(_markers),
            ); // Show map once it's loaded
          } else {
            return Center(
              child: Text('Error loading map'), // Handle error or other states if needed
            );
          }
        },
      ),
    );
  }
}
