import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fuel_finder/screens/fuelfindermap.dart';

class DetailPage extends StatelessWidget {
  final String stationId;

  const DetailPage({required this.stationId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Station Details"),
      ),
      body: FutureBuilder(
        future:
        FirebaseFirestore.instance.collection('stations').doc(stationId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Station not found'));
          } else {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final String sname = data['SName'];
            final String location = data['Location'];
            final String noofpumps = data['noofpumps'];
            final String status = data['status'];
            Map<String, dynamic> fuelTypeQuantityData = data['fuelTypeQuantityMap'];


            return Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/pumps.jpg', // Replace with the path to your image asset
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      width: 400.0, // Adjust the width of the box as needed
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white, // Box background color
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 24.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.local_gas_station,
                                size: 24.0,
                              ),
                              SizedBox(width: 16.0),
                              Text(
                                sname,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.map,
                                size: 24.0,
                              ),
                              SizedBox(width: 16.0),
                              Text(
                                location,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.0),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: fuelTypeQuantityData.entries.map((entry) {
                                IconData fuelIcon;
                                String fuelType = entry.key.toLowerCase(); // Assuming fuel type matches icon names

                                // Map fuel types to corresponding icons
                                if (fuelType.contains("diesel")) {
                                  fuelIcon = Icons.local_gas_station; // You can replace this with a diesel icon
                                } else if (fuelType.contains("petrol")) {
                                  fuelIcon = Icons.local_gas_station; // You can replace this with a petrol icon
                                } else if (fuelType.contains("electric")) {
                                  fuelIcon = Icons.battery_full; // You can replace this with an electric icon
                                } else {
                                  // Default icon for unknown fuel types
                                  fuelIcon = Icons.local_gas_station;
                                }

                                double quantity = double.tryParse(entry.value) ?? 0.0;
                                double percentage = (quantity / 10000) * 100;
                                String formattedPercentage = percentage.toStringAsFixed(2) + '%';

                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16.0), // Add spacing between items
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        fuelIcon,
                                        size: 32.0, // Adjust the icon size as needed
                                      ),
                                      Text(
                                        entry.key, // Fuel type name
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        entry.value + ' liters', // Percentage value
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        formattedPercentage, // Percentage value
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Fuelfinder(), // Pass the location to the new page
                      ),
                    );
                  },
                  child: Text("Get Direction"),
                ),

              ],
            );

          }
        },
      ),
    );
  }
}
