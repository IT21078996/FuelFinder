import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fuel_finder/screens/AddStation.dart';
import 'package:fuel_finder/screens/DetailPage.dart';

class showallEV extends StatefulWidget {
  const showallEV({Key? key}) : super(key: key);

  @override
  _showallState createState() => _showallState();
}

class _showallState extends State<showallEV> {
  final CollectionReference _stations = FirebaseFirestore.instance.collection('stations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EV Charging Stations"),
      ),
      body: StreamBuilder(
        stream: _stations.where('evChargersAvailable', isEqualTo: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                final String sname = documentSnapshot['SName'];
                final String location = documentSnapshot['Location'];
                final String stationId = documentSnapshot.id;
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(stationId: stationId),
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
