import 'package:fuel_finder/models/user.dart';
import 'package:fuel_finder/screens/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/navigation.dart';
import 'cfc.dart';
import 'home.dart';
import 'map.dart';
import 'user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key});

  @override
  Widget build(BuildContext context) {
    // Get the user data that the provider provides
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      // If the user is not authenticated
      return const Auth();
    } else {
      // If the user is authenticated
      return const BottomNavigationDemo(); // Pass the initial index as needed
    }
  }
}

class BottomNavigationDemo extends StatefulWidget {
  const BottomNavigationDemo({super.key});

  @override
  _BottomNavigationDemoState createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FuelFinder'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    MapScreenWithLocation(),
    const CFC(),
    const User(),
  ];
}
