//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:fuel_finder/screens/showall.dart';
//
// class MapScreenWithLocation extends StatefulWidget {
//   @override
//   _MapScreenWithLocationState createState() => _MapScreenWithLocationState();
// }
//
// class _MapScreenWithLocationState extends State<MapScreenWithLocation> {
//   GoogleMapController? mapController;
//   LatLng? currentLocation;
//   Completer<GoogleMapController> _controllerCompleter = Completer();
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocationAndZoom();
//   }
//
//   Future<void> getCurrentLocationAndZoom() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         currentLocation = LatLng(position.latitude, position.longitude);
//       });
//
//       if (_controllerCompleter.isCompleted) {
//         // If the map controller is already available, move the camera
//         mapController!.animateCamera(CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: currentLocation!, // Zoom directly to the current location
//             zoom: 15.0, // Adjust the zoom level as needed
//           ),
//         ));
//       }
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Set<Marker> markers = currentLocation != null
//         ? Set<Marker>.of([
//       Marker(
//         markerId: MarkerId('currentLocation'),
//         position: currentLocation!,
//         infoWindow: InfoWindow(title: 'Current Location'),
//       ),
//     ])
//         : Set<Marker>();
//
//     return Scaffold(
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: currentLocation ?? LatLng(6.9271, 79.8612), // Default to Sri Lanka center
//           zoom: 15.0, // Default zoom level
//         ),
//         markers: markers,
//         onMapCreated: (GoogleMapController controller) {
//           _controllerCompleter.complete(controller);
//           if (currentLocation != null) {
//             // Move the camera to the current location if available
//             controller.animateCamera(CameraUpdate.newCameraPosition(
//               CameraPosition(
//                 target: currentLocation!,
//                 zoom: 15.0, // Adjust the zoom level as needed
//               ),
//             ));
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to the "ShowAll" page here
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => showall(),
//           ));
//         },
//         child: Icon(Icons.list), // List icon
//       ),
//     );
//   }
// }
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:fuel_finder/screens/showall.dart';
//
// class MapScreenWithLocation extends StatefulWidget {
//   final List<Marker> fuelStationMarkers; // Pass the markers to the widget
//
//   MapScreenWithLocation({required this.fuelStationMarkers});
//
//   @override
//   _MapScreenWithLocationState createState() => _MapScreenWithLocationState();
// }
//
// class _MapScreenWithLocationState extends State<MapScreenWithLocation> {
//   GoogleMapController? mapController;
//   LatLng? currentLocation;
//   Completer<GoogleMapController> _controllerCompleter = Completer();
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocationAndZoom();
//   }
//
//   Future<void> getCurrentLocationAndZoom() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         currentLocation = LatLng(position.latitude, position.longitude);
//       });
//
//       if (_controllerCompleter.isCompleted) {
//         // If the map controller is already available, move the camera
//         mapController!.animateCamera(CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: currentLocation!, // Zoom directly to the current location
//             zoom: 15.0, // Adjust the zoom level as needed
//           ),
//         ));
//       }
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Marker> markerList = [];
//     if (currentLocation != null) {
//       markerList.add(
//         Marker(
//           markerId: MarkerId('currentLocation'),
//           position: currentLocation!,
//           infoWindow: InfoWindow(title: 'Current Location'),
//         ),
//       );
//     }
//     markerList.addAll(widget.fuelStationMarkers);
//
//     Set<Marker> markers = Set<Marker>.from(markerList);
//
//     return Scaffold(
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: currentLocation ?? LatLng(6.9271, 79.8612), // Default to Sri Lanka center
//           zoom: 15.0, // Default zoom level
//         ),
//         markers: markers,
//         onMapCreated: (GoogleMapController controller) {
//           _controllerCompleter.complete(controller);
//           if (currentLocation != null) {
//             // Move the camera to the current location if available
//             controller.animateCamera(CameraUpdate.newCameraPosition(
//               CameraPosition(
//                 target: currentLocation!,
//                 zoom: 15.0, // Adjust the zoom level as needed
//               ),
//             ));
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to the "ShowAll" page here
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => showall(),
//           ));
//         },
//         child: Icon(Icons.list), // List icon
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuel_finder/screens/showall.dart';
import 'package:fuel_finder/screens/showallEV.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_webservice/places.dart';

import 'FuelStation.dart';


class CustomMarker {
  final LatLng position;
  final String name;
  final String details;

  CustomMarker({
    required this.position,
    required this.name,
    required this.details,
  });
}

class Fuelfinderr extends StatefulWidget {
  const Fuelfinderr({Key? key}) : super(key: key);

