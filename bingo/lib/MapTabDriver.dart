import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher.dart';

class BinMap extends StatefulWidget {
  const BinMap({Key? key}) : super(key: key);

  @override
  State<BinMap> createState() => _BinMapState();
}

class _BinMapState extends State<BinMap> {
  late Future<void> _mapFuture = Future.value();
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markers = [];
  final Set<Polyline> _polylines = {};
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(22.7273, 75.8977),
    zoom: 15,
  );

  LocationData? _currentLocation;
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((_) {
      _mapFuture = _loadMap();
      _loadMarkersFromFirestore();
    });
  }

  Future<void> _loadMarkersFromFirestore() async {
    await Firebase.initializeApp();

    FirebaseFirestore.instance
        .collection('bin_data')
        .snapshots()
        .listen((snapshot) {
      _markers.clear();

      for (var doc in snapshot.docs) {
        double lat = doc['latitude'];
        double lng = doc['longitude'];
        int fillPercent = doc['fill_percent'];

        String markerImage;
        if (fillPercent <= 40) {
          markerImage = 'Images/GreenMarker.png';
        } else if (fillPercent <= 60) {
          markerImage = 'Images/YellowMarker.png';
        } else {
          markerImage = 'Images/RedMarker.png';
        }

        getBytesFromAssets(markerImage, calculateMarkerWidth(fillPercent))
            .then((markerIconBytes) {
          final BitmapDescriptor markerIcon =
              BitmapDescriptor.fromBytes(markerIconBytes);

          final marker = Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(lat, lng),
            icon: markerIcon,
          );
          _markers.add(marker);

          setState(() {});
        });
      }
    });
  }

  int calculateMarkerWidth(int fillPercent) {
    return 50;
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
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
      setState(() {
        _initialCameraPosition = CameraPosition(
          target:
              LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          zoom: 15,
        );
      });
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

  Future<void> _loadMap() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _startNavigation() async {
    if (_currentLocation == null) return;

    LatLng origin =
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    LatLng destination = origin;

    List<LatLng> waypoints = [];
    FirebaseFirestore.instance.collection('bin_data').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        double lat = doc['latitude'];
        double lng = doc['longitude'];
        waypoints.add(LatLng(lat, lng));
      }

      _launchGoogleMaps(origin, destination, waypoints);
    });
  }

  Future<void> _launchGoogleMaps(
      LatLng origin, LatLng destination, List<LatLng> waypoints) async {
    String originString = '${origin.latitude},${origin.longitude}';
    String destinationString =
        '${destination.latitude},${destination.longitude}';
    String waypointsString = waypoints
        .map((waypoint) => '${waypoint.latitude},${waypoint.longitude}')
        .join('|');

    String url =
        'https://www.google.com/maps/dir/?api=1&origin=$originString&destination=$destinationString&waypoints=$waypointsString&travelmode=driving';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _updateCameraPosition();
                  },
                  myLocationEnabled: true,
                  markers: Set<Marker>.of(_markers),
                  polylines: _polylines,
                  myLocationButtonEnabled: false,
                ),
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: _startNavigation,
                    child: const Icon(Icons.navigation),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Error loading map'),
            );
          }
        },
      ),
    );
  }
}
