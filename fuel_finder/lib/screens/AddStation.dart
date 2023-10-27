import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddStation extends StatefulWidget {
  const AddStation({Key? key}) : super(key: key);

  @override
  _AddStationState createState() => _AddStationState();
}

class _AddStationState extends State<AddStation> {
  // Text fields' controllers
  final TextEditingController _stationnameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _noofpumpsController = TextEditingController();

  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();


  List<String> OpenCloseStatusOptions = ['OPEN', 'CLOSE'];
  String selectedOpenCloseStatus = 'OPEN'; // Default value

  bool evChargersAvailable = false;

  // Define fuel type options
  List<String> fuelTypeOptions = ['Petrol', 'Diesel', 'Petrol (95)', 'Super Diesel', 'Chargers'];

  String selectedFuelType = 'Petrol'; // Default value


  final CollectionReference _poiCollection = FirebaseFirestore.instance
      .collection('stations');

  Map<String, String> fuelTypeQuantityMap = {};

  Future<void> _create() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Scaffold(
          body: Form(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 60.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: DropdownButton<String>(
                        value: selectedOpenCloseStatus,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOpenCloseStatus = newValue!;
                          });
                        },
                        items: OpenCloseStatusOptions.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Text('EV Chargers Available: ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Checkbox(
                          value: evChargersAvailable,
                          onChanged: (newValue) {
                            setState(() {
                              evChargersAvailable = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: _stationnameController,
                      decoration: const InputDecoration(
                        labelText: 'Station Name : ',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location : ',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Latitude: ',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Longitude: ',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      alignment: Alignment.centerLeft, // Adjust alignment as needed
                      child: DropdownButton<String>(
                        value: selectedFuelType,
                        onChanged: (newValue) {
                          setState(() {
                            selectedFuelType = newValue!;
                          });
                        },
                        items: fuelTypeOptions.map((fuelType) {
                          return DropdownMenuItem<String>(
                            value: fuelType,
                            child: Text(fuelType),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity : ',
                        labelStyle: TextStyle(color: Colors.grey),
                        suffixText: 'liters',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black54), // Change the button's background color
                        padding: MaterialStateProperty.all(EdgeInsets.all(10.0)), // Adjust padding
                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)), // Change the text style
                      ),
                      child: Text('Add Fuel Type and Quantity',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        final String fuelType = selectedFuelType;
                        final String quantity = _quantityController.text;

                        if (fuelType.isNotEmpty && quantity.isNotEmpty) {
                          fuelTypeQuantityMap[fuelType] = quantity;
                          _quantityController.text = '';
                        }
                      },
                    )
                    ,
                    const SizedBox(height: 20),
                    TextField(
                      controller: _noofpumpsController,
                      decoration: const InputDecoration(
                        labelText: 'No Of Pumps : ',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 80),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent), // Change the button's background color
                        padding: MaterialStateProperty.all(EdgeInsets.all(12.0)), // Adjust padding
                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 24)), // Change the text style
                      ),
                      child: const Text('Submit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        final String sname = _stationnameController.text;
                        final String location = _locationController.text;
                        final String noofpumps = _noofpumpsController.text;

                        if (sname.isNotEmpty &&
                            location.isNotEmpty &&
                            noofpumps.isNotEmpty &&
                            fuelTypeQuantityMap.isNotEmpty) {
                          await _poiCollection.add({
                            "SName": sname,
                            "Location": location,
                            "noofpumps": noofpumps,
                            "status": selectedOpenCloseStatus,
                            "fuelTypeQuantityMap": fuelTypeQuantityMap,
                            "evChargersAvailable": evChargersAvailable, // Include EV chargers availability
                            "latitude": _latitudeController.text,
                            "longitude": _longitudeController.text,
                          });

                          _stationnameController.text = '';
                          _locationController.text = '';
                          _noofpumpsController.text = '';
                          _latitudeController.text = '';
                          _longitudeController.text = '';
                          fuelTypeQuantityMap.clear();

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('You have successfully Created !!! '),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {

      selectedOpenCloseStatus = documentSnapshot['status'];
      _stationnameController.text = documentSnapshot['SName'];
      _locationController.text = documentSnapshot['Location'];
      _noofpumpsController.text = documentSnapshot['noofpumps'];

      _latitudeController.text = documentSnapshot['latitude'];
      _longitudeController.text = documentSnapshot['longitude'];

      // Populate the fuelTypeQuantityMap from the document snapshot
      Map<String, dynamic> fuelTypeQuantityData =
      documentSnapshot['fuelTypeQuantityMap'];
      fuelTypeQuantityMap.clear();
      fuelTypeQuantityData.forEach((key, value) {
        fuelTypeQuantityMap[key] = value.toString();
      });
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Scaffold(
          body: Form(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 60.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: DropdownButton<String>(
                        value: selectedOpenCloseStatus,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOpenCloseStatus = newValue!;
                          });
                        },
                        items: OpenCloseStatusOptions.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Text('EV Chargers Available: ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Checkbox(
                          value: evChargersAvailable,
                          onChanged: (newValue) {
                            setState(() {
                              evChargersAvailable = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _stationnameController,
                      decoration: const InputDecoration(
                        labelText: 'Station Name : ',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location : ',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Latitude: ',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Longitude: ',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Display Fuel Types and Quantities
                    if (fuelTypeQuantityMap.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fuel Types and Quantities:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Column(
                            children: fuelTypeQuantityMap.entries
                                .map((entry) {
                              return ListTile(
                                title: Text(entry.key),
                                subtitle: Text(entry.value + ' liters'),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {_editFuelTypeQuantity(entry.key);},
                                ),

                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),

                    DropdownButton<String>(
                      value: selectedFuelType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedFuelType = newValue!;
                        });
                      },
                      items: fuelTypeOptions.map((fuelType) {
                        return DropdownMenuItem<String>(
                          value: fuelType,
                          child: Text(fuelType),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity : ',
                        labelStyle: TextStyle(color: Colors.grey),
                        suffixText: 'liters',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black54), // Change the button's background color
                        padding: MaterialStateProperty.all(EdgeInsets.all(10.0)), // Adjust padding
                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)), // Change the text style
                      ),
                      child: const Text('Add Fuel Type and Quantity'),
                      onPressed: () {
                        final String fuelType = selectedFuelType;
                        final String quantity = _quantityController.text;

                        if (fuelType.isNotEmpty && quantity.isNotEmpty) {
                          fuelTypeQuantityMap[fuelType] = quantity;
                          _quantityController.text = '';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _noofpumpsController,
                      decoration: const InputDecoration(
                        labelText: 'No Of Pumps : ',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepOrangeAccent), // Change the button's background color
                        padding: MaterialStateProperty.all(EdgeInsets.all(12.0)), // Adjust padding
                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 24)), // Change the text style
                      ),
                      child: const Text('Update'),
                      onPressed: () async {
                        final String sname = _stationnameController.text;
                        final String location = _locationController.text;
                        final String noofpumps = _noofpumpsController.text;

                        await _poiCollection.doc(documentSnapshot?.id).update({
                          "SName": sname,
                          "Location": location,
                          "noofpumps": noofpumps,
                          "status": selectedOpenCloseStatus,
                          "fuelTypeQuantityMap": fuelTypeQuantityMap,
                          "evChargersAvailable": evChargersAvailable,
                          "latitude": _latitudeController.text,
                          "longitude": _longitudeController.text,
                        });

                        _stationnameController.text = '';
                        _locationController.text = '';
                        _noofpumpsController.text = '';
                        _latitudeController.text = '';
                        _longitudeController.text = '';
                        fuelTypeQuantityMap.clear();

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You have successfully Updated !!! '),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _editFuelTypeQuantity(String fuelType) {
    // You can implement an edit dialog or form to edit the quantity for the selected fuel type.
    // Update the quantity in fuelTypeQuantityMap accordingly.
    // You may also want to provide an option to delete the fuel type.
    // Example implementation:
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Fuel Type Quantity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Fuel Type: $fuelType'),
              TextField(
                controller: TextEditingController(text: fuelTypeQuantityMap[fuelType]),
                onChanged: (value) {
                  // Update the quantity in fuelTypeQuantityMap as the user types
                  fuelTypeQuantityMap[fuelType] = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the edited quantity here
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                // Delete the fuel type from fuelTypeQuantityMap
                _deleteFuelType(fuelType);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteFuelType(String fuelType) {
    // Delete the specified fuel type from fuelTypeQuantityMap
    fuelTypeQuantityMap.remove(fuelType);
  }


  Future<void> _delete(String placeId) async {
    await _poiCollection.doc(placeId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('You have successfully deleted a place'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder(
        stream: _poiCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['SName']),
                    subtitle: Text(documentSnapshot['Location']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () => _update(documentSnapshot),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _delete(documentSnapshot.id),
                        ),
                      ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
