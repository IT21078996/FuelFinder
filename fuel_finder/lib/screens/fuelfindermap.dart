// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:google_maps_webservice/places.dart';
//
// import 'FuelStation.dart';
//
//
// class CustomMarker {
//   final LatLng position;
//   final String name;
//   final String details;
//
//   CustomMarker({
//     required this.position,
//     required this.name,
//     required this.details,
//   });
// }
//
// class Fuelfinder extends StatefulWidget {
//   const Fuelfinder({Key? key}) : super(key: key);
//
//   @override
//   _FuelfinderState createState() => _FuelfinderState();
// }
//
// class _FuelfinderState extends State<Fuelfinder> {
//   GoogleMapController? mapController;
//   LatLng? currentLocation;
//   LatLng? destinationLocation;
//   Map<PolylineId, Polyline> _polylines = {};
//   List<Marker> _markers = [];
//
//   final places = GoogleMapsPlaces(apiKey: 'AIzaSyCvSUtd3-nZo21tIJWDFgZyIMxaxlmD8qM'); // Replace with your API key
//   final BitmapDescriptor fuelStationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//     fetchFuelStationsAndCreateMarkers();
//   }
//   Future<List<FuelStation>> fetchFuelStations() async {
//     List<FuelStation> fuelStations = [];
//
//     final firestore = FirebaseFirestore.instance;
//     QuerySnapshot snapshot = await firestore.collection('stations').get();
//
//     for (QueryDocumentSnapshot doc in snapshot.docs) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//       FuelStation station = FuelStation(
//         location: data['Location'],
//         sName: data['SName'],
//         evChargersAvailable: data['evChargersAvailable'] ?? false,
//         fuelTypeQuantityMap: Map<String, String>.from(data['fuelTypeQuantityMap']),
//         latitude: data['latitude'] ?? 0.0,
//         longitude: data['longitude'] ?? 0.0,
//         noofpumps: data['noofpumps'],
//         status: data['status'],
//       );
//
//       fuelStations.add(station);
//     }
//
//     return fuelStations;
//   }
//   List<Marker> createFuelStationMarkers(List<FuelStation> fuelStations) {
//     List<Marker> markers = [];
//     for (FuelStation station in fuelStations) {
//       Marker marker = Marker(
//         markerId: MarkerId(station.location), // Use location as the marker ID
//         position: LatLng(station.latitude, station.longitude),
//         infoWindow: InfoWindow(
//           title: station.sName,
//           snippet: "Available Fuel Types: ${station.fuelTypeQuantityMap.keys.join(", ")}",
//         ),
//
//       );
//       markers.add(marker);
//     }
//     return markers;
//   }
//   Future<void> fetchFuelStationsAndCreateMarkers() async {
//     List<FuelStation> fuelStations = await fetchFuelStations();
//     List<Marker> markers = createFuelStationMarkers(fuelStations);
//     setState(() {
//       _markers = markers;
//     });
//   }
//
//
//
//   Future<void> getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     setState(() {
//       currentLocation = LatLng(position.latitude, position.longitude);
//     });
//   }
//
//   void clearMarkers() {
//     setState(() {
//       _markers.clear();
//     });
//   }
//
//   Future<void> searchDestination(String destinationName) async {
//     clearMarkers(); // Clear previous markers
//
//     PlacesSearchResponse response = await places.searchByText(destinationName);
//
//     if (response.status == 'OK' && response.results.isNotEmpty) {
//       final place = response.results.first;
//       final location = place.geometry!.location;
//       setState(() {
//         destinationLocation = LatLng(location.lat, location.lng);
//       });
//
//       displayRoute();
//       searchNearbyFuelStations(destinationLocation! as Location);
//     }
//   }
//
//   Future<void> searchNearbyFuelStations(Location destinationLocation) async {
//     final response = await places.searchNearbyWithRadius(
//       Location(lat: destinationLocation.lat, lng: destinationLocation.lng),
//       5000,
//       keyword: 'fuel station',
//     );
//
//     if (response.status == 'OK' && response.results.isNotEmpty) {
//       final fuelStations = response.results;
//       displayNearbyFuelStationsOnMap(fuelStations.cast<PlaceDetails>());
//     }
//   }
//
//   List<LatLng> decodePolyline(String encoded) {
//     List<LatLng> points = [];
//     int index = 0;
//     int len = encoded.length;
//     int lat = 0, lng = 0;
//
//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1F) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//
//       int dLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lat += dLat;
//
//       shift = 0;
//       result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1F) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//
//       int dLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lng += dLng;
//
//       double latitude = lat / 1e5;
//       double longitude = lng / 1e5;
//       points.add(LatLng(latitude, longitude));
//     }
//
//     return points;
//   }
//
//   Future<void> displayRoute() async {
//     if (currentLocation != null && destinationLocation != null) {
//       final directions = await getDirections(
//         currentLocation!,
//         destinationLocation!,
//       );
//
//       if (directions != null) {
//         List<LatLng> points = decodePolyline(
//           directions['routes'][0]['overview_polyline']['points'],
//         );
//
//         final PolylineId polylineId = PolylineId('route');
//         final Polyline poly = Polyline(
//           polylineId: polylineId,
//           color: Colors.blue,
//           points: points,
//         );
//
//         setState(() {
//           _polylines[polylineId] = poly;
//         });
//       }
//     }
//   }
//
//   Future<Map<String, dynamic>?> getDirections(LatLng origin, LatLng destination) async {
//     const String apiKey = 'AIzaSyCvSUtd3-nZo21tIJWDFgZyIMxaxlmD8qM'; // Replace with your API key
//     final String url =
//         'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$apiKey';
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       if (data['status'] == 'OK') {
//         return data;
//       } else if (data['status'] == 'ZERO_RESULTS') {
//         return null;
//       } else {
//         throw Exception('Google Maps API Error: ${data['status']}');
//       }
//     } else {
//       throw Exception('Failed to fetch directions');
//     }
//   }
//
//   Future<void> displayNearbyFuelStationsOnMap(List<PlaceDetails> fuelStations) async {
//     for (PlaceDetails station in fuelStations) {
//       final location = station.geometry?.location;
//       final marker = Marker(
//         markerId: MarkerId(station.placeId),
//         position: LatLng(location!.lat, location!.lng),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
//         infoWindow: InfoWindow(title: station.name, snippet: station.vicinity),
//         onTap: () {
//           showStationDetailsDialog(station);
//         },
//       );
//       setState(() {
//         _markers.add(marker);
//       });
//     }
//   }
//
//   void showStationDetailsDialog(PlaceDetails station) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text(station.name),
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text("Address: ${station.vicinity}"),
//                 // Add more station details as needed
//               ],
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text("Close"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Flutter Google Maps"),
//         centerTitle: true,
//       ),
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 final destination = await Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => DestinationSearchScreen(places: places),
//                   ),
//                 );
//                 if (destination != null) {
//                   setState(() {
//                     destinationLocation = destination;
//                   });
//
//                   clearMarkers(); // Clear previous markers
//
//                   displayRoute();
//                   searchNearbyFuelStations(destinationLocation! as Location);
//                 }
//               },
//               child: Text("Search Destination"),
//             ),
//             if (currentLocation != null)
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (BuildContext context) {
//                         return MapScreen(
//                           currentLocation: currentLocation!,
//                           destinationLocation: destinationLocation,
//                           polylines: _polylines,
//                           markers: _markers,
//                           places: places,
//                         );
//                       },
//                     ),
//                   );
//                 },
//                 child: Text("Open Map"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DestinationSearchScreen extends StatefulWidget {
//   final GoogleMapsPlaces places;
//
//   DestinationSearchScreen({required this.places});
//
//   @override
//   _DestinationSearchScreenState createState() => _DestinationSearchScreenState();
// }
//
// class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
//   TextEditingController destinationController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Search Destination"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: destinationController,
//               decoration: InputDecoration(
//                 hintText: "Enter your destination",
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () async {
//                 final destination = await searchDestination(destinationController.text);
//                 Navigator.of(context).pop(destination);
//               },
//               child: Text("Search"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<LatLng> searchDestination(String destinationName) async {
//     PlacesSearchResponse response = await widget.places.searchByText(destinationName);
//
//     if (response.status == 'OK' && response.results.isNotEmpty) {
//       final place = response.results.first;
//       final location = place.geometry!.location;
//       return LatLng(location.lat, location.lng);
//     }
//
//     return LatLng(0, 0);
//   }
// }
//
// class MapScreen extends StatefulWidget {
//   final LatLng currentLocation;
//   final LatLng? destinationLocation;
//   final Map<PolylineId, Polyline> polylines;
//   final List<Marker> markers;
//   final GoogleMapsPlaces places;
//
//   MapScreen({
//     required this.currentLocation,
//     this.destinationLocation,
//     required this.polylines,
//     required this.markers,
//     required this.places,
//   });
//
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? mapController;
//   double? distance;
//   Circle? searchRadiusCircle;
//
//   void showStationDetailsDialog(PlaceDetails station) {
//     // Your dialog code remains the same
//   }
//
//   void displayNearbyFuelStationsOnMap(List<PlaceDetails> fuelStations) {
//     // Your marker code remains the same
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.destinationLocation != null) {
//       distance = calculateDistance(
//         widget.currentLocation,
//         widget.destinationLocation!,
//       );
//     }
//   }
//
//   double calculateDistance(LatLng start, LatLng end) {
//     return Geolocator.distanceBetween(
//       start.latitude,
//       start.longitude,
//       end.latitude,
//       end.longitude,
//     );
//   }
//
//   Future<void> searchNearbyFuelStations(Location destinationLocation) async {
//     final response = await widget.places.searchNearbyWithRadius(
//       Location(lat: destinationLocation.lat, lng: destinationLocation.lng),
//       5000, // Adjust the radius as needed to match the search radius
//       keyword: 'fuel station',
//     );
//
//     if (response.status == 'OK' && response.results.isNotEmpty) {
//       final fuelStations = response.results;
//
//       final filteredFuelStations = fuelStations.where((station) {
//         final stationLocation = station.geometry?.location;
//         final distance = Geolocator.distanceBetween(
//           stationLocation?.lat ?? 0,
//           stationLocation?.lng ?? 0,
//           destinationLocation.lat,
//           destinationLocation.lng,
//         );
//
//         return distance <= 5000; // Adjust this value to match the search radius
//       });
//
//       displayNearbyFuelStationsOnMap(filteredFuelStations.cast<PlaceDetails>().toList());
//
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Map"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//
//                 if (widget.destinationLocation != null) {
//                   searchRadiusCircle = Circle(
//                     circleId: CircleId("searchRadius"),
//                     center: widget.destinationLocation!,
//                     radius: 5000, // Change the radius as needed (in meters)
//                     fillColor: Colors.blue.withOpacity(0.3),
//                     strokeWidth: 0,
//                   );
//                 }
//               },
//               initialCameraPosition: CameraPosition(
//                 target: widget.currentLocation,
//                 zoom: 12.0,
//               ),
//               markers: Set<Marker>.of([
//                 Marker(
//                   markerId: MarkerId("currentLocation"),
//                   position: widget.currentLocation,
//                   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//                   infoWindow: InfoWindow(title: "Current Location"),
//                 ),
//                 if (widget.destinationLocation != null)
//                   Marker(
//                     markerId: MarkerId("destinationLocation"),
//                     position: widget.destinationLocation!,
//                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//                     infoWindow: InfoWindow(title: "Destination Location"),
//                   ),
//                 ...widget.markers,
//               ]),
//               polylines: Set<Polyline>.of(widget.polylines.values),
//               circles: searchRadiusCircle != null ? Set<Circle>.of([searchRadiusCircle!]) : Set<Circle>(),
//             ),
//           ),
//           if (distance != null)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text("Distance: ${(distance! / 1000).toStringAsFixed(2)} kilometers"),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_webservice/places.dart';

class Fuelfinder extends StatefulWidget {

  final String location;
  const Fuelfinder({required this.location, Key? key}) : super(key: key);

  @override
  _FuelfinderState createState() => _FuelfinderState();
}

class _FuelfinderState extends State<Fuelfinder> {

  GoogleMapController? mapController;
  LatLng? currentLocation;
  LatLng? destinationLocation;
  Map<PolylineId, Polyline> _polylines = {};
  List<Marker> _markers = []; // List to store markers

  final places = GoogleMapsPlaces(apiKey: 'AIzaSyCvSUtd3-nZo21tIJWDFgZyIMxaxlmD8qM');

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

  Future<void> searchDestination(String destinationName) async {
    PlacesSearchResponse response = await places.searchByText(destinationName);

    if (response.status == 'OK' && response.results.isNotEmpty) {
      final place = response.results.first;
      final location = place.geometry!.location;
      setState(() {
        destinationLocation = LatLng(location.lat, location.lng);
      });
      displayRoute();
      searchNearbyFuelStations(destinationLocation! as Location); // Search for nearby fuel stations
    }
  }

  Future<void> searchNearbyFuelStations(Location destinationLocation) async {
    final response = await places.searchNearbyWithRadius(
      Location(lat: destinationLocation.lat, lng: destinationLocation.lng),
      5000, // Adjust the radius as needed
      keyword: 'fuel station',
    );

    if (response.status == 'OK' && response.results.isNotEmpty) {
      final fuelStations = response.results;
      displayNearbyFuelStationsOnMap(fuelStations.cast<PlaceDetails>());
    }
  }


  // Helper function to decode the polyline
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
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

  Future<Map<String, dynamic>?> getDirections(LatLng origin, LatLng destination) async {
    const String apiKey = 'AIzaSyCvSUtd3-nZo21tIJWDFgZyIMxaxlmD8qM';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$apiKey';

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
  Future<void> displayNearbyFuelStationsOnMap(List<PlaceDetails> fuelStations) async {
    for (PlaceDetails station in fuelStations) {
      final location = station.geometry?.location;
      final marker = Marker(
        markerId: MarkerId(station.placeId),
        position: LatLng(location!.lat, location!.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: station.name, snippet: station.vicinity),
      );
      setState(() {
        _markers.add(marker);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Google Maps"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text("Location: ${widget.location}"),
            ElevatedButton(
              onPressed: () async {
                final destination = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DestinationSearchScreen(
                      places: places,
                      location: widget.location,
                    ),
                  ),
                );
                if (destination != null) {
                  setState(() {
                    destinationLocation = destination;
                  });
                  displayRoute();
                  searchNearbyFuelStations(destinationLocation! as Location);
                }
              },
              child: Text("Search Destination"),
            ),
            if (currentLocation != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MapScreen(
                          currentLocation: currentLocation!,
                          destinationLocation: destinationLocation,
                          polylines: _polylines,
                          markers: _markers,
                        );
                      },
                    ),
                  );
                },
                child: Text("Open Map"),
              ),
          ],
        ),
      ),
    );
  }
}

class DestinationSearchScreen extends StatefulWidget {
  final GoogleMapsPlaces places;
  final String location;

  DestinationSearchScreen({required this.places, required this.location});

  @override
  _DestinationSearchScreenState createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  late TextEditingController destinationController;

  @override
  void initState() {
    super.initState();
    destinationController = TextEditingController(text: widget.location);
  }


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

class MapScreen extends StatefulWidget {
  final LatLng currentLocation;
  final LatLng? destinationLocation;
  final Map<PolylineId, Polyline> polylines;
  final List<Marker> markers;

  MapScreen({
    required this.currentLocation,
    this.destinationLocation,
    required this.polylines,
    required this.markers,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  double? distance;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Map"),
        ),
        body: Column(
            children: [
              Expanded(
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: widget.currentLocation,
                    zoom: 12.0,
                  ),
                  markers: Set<Marker>.of(widget.markers),
                  polylines: Set<Polyline>.of(widget.polylines.values),
                ),
              ),
              if (distance != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Distance: ${(distance! / 1000).toStringAsFixed(2)} kilometers"),
                ),
            ],
           ),
       );
  }
}
