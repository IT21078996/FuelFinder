import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fuel_finder/models/user.dart';
import 'package:fuel_finder/screens/AdminH.dart';
import 'package:fuel_finder/screens/wrapper.dart';
import 'package:fuel_finder/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData:
          UserModel(uid: "", name: '', email: '', profilePictureUrl: ''),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FuelFinder',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const Wrapper(),
      ),
    );
  }
}
