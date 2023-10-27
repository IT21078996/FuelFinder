import 'package:flutter/material.dart';
import 'package:fuel_finder/screens/showall.dart';
import 'package:fuel_finder/screens/showallEV.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
      body: MapScreen(currentLocation),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the vehicle type selection dialog
          _showVehicleTypeDialog(context);
        },
        child: Icon(Icons.list), // List icon
      ),

    );
  }


  Future<void> _showVehicleTypeDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Vehicle Type ',
            style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => showall(),
                ));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Button background color
                minimumSize: Size(150, 50), // Button size
              ),
              child: Text(
                'Gas',
                style: TextStyle(fontSize: 20), // Text size
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => showallEV(),
                ));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Button background color
                minimumSize: Size(150, 50), // Button size
              ),
              child: Text(
                'EV',
                style: TextStyle(fontSize: 20), // Text size
              ),
            ),
          ],
        );
      },
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
          target: currentLocation ??
              LatLng(
                  0, 0), // Default to (0, 0) if current location is unavailable
          zoom: 15.0,
        ),
        markers: Set<Marker>.of([
          Marker(
            markerId: MarkerId('currentLocation'),
            position: currentLocation ??
                LatLng(
                    0, 0), // Default to (0, 0) if current location is unavailable
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        ])
    );

  }
}
