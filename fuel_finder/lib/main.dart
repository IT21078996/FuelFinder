import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fuel_finder/screens/AddStation.dart';
import 'package:fuel_finder/screens/home.dart';
import 'package:fuel_finder/screens/map.dart';
import 'package:fuel_finder/screens/cfc.dart';
import 'package:fuel_finder/screens/user.dart';
import 'package:fuel_finder/widgets/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
 Widget build(BuildContext context) {
    return MaterialApp(
     title: 'FuelFinder',
      theme: ThemeData(
       primarySwatch: Colors.deepOrange,),
     home: const BottomNavigationDemo(),
    );
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
   const Map(),
const CFC(),
   const User(),
 ];
}
