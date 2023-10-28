import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carbon Tracker'),
      ),
      body: Column(
        children: <Widget>[
          Image.asset('assets/images/logs_banner.jpg'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Carbon Tracker Logs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('cfc_logs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No data available.'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    final carbonFootprint = document['carbonFootprint'];
                    final travelEmissions = document['travelEmissions'];
                    final dietEmissions = document['dietEmissions'];
                    final electricityEmissions =
                        document['electricityEmissions'];
                    final timestamp = document['timestamp'].toDate();
                    final documentId = document.id; // Get the document ID

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          'Date: ${DateFormat('MM/dd/yyyy').format(timestamp)}', // Format the date (without time)
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTileData('Carbon Footprint', carbonFootprint),
                            ListTileData('Travel Emissions', travelEmissions),
                            ListTileData('Diet Emissions', dietEmissions),
                            ListTileData(
                                'Electricity Emissions', electricityEmissions),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            _confirmDeleteDialog(context, documentId);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ListTileData(String label, dynamic value) {
    String formattedValue =
        value.toStringAsFixed(2); // Format the value with 2 decimal places
    return Row(
      children: [
        Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('$formattedValue kg CO2e'),
      ],
    );
  }

  void _confirmDeleteDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this log entry?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteLog(documentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteLog(String documentId) {
    FirebaseFirestore.instance
        .collection('cfc_logs')
        .doc(documentId)
        .delete()
        .then((_) {
      // Successfully deleted, you can perform any additional actions or show a confirmation to the user.
    }).catchError((error) {
      // Handle any errors here.
    });
  }
}
