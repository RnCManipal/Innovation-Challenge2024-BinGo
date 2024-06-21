import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

List<String> images = ['Images/YellowMarker.png', 'Images/RedMarker.png', 'Images/GreenMarker.png'];
final List<Marker> _markers = [];
final List<LatLng> _Latlng = [
  LatLng(22.7273, 75.8977),
  LatLng(22.72586, 75.89697),
  LatLng(22.72631, 75.89900)
];

class BinMap extends StatefulWidget {
  const BinMap({super.key});

  @override
  State<BinMap> createState() => _BinMapState();
}

class _BinMapState extends State<BinMap> {
  late Future<void> _mapFuture = Future.value(); // Initialize with a completed future
  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(22.7273, 75.8977),
    zoom: 15,
  );

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  LocationData? _currentLocation;
  final Location _location = Location();

  _loadMarkers() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markerIcon = await getBytesFromAssets(images[i], 50);
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _Latlng[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((_) {
      _mapFuture = _loadMap();
      _loadMarkers();
    });
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
      setState(() {
        _initialCameraPosition = CameraPosition(
          target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
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
