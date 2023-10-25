import 'package:flutter/material.dart';
import 'package:fuel_finder/screens/cfc_result.dart';

class CFCForm extends StatefulWidget {
  const CFCForm({Key? key}) : super(key: key);

  @override
  _CFCFormState createState() => _CFCFormState();
}

class _CFCFormState extends State<CFCForm> {
  int currentStep = 0; // Track the current step
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

  // Define the steps for the Stepper
  List<Step> steps = [];

  @override
  void initState() {
    super.initState();

    // Define the steps for the Stepper
    steps = [
      Step(
        title: Text('Travel Data'),
        content: Column(
          children: [
            Text('The Distance that you have traveled'),
            TextField(
              controller: distanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Distance (km)',
              ),
            ),
            DropdownButton<String>(
              value: selectedVehicleType,
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
              hint: Text('Select Vehicle Type'),
            ),
          ],
        ),
        isActive: currentStep == 0, // Mark as active step
      ),
      Step(
        title: Text('Food Consumption Data'),
        content: Column(
          children: [
            DropdownButton<String>(
              value: selectedFoodType,
              items: [
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
              hint: Text('Select Food Type'),
            ),
            Text('Meat Weight (kg)'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                meatWeight = double.tryParse(value) ?? 0;
              },
            ),
            Text('Dairy Weight (kg)'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                dairyWeight = double.tryParse(value) ?? 0;
              },
            ),
            Text('Vegetables Weight (kg)'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                vegetablesWeight = double.tryParse(value) ?? 0;
              },
            ),
            Text('Grains Weight (kg)'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                grainsWeight = double.tryParse(value) ?? 0;
              },
            ),
            Text('Fruits Weight (kg)'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                fruitsWeight = double.tryParse(value) ?? 0;
              },
            ),
            Text('Seafood Weight (kg)'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                seafoodWeight = double.tryParse(value) ?? 0;
              },
            ),
            Text('Processed Foods Weight (kg)'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                processedFoodsWeight = double.tryParse(value) ?? 0;
              },
            ),
          ],
        ),
        isActive: currentStep == 1, // Mark as active step
      ),
      Step(
        title: Text('Electricity Consumption Data'),
        content: Column(
          children: [
            Text('Electricity Consumption (kWh)'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                electricityConsumption = double.tryParse(value) ?? 0;
              },
            ),
            DropdownButton<String>(
              value: selectedElectricitySource,
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
              hint: Text('Select Electricity Source'),
            ),
          ],
        ),
        isActive: currentStep == 2, // Mark as active step
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Carbon Calculator'),
        ),
        body: Stepper(
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