  @override
  _FuelfinderrState createState() => _FuelfinderrState();
}

class _FuelfinderrState extends State<Fuelfinderr> {
  GoogleMapController? mapController;
  late LatLng  currentLocation;
  LatLng? destinationLocation;
  Map<PolylineId, Polyline> _polylines = {};
  List<Marker> _markers = [];

  final places = GoogleMapsPlaces(
      apiKey: 'AIzaSyCvSUtd3-nZo21tIJWDFgZyIMxaxlmD8qM'); // Replace with your API key
  final BitmapDescriptor fuelStationIcon = BitmapDescriptor
      .defaultMarkerWithHue(BitmapDescriptor.hueOrange);

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    fetchFuelStationsAndCreateMarkers();
  }

  Future<List<FuelStation>> fetchFuelStations() async {
    List<FuelStation> fuelStations = [];

    final firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('stations').get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      FuelStation station = FuelStation(
        location: data['Location'],
        sName: data['SName'],
        evChargersAvailable: data['evChargersAvailable'] ?? false,
        fuelTypeQuantityMap: Map<String, String>.from(
            data['fuelTypeQuantityMap']),
        latitude: data['latitude'] ?? 0.0,
        longitude: data['longitude'] ?? 0.0,
        noofpumps: data['noofpumps'],
        status: data['status'],
      );

      fuelStations.add(station);
    }

    return fuelStations;
  }

  List<Marker> createFuelStationMarkers(List<FuelStation> fuelStations) {
    List<Marker> markers = [];
    for (FuelStation station in fuelStations) {
      Marker marker = Marker(
        markerId: MarkerId(station.location), // Use location as the marker ID
        position: LatLng(station.latitude, station.longitude),
        infoWindow: InfoWindow(
          title: station.sName,
          snippet: "Available Fuel Types: ${station.fuelTypeQuantityMap.keys
              .join(", ")}",
        ),

      );
      markers.add(marker);
    }
    return markers;
  }

  Future<void> fetchFuelStationsAndCreateMarkers() async {
    List<FuelStation> fuelStations = await fetchFuelStations();
    List<Marker> markers = createFuelStationMarkers(fuelStations);
    setState(() {
      _markers = markers;
    });
  }


  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void clearMarkers() {
    setState(() {
      _markers.clear();
    });
  }

  Future<void> searchDestination(String destinationName) async {
    clearMarkers(); // Clear previous markers

    PlacesSearchResponse response = await places.searchByText(destinationName);

    if (response.status == 'OK' && response.results.isNotEmpty) {
      final place = response.results.first;
      final location = place.geometry!.location;
      setState(() {
        destinationLocation = LatLng(location.lat, location.lng);
      });

      displayRoute();
      searchNearbyFuelStations(destinationLocation! as Location);
    }
  }

  Future<void> searchNearbyFuelStations(Location destinationLocation) async {
    final response = await places.searchNearbyWithRadius(
      Location(lat: destinationLocation.lat, lng: destinationLocation.lng),
      5000,
      keyword: 'fuel station',
    );

    if (response.status == 'OK' && response.results.isNotEmpty) {
      final fuelStations = response.results;
      displayNearbyFuelStationsOnMap(fuelStations.cast<PlaceDetails>());
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0,
        lng = 0;

    while (index < len) {
      int b,
          shift = 0,
          result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dLng;

      double latitude = lat / 1e5;
      double longitude = lng / 1e5;
      points.add(LatLng(latitude, longitude));
    }

    return points;
  }

  Future<void> displayRoute() async {
    if (currentLocation != null && destinationLocation != null) {
      final directions = await getDirections(
        currentLocation!,
        destinationLocation!,
      );

      if (directions != null) {
        List<LatLng> points = decodePolyline(
          directions['routes'][0]['overview_polyline']['points'],
        );

        final PolylineId polylineId = PolylineId('route');
        final Polyline poly = Polyline(
          polylineId: polylineId,
          color: Colors.blue,
          points: points,
        );

        setState(() {
          _polylines[polylineId] = poly;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> getDirections(LatLng origin,
      LatLng destination) async {
    const String apiKey = 'AIzaSyCvSUtd3-nZo21tIJWDFgZyIMxaxlmD8qM'; // Replace with your API key
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin
        .latitude},${origin.longitude}&destination=${destination
        .latitude},${destination.longitude}&mode=driving&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return data;
      } else if (data['status'] == 'ZERO_RESULTS') {
        return null;
      } else {
        throw Exception('Google Maps API Error: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  Future<void> displayNearbyFuelStationsOnMap(
      List<PlaceDetails> fuelStations) async {
    for (PlaceDetails station in fuelStations) {
      final location = station.geometry?.location;
      final marker = Marker(
        markerId: MarkerId(station.placeId),
        position: LatLng(location!.lat, location!.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: station.name, snippet: station.vicinity),
        onTap: () {
          showStationDetailsDialog(station);
        },
      );
      setState(() {
        _markers.add(marker);
      });
    }
  }

  void showStationDetailsDialog(PlaceDetails station) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(station.name),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Address: ${station.vicinity}"),
                // Add more station details as needed
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: MapScreen(
        currentLocation: currentLocation,
        destinationLocation: destinationLocation,
        markers: _markers,
        polylines: _polylines,
        places: places,
      ),
    );
  }
}
class DestinationSearchScreen extends StatefulWidget {
  final GoogleMapsPlaces places;

  DestinationSearchScreen({required this.places});

  @override
  _DestinationSearchScreenState createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  TextEditingController destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Destination"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                hintText: "Enter your destination",
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final destination = await searchDestination(destinationController.text);
                Navigator.of(context).pop(destination);
              },
              child: Text("Search"),
            ),
          ],
        ),
      ),
    );
  }

  Future<LatLng> searchDestination(String destinationName) async {
    PlacesSearchResponse response = await widget.places.searchByText(destinationName);

    if (response.status == 'OK' && response.results.isNotEmpty) {
      final place = response.results.first;
      final location = place.geometry!.location;
      return LatLng(location.lat, location.lng);
    }

    return LatLng(0, 0);
  }
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
class MapScreen extends StatefulWidget {
  final LatLng currentLocation;
  final LatLng? destinationLocation;
  final Map<PolylineId, Polyline> polylines;
  final List<Marker> markers;
  final GoogleMapsPlaces places;

