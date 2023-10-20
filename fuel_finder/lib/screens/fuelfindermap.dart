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
