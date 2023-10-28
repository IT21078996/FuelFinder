import 'package:flutter/material.dart';
import 'package:fuel_finder/constants/colors.dart';
import 'package:fuel_finder/constants/styles.dart';
import 'package:fuel_finder/screens/cfc_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CFCForm extends StatefulWidget {
  const CFCForm({Key? key}) : super(key: key);

  @override
  _CFCFormState createState() => _CFCFormState();
}

class _CFCFormState extends State<CFCForm> {
  int currentStep = 0; // Track the current step
  bool showFoodWeights = false;
  String? selectedVehicleType;
  TextEditingController distanceController = TextEditingController();
  bool homemadeFood = true;
  String? selectedFoodType;
  double meatWeight = 0;
  double dairyWeight = 0;
  double vegetablesWeight = 0;
  double grainsWeight = 0;
  double fruitsWeight = 0;
  double seafoodWeight = 0;
  double processedFoodsWeight = 0;
  double electricityConsumption = 0;
  String? selectedElectricitySource;
  double carbonFootprint = 0;

  // Create boolean variables for each food type to track whether to show the text fields.
  bool showMeatWeight = true;
  bool showDairyWeight = true;
  bool? showVegetablesWeight = true;
  bool? showGrainsWeight = true;
  bool? showFruitsWeight = false;
  bool? showSeafoodWeight = false;
  bool? showProcessedFoodsWeight = true;

