import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fuel_finder/screens/showall.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreenWithLocation extends StatefulWidget {
  @override
  _MapScreenWithLocationState createState() => _MapScreenWithLocationState();
}

class _MapScreenWithLocationState extends State<MapScreenWithLocation> {
  GoogleMapController? mapController;
  late LatLng currentLocation;
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    if (_controllerCompleter.isCompleted) {
      // If the map controller is already available, move the camera
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLocation,
          zoom: 15.0, // Adjust the zoom level as needed
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation ?? LatLng(7.8731, 80.7718), // Default to Sri Lanka center
          zoom: 7.0, // Default zoom level
        ),
        markers: Set<Marker>.of([
          if (currentLocation != null)
            Marker(
              markerId: MarkerId('currentLocation'),
              position: currentLocation!,
              infoWindow: InfoWindow(title: 'Current Location'),
            ),
        ]),
        onMapCreated: (GoogleMapController controller) {
          _controllerCompleter.complete(controller);
          if (currentLocation != null) {
            // Move the camera to the current location if available
            controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: currentLocation,
                zoom: 15.0, // Adjust the zoom level as needed
              ),
            ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the "ShowAll" page here
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const showall(),
          ));
        },
        child: const Icon(Icons.list), // List icon
      ),
    );
  }
}
