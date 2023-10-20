import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    home: MapScreenWithLocation(),
  ));
}

class MapScreenWithLocation extends StatefulWidget {
  @override
  _MapScreenWithLocationState createState() => _MapScreenWithLocationState();
}

class _MapScreenWithLocationState extends State<MapScreenWithLocation> {
  GoogleMapController? mapController;
  LatLng? currentLocation;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map with Current Location"),
      ),
      body: MapScreen(currentLocation),
    );
  }
}

class MapScreen extends StatelessWidget {
  final LatLng? currentLocation;

  MapScreen(this.currentLocation);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentLocation ?? LatLng(0, 0), // Default to (0, 0) if current location is unavailable
        zoom: 15.0,
      ),
      markers: Set<Marker>.of([
        Marker(
          markerId: MarkerId('currentLocation'),
          position: currentLocation ?? LatLng(0, 0), // Default to (0, 0) if current location is unavailable
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      ]),
    );
  }
}
