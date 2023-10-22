import 'package:flutter/material.dart';
import 'package:fuel_finder/screens/cfc_form.dart';

class CFC extends StatelessWidget {
  const CFC({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Carbon Footprint is the amount of greenhouse gases primarily carbon dioxide released into the atmosphere by a particular human activity. A carbon footprint can be a broad measure or be applied to the actions of an individual, a family, an event, an organization, or even an entire nation.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CFCForm()),
                  );
                },
                child: Text('Try Calculator'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
