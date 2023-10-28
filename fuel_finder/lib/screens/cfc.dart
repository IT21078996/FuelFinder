import 'package:flutter/material.dart';
import 'package:fuel_finder/constants/colors.dart';
import 'package:fuel_finder/screens/cfc_form.dart';

import 'logs.dart';

class CFC extends StatelessWidget {
  const CFC({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/cc_banner.png',
                width: 200,
                height: 200,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 8.0),
              child: Text(
                'Track your personal carbon footprint',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'How do we live? What do we eat? How do we get around? Our daily way of live has a huge impact on our planet. Day by day, CO2 emissions are created by driving cars, heating, cooking, working, celebrating and flying. Find out the amount of CO2 emissions created by your personal way of life with ease, using our footprint calculator.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: textBody),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IntermediateScreen()),
                );
              },
              child: Text(
                'Try Calculator',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntermediateScreen extends StatelessWidget {
  const IntermediateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double topMargin = screenHeight * 0.35; // Adjust the fraction

    return Scaffold(
      appBar: AppBar(
        title: Text('Carbon Tracker'),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/sustainable.jpg'),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'What is a carbon footprint ?',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'A carbon footprint is the amount of greenhouse gases, primarily carbon dioxide, released into the atmosphere by a particular human activity. It can be a broad measure or be applied to the actions of an individual, a family, an event, an organization, or even an entire nation.',
                          style: TextStyle(fontSize: 16, color: textBody),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Note: In the Carbon Footprint Calculator, we estimate an individual's daily environmental impact, primarily carbon dioxide emissions, using data from SLSEA.",
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogsScreen(),
                        ),
                      );
                    },
                    child: Text('Check Logs'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CFCForm(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Track Emission'),
                        // Icon(Icons.arrow_forward),
                      ],
                    ),
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
