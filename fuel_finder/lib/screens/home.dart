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
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    'FUEL',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'FINDER',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 40),
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
            top: 300,
            left: 20,
            child: CustomContainer(
              width: 370,
              height: 275,
              backgroundColor: Colors.black12, // Background color
              onProceedPressed: () {
                if (selectedVehicleType.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Fuelfinderr(),
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
                        iconData: Icons.local_gas_station,
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
                        iconData: Icons.battery_charging_full,
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
  final IconData iconData;
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
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: 40,
                color: isSelected ? Colors.white : Colors.black,
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
            bottom: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: onProceedPressed,
              child: Container(
                width: 150,
                height: 30,
                child: Center(
                  child: Text(
                    'Proceed  >',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
