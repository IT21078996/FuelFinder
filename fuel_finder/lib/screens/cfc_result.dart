import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Carbon Emitted by Travel:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.travelEmissions.toStringAsFixed(2)} kg CO2e',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Carbon Emitted by Dietary Patterns:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.dietEmissions.toStringAsFixed(2)} kg CO2e',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Carbon Emitted by Electricity:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.electricityEmissions.toStringAsFixed(2)} kg CO2e',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Total Emission:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.carbonFootprint.toStringAsFixed(2)} kg CO2e',
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the input screen.
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