  Future<void> saveUserDataToFirestore({
    double? carbonFootprint,
    double? travelEmissions,
    double? dietEmissions,
    double? electricityEmissions,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;

      await firestoreInstance.collection('cfc_logs').add({
        'carbonFootprint': carbonFootprint,
        'travelEmissions': travelEmissions,
        'dietEmissions': dietEmissions,
        'electricityEmissions': electricityEmissions,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('User data saved to Firestore.');
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }

  // Define the steps for the Stepper
  List<Step> steps = [];

  @override
  void initState() {
    super.initState();

    // Define the steps for the Stepper
    steps = [
      Step(
        title: Row(
          children: [
            Image.asset('assets/images/step1.png', height: 50, width: 50),
            Text(
              'Travel Data',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        subtitle: Text(
          'Distance that you have traveled and medium',
          style: TextStyle(fontSize: 14),
        ),
        content: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: distanceController,
              keyboardType: TextInputType.number,
              decoration: txtInputDeco2.copyWith(
                  labelText: 'Distance', suffix: Text('km')),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedVehicleType,
              decoration: txtInputDeco2.copyWith(labelText: 'Vehicle Type'),
              items: const [
                DropdownMenuItem<String>(
                  value: 'car',
                  child: Text('Car'),
                ),
                DropdownMenuItem<String>(
                  value: 'bus',
                  child: Text('Bus'),
                ),
                DropdownMenuItem<String>(
                  value: 'train',
                  child: Text('Train'),
                ),
                DropdownMenuItem<String>(
                  value: 'bicycle',
                  child: Text('Bicycle'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  selectedVehicleType = value;
                });
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
        isActive: currentStep == 0, // Mark as active step
      ),
      Step(
        title: Row(
          children: [
            Image.asset('assets/images/step2.png', height: 50, width: 50),
            Text(
              'Diet Data',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        subtitle: Text(
          'Food that you have consumed',
          style: TextStyle(fontSize: 14),
        ),
        content: Column(
          children: [
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedFoodType,
              decoration: txtInputDeco2.copyWith(labelText: 'Food Source'),
              items: const [
                DropdownMenuItem<String>(
                  value: 'homemade',
                  child: Text('Homemade Food'),
                ),
                DropdownMenuItem<String>(
                  value: 'bought',
                  child: Text('Bought Food'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  selectedFoodType = value;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Meat Weight (kg)'),
              value: showMeatWeight,
              onChanged: (bool? value) {
                setState(() {
                  showMeatWeight = value!;
                  print('Meat Weight CheckBox: $showMeatWeight');
                });
              },
            ),
            Visibility(
              visible: showMeatWeight,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  meatWeight = double.tryParse(value) ?? 0;
                },
              ),
            ),
            CheckboxListTile(
              title: Text('Dairy Weight (kg)'),
              value: showDairyWeight,
              onChanged: (bool? value) {
                setState(() {
                  showDairyWeight = value!;
                  print('dairy Weight CheckBox: $showDairyWeight');
                });
              },
            ),
            Visibility(
              visible: showDairyWeight,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  dairyWeight = double.tryParse(value) ?? 0;
                },
              ),
            ),
            CheckboxListTile(
              title: Text('Vegetables Weight (kg)'),
              value: showVegetablesWeight ?? false,
              onChanged: (bool? value) {
                setState(() {
                  showVegetablesWeight = value;
                });
              },
            ),
            Visibility(
              visible: showVegetablesWeight ?? false,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  vegetablesWeight = double.tryParse(value) ?? 0;
                },
              ),
            ),
            CheckboxListTile(
              title: Text('Grains Weight (kg)'),
              value: showGrainsWeight ?? false,
              onChanged: (bool? value) {
                setState(() {
                  showGrainsWeight = value;
                });
              },
            ),
            Visibility(
              visible: showGrainsWeight ?? false,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  grainsWeight = double.tryParse(value) ?? 0;
                },
              ),
            ),
            CheckboxListTile(
              title: Text('Fruits Weight (kg)'),
              value: showFruitsWeight ?? false,
              onChanged: (bool? value) {
                setState(() {
                  showFruitsWeight = value;
                });
              },
            ),
            Visibility(
              visible: showFruitsWeight ?? false,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  fruitsWeight = double.tryParse(value) ?? 0;
                },
              ),
            ),
            CheckboxListTile(
              title: Text('Seafood Weight (kg)'),
              value: showSeafoodWeight ?? false,
              onChanged: (bool? value) {
                setState(() {
                  showSeafoodWeight = value;
                });
              },
            ),
            Visibility(
              visible: showSeafoodWeight ?? false,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  seafoodWeight = double.tryParse(value) ?? 0;
                },
              ),
            ),
            CheckboxListTile(
              title: Text('Processed Foods Weight (kg)'),
              value: showProcessedFoodsWeight ?? false,
              onChanged: (bool? value) {
                setState(() {
                  showProcessedFoodsWeight = value;
                });
              },
            ),
            Visibility(
              visible: showProcessedFoodsWeight ?? false,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  processedFoodsWeight = double.tryParse(value) ?? 0;
                },
              ),
            ),
          ],
        ),
        isActive: currentStep == 1, // Mark as active step
      ),
      Step(
        title: Row(
          children: [
            Image.asset('assets/images/step3.png', height: 50, width: 50),
            Text(
              'Electricity Data',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        subtitle: Text(
          'Electricity that you have consumed',
          style: TextStyle(fontSize: 14),
        ),
        content: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: txtInputDeco2.copyWith(
                  labelText: 'Electricity consumption', suffix: Text('kWh')),
              onChanged: (value) {
                electricityConsumption = double.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedElectricitySource,
              decoration:
                  txtInputDeco2.copyWith(labelText: 'Electricity Source'),
              items: const [
                DropdownMenuItem<String>(
                  value: 'coal',
                  child: Text('Coal'),
                ),
                DropdownMenuItem<String>(
                  value: 'natural_gas',
                  child: Text('Natural Gas'),
                ),
                DropdownMenuItem<String>(
                  value: 'renewables',
                  child: Text('Renewables'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  selectedElectricitySource = value;
                });
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
        isActive: currentStep == 2, // Mark as active step
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(125.0),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cfc_form_banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // title: Text('Carbon Tracker'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Stepper(
            currentStep: currentStep,
            onStepContinue: () {
              if (currentStep < steps.length - 1) {
                setState(() {
                  currentStep++;
                });
              } else {
                calculateCarbonFootprint();
              }
            },
            onStepCancel: () {
              if (currentStep > 0) {
                setState(() {
                  currentStep--;
                });
              }
            },
            steps: steps,
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                children: <Widget>[
                  if (details.onStepContinue != null)
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text('Next'),
                    ),
                  if (details.onStepCancel != null)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text('Back'),
                    ),
                ],
              );
            },
          ),
        ));
  }

  void calculateCarbonFootprint() {
    double distance = double.tryParse(distanceController.text) ?? 0;
    double transportationEmissions =
        calculateTransportationEmissions(distance, selectedVehicleType);
    double dietaryEmissions = calculateDietaryEmissions(
        selectedFoodType,
        meatWeight,
        dairyWeight,
        vegetablesWeight,
        grainsWeight,
        fruitsWeight,
        seafoodWeight,
        processedFoodsWeight);
    double electricityEmissions = calculateElectricityEmissions(
        electricityConsumption, selectedElectricitySource);
    carbonFootprint =
        transportationEmissions + dietaryEmissions + electricityEmissions;

    saveUserDataToFirestore(
      carbonFootprint: carbonFootprint,
      travelEmissions: transportationEmissions,
      dietEmissions: dietaryEmissions,
      electricityEmissions: electricityEmissions,
    );

    // Navigate to the result screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CFCResult(
          carbonFootprint: carbonFootprint,
          travelEmissions: transportationEmissions,
          dietEmissions: dietaryEmissions,
          electricityEmissions: electricityEmissions,
        ),
      ),
    );
  }

  double calculateTransportationEmissions(
      double distance, String? vehicleType) {
    double emissionsFactor = 0.0; // Default value for no emissions

    // Define emission factors for different vehicle types
    final double emissionFactorCar = 2.28; // kg CO2 per km for gasoline
    final double emissionFactorBusTrain = 2.74; // kg CO2 per km for diesel

    if (vehicleType == 'car') {
      emissionsFactor = emissionFactorCar;
    } else if (vehicleType == 'bus' || vehicleType == 'train') {
      emissionsFactor = emissionFactorBusTrain;
    }

    return distance * emissionsFactor;
  }

  double calculateDietaryEmissions(
      String? foodType,
      double meatWeight,
      double dairyWeight,
      double vegetablesWeight,
      double grainsWeight,
      double fruitsWeight,
      double seafoodWeight,
      double processedFoodsWeight) {
    final double emissionFactorHomemadeMeat = 3.0;
    final double emissionFactorBoughtMeat = 4.0;
    final double emissionFactorDairy = 2.5; // Emission factor for dairy
    final double emissionFactorVegetables =
        0.8; // Emission factor for vegetables
    final double emissionFactorGrains = 0.6; // Emission factor for grains
    final double emissionFactorFruits = 0.9; // Emission factor for fruits
    final double emissionFactorSeafood = 5.0; // Emission factor for seafood
    final double emissionFactorProcessedFoods =
        3.5; // Emission factor for processed foods

    double totalEmissions = 0;

    if (foodType == 'homemade') {
      totalEmissions += (meatWeight * emissionFactorHomemadeMeat);
    } else if (foodType == 'bought') {
      totalEmissions += (meatWeight * emissionFactorBoughtMeat);
    }

    totalEmissions += (dairyWeight * emissionFactorDairy);
    totalEmissions += (vegetablesWeight * emissionFactorVegetables);
    totalEmissions += (grainsWeight * emissionFactorGrains);
    totalEmissions += (fruitsWeight * emissionFactorFruits);
    totalEmissions += (seafoodWeight * emissionFactorSeafood);
    totalEmissions += (processedFoodsWeight * emissionFactorProcessedFoods);

    return totalEmissions;
  }

  double calculateElectricityEmissions(double consumption, String? source) {
    double emissionsFactor = 0.0; // Default value for no emissions

    // Define emission factors for different electricity sources
    final double emissionFactorCoal = 0.71; // kg CO2 per kWh for coal
    final double emissionFactorNaturalGas =
        0.71; // kg CO2 per kWh for natural gas

    if (source == 'coal') {
      emissionsFactor = emissionFactorCoal;
    } else if (source == 'natural_gas') {
      emissionsFactor = emissionFactorNaturalGas;
    }

    return consumption * emissionsFactor;
  }
}
