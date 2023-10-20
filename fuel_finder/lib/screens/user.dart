import 'package:flutter/material.dart';
import 'package:fuel_finder/services/auth.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text('User Screen'),
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
            },
            child: const Text('Log Out'),
          )
        ],
      ),
    );
  }
}
