import 'dart:math';
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
  List<Step> _steps = [];
  int _currentStep = 0;
  bool _isNavigating = false;
  bool _followUserLocation = false;

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
        if (_followUserLocation) {
          _updateCameraPosition();
        }
        if (_isNavigating) {
          _updateCurrentStep();
        }
      });
    });
  }

  Future<void> _updateCameraPosition() async {
    final GoogleMapController controller = await _controller.future;
    if (_currentLocation != null && _followUserLocation) {
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

      _getDirections(origin, destination, waypoints);
    });

    setState(() {
      _isNavigating = true;
      _followUserLocation = true;
    });
  }

  Future<void> _getDirections(
      LatLng origin, LatLng destination, List<LatLng> waypoints) async {
    String waypointsString = waypoints
        .map((waypoint) => '${waypoint.latitude},${waypoint.longitude}')
        .join('|');

    String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}&'
        'destination=${destination.latitude},${destination.longitude}&'
        'waypoints=$waypointsString&'
        'key=AIzaSyBnZeMv7ivrYEy4kMR7ewMoWcuabfr06Hs'; // Replace with your Google Maps API key

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      _steps.clear();
      for (var leg in data['routes'][0]['legs']) {
        for (var step in leg['steps']) {
          _steps.add(Step(
            instructions: _parseHtmlString(step['html_instructions']),
            location: LatLng(
              step['end_location']['lat'],
              step['end_location']['lng'],
            ),
          ));
        }
      }

      setState(() {
        _currentStep = 0;
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: _decodePolyline(
                data['routes'][0]['overview_polyline']['points']),
            color: Colors.blue,
            width: 5,
          ),
        );

        _markers.add(
          Marker(
            markerId: MarkerId('origin'),
            position: origin,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
        _markers.add(
          Marker(
            markerId: MarkerId('destination'),
            position: destination,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      });
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body!.text;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  void _updateCurrentStep() {
    if (_currentLocation == null || _steps.isEmpty) return;

    LatLng currentLocation = LatLng(
      _currentLocation!.latitude!,
      _currentLocation!.longitude!,
    );

    double distanceToNextStep = _calculateDistance(
      currentLocation,
      _steps[_currentStep].location,
    );

    if (distanceToNextStep < 20) {
      setState(() {
        if (_currentStep < _steps.length - 1) {
          _currentStep++;
        }
      });
    }
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000;
    double dLat = _degreeToRadian(end.latitude - start.latitude);
    double dLng = _degreeToRadian(end.longitude - start.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreeToRadian(start.latitude)) *
            cos(_degreeToRadian(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreeToRadian(double degree) {
    return degree * pi / 180;
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
                if (_isNavigating && _steps.isNotEmpty)
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Step ${_currentStep + 1}/${_steps.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _steps[_currentStep].instructions,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_isNavigating)
                  Positioned(
                    bottom: 100,
                    left: 20,
                    child: Row(
                      children: [
                        FloatingActionButton(
                          onPressed: _previousStep,
                          child: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 10),
                        FloatingActionButton(
                          onPressed: _nextStep,
                          child: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ),
                if (_currentLocation != null && _isNavigating)
                  Positioned(
                    bottom: 150,
                    right: 20,
                    child: const Icon(
                      Icons.person_pin_circle,
                      size: 40,
                      color: Colors.blue,
                    ),
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

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < _steps.length - 1) {
        _currentStep++;
      }
    });
  }
}

class Step {
  final String instructions;
  final LatLng location;

  Step({required this.instructions, required this.location});
}
