import 'package:flutter/material.dart';

import 'AddStation.dart';
import 'map.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedVehicleType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Logo in the top left corner
          Positioned(
            top: 10, // Adjust the position as needed
            left: 80, // Adjust the position as needed
            child: Image.asset(
              'assets/images/logo.png', // Replace with the path to your logo image
              width: 250,
              height: 70, // Adjust the width as needed
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 120),
              // Adjust the padding as needed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    'Welcome to Fuel Finder',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Find the nearest Fuel station,',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 280, // Adjust the position as needed
            left: 20, // Adjust the position as needed
            child: CustomContainer(
              width: 370, // Changeable width
              height: 275, // Changeable height
              backgroundColor: Colors.black12, // Set the background color to light blue
              onProceedPressed: () {
                if (selectedVehicleType.isNotEmpty) {
                  // Navigate to the 'AddStation' screen or perform your action.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapScreenWithLocation(),
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
              },// Set the background color to light blue
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select Your Vehicle Type',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      VehicleCard(
                        vehicleType: 'Gas',
                        iconData: Icons.local_gas_station, // Icon for Gas
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
                        iconData: Icons.battery_charging_full, // Icon for Electric
                        isSelected: selectedVehicleType == 'Electric',
                        onSelect: () {
                          setState(() {
                            selectedVehicleType = 'Electric';
                          });
                        },
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final String vehicleType;
  final IconData iconData; // Icon for the vehicle type
  final bool isSelected;
  final VoidCallback onSelect;

  VehicleCard({
    required this.vehicleType,
    required this.iconData,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Card(
        color: isSelected ? Colors.red : Colors.white,
        child: SizedBox(
          width: 100, // Adjust the width as needed
          height: 100, // Adjust the height as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: 40, // Adjust the icon size as needed
                color: isSelected ? Colors.white : Colors.black, // Adjust icon color
              ),
              SizedBox(height: 8),
              Text(
                vehicleType,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class CustomContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final Widget child;
  final VoidCallback onProceedPressed;

  CustomContainer({
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.child,
    required this.onProceedPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10, // Adjust the position as needed
            right: 10, // Adjust the position as needed
            child: ElevatedButton(
              onPressed: onProceedPressed,
              child: Container(
                width: 150, // Adjust the width as needed
                height: 30, // Adjust the height as needed
                child: Center(
                  child: Text(
                    'Proceed  >',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          child, // Your original content
        ],
      ),
    );
  }
}

