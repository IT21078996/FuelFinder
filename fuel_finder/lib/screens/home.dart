import 'package:flutter/material.dart';
import 'package:fuel_finder/screens/AddStation.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedVehicleType = ''; // To store the selected vehicle type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      // appBar: AppBar(
      //   title: Text('Home'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose your vehicle type',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VehicleCard(
                  vehicleType: 'Gas',
                  isSelected: selectedVehicleType == 'Gas',
                  onSelect: () {
                    setState(() {
                      selectedVehicleType = 'Gas';
                    });
                  },
                ),
                SizedBox(width: 16),
                VehicleCard(
                  vehicleType: 'Electric',
                  isSelected: selectedVehicleType == 'Electric',
                  onSelect: () {
                    setState(() {
                      selectedVehicleType = 'Electric';
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedVehicleType.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddStation(),
                    ),
                  );
                  print('Selected vehicle type: $selectedVehicleType');
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Please select a vehicle type'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final String vehicleType;
  final bool isSelected;
  final VoidCallback onSelect;

  VehicleCard({
    required this.vehicleType,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Card(
        color: isSelected ? Colors.blue : Colors.white,
        child: SizedBox(
          width: 150,
          height: 200,
          child: Center(
            child: Text(
              vehicleType,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