  MapScreen({
    required this.currentLocation,
    this.destinationLocation,
    required this.polylines,
    required this.markers,
    required this.places,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  double? distance;
  Circle? searchRadiusCircle;

  void showStationDetailsDialog(PlaceDetails station) {
    // Your dialog code remains the same
  }

  void displayNearbyFuelStationsOnMap(List<PlaceDetails> fuelStations) {
    // Your marker code remains the same
  }

  @override
  void initState() {
    super.initState();
    if (widget.destinationLocation != null) {
      distance = calculateDistance(
        widget.currentLocation,
        widget.destinationLocation!,
      );
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  Future<void> searchNearbyFuelStations(Location destinationLocation) async {
    final response = await widget.places.searchNearbyWithRadius(
      Location(lat: destinationLocation.lat, lng: destinationLocation.lng),
      5000, // Adjust the radius as needed to match the search radius
      keyword: 'fuel station',
    );

    if (response.status == 'OK' && response.results.isNotEmpty) {
      final fuelStations = response.results;

      final filteredFuelStations = fuelStations.where((station) {
        final stationLocation = station.geometry?.location;
        final distance = Geolocator.distanceBetween(
          stationLocation?.lat ?? 0,
          stationLocation?.lng ?? 0,
          destinationLocation.lat,
          destinationLocation.lng,
        );

        return distance <= 5000; // Adjust this value to match the search radius
      });

      displayNearbyFuelStationsOnMap(filteredFuelStations.cast<PlaceDetails>().toList());

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;

                if (widget.destinationLocation != null) {
                  searchRadiusCircle = Circle(
                    circleId: CircleId("searchRadius"),
                    center: widget.destinationLocation!,
                    radius: 5000, // Change the radius as needed (in meters)
                    fillColor: Colors.blue.withOpacity(0.3),
                    strokeWidth: 0,
                  );
                }
              },
              initialCameraPosition: CameraPosition(
                target: widget.currentLocation,
                zoom: 12.0,
              ),
              markers: Set<Marker>.of([
                Marker(
                  markerId: MarkerId("currentLocation"),
                  position: widget.currentLocation,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  infoWindow: InfoWindow(title: "Current Location"),
                ),
                if (widget.destinationLocation != null)
                  Marker(
                    markerId: MarkerId("destinationLocation"),
                    position: widget.destinationLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    infoWindow: InfoWindow(title: "Destination Location"),
                  ),
                ...widget.markers,
              ]),
              polylines: Set<Polyline>.of(widget.polylines.values),
              circles: searchRadiusCircle != null ? Set<Circle>.of([searchRadiusCircle!]) : Set<Circle>(),
            ),
          ),
          if (distance != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Distance: ${(distance! / 1000).toStringAsFixed(2)} kilometers"),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the vehicle type selection dialog
          _showVehicleTypeDialog(context);
        },
        child: Icon(Icons.list), // List icon
      ),
    );
  }


  }


