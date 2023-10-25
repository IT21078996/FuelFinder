import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fuel_finder/screens/AddStation.dart';
import 'package:fuel_finder/screens/DetailPage.dart';


class showall extends StatefulWidget {
  const showall({Key? key}) : super(key: key);

  @override
  _showallState createState() => _showallState();
}

class _showallState extends State<showall> {
  final CollectionReference _stations = FirebaseFirestore.instance.collection('stations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite Stations"),
      ),
      body: StreamBuilder(
        stream: _stations.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                final String sname = documentSnapshot['SName']; // Extract name
                final String location = documentSnapshot['Location']; // Extract description
                final String stationId = documentSnapshot.id;
                return GestureDetector(
                  onTap: () {
                    // Navigate to the details page when a card is tapped.
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(stationId : stationId),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(sname),
                      subtitle: Text(location),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}