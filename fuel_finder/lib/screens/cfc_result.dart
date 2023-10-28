import 'package:flutter/material.dart';
import 'package:fuel_finder/screens/logs.dart';

import 'cfc.dart';

class CFCResult extends StatefulWidget {
  final double carbonFootprint;
  final double travelEmissions;
  final double dietEmissions;
  final double electricityEmissions;

  CFCResult({
    Key? key,
    required this.carbonFootprint,
    required this.travelEmissions,
    required this.dietEmissions,
    required this.electricityEmissions,
  }) : super(key: key);

  @override
  State<CFCResult> createState() => _CFCResultState();
}

class _CFCResultState extends State<CFCResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carbon Footprint Result'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/cfc_results_banner.png'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Travel Emissions
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(
                        Icons.airplanemode_active,
                        size: 32,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Carbon Emitted by Travel',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${widget.travelEmissions.toStringAsFixed(2)} kg CO2e',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Dietary Emissions
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(
                        Icons.restaurant,
                        size: 32,
                        color: Colors.orange,
                      ),
                      title: Text(
                        'Carbon Emitted by Dietary Patterns',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${widget.dietEmissions.toStringAsFixed(2)} kg CO2e',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Electricity Emissions
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(
                        Icons.lightbulb,
                        size: 32,
                        color: Colors.green,
                      ),
                      title: Text(
                        'Carbon Emitted by Electricity',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${widget.electricityEmissions.toStringAsFixed(2)} kg CO2e',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Total Emission
                  Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        'Total Emission',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${widget.carbonFootprint.toStringAsFixed(2)} kg CO2e',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CFC(),
                            ),
                          );
                        },
                        child: Text('Back'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogsScreen(),
                            ),
                          );
                        },
                        child: Text('Logs'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
