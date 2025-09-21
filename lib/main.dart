import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Maps Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Lahore default position
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.5204, 74.3587), // Lahore
    zoom: 14.0,
  );

  // FAB click -> Lahore hi zoom in
  static const CameraPosition _kLahore = CameraPosition(
    bearing: 0,
    target: LatLng(31.5204, 74.3587),
    tilt: 0,
    zoom: 17.0, // thoda zyada zoom
  );

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('lahore'),
      position: LatLng(31.5204, 74.3587),
      infoWindow: InfoWindow(title: "Customer", snippet: "Lahore"),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps - Lahore Marker')),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: _markers,
        zoomControlsEnabled:
            true, // + / - zoom buttons dikhayega (bottom-right)
        zoomGesturesEnabled: true, // finger gestures (pinch zoom) allow karega

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToLahore,
        label: const Text('Go to Lahore'),
        icon: const Icon(Icons.location_city),
      ),
    );
  }

  Future<void> _goToLahore() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLahore));
  }
}
