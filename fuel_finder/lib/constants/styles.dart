import 'package:fuel_finder/constants/colors.dart';
import 'package:flutter/material.dart';

const TextStyle greet = TextStyle(
  fontSize: 20,
  color: textBody,
  fontWeight: FontWeight.w400,
);
const TextStyle descStyle = TextStyle(
  fontSize: 16,
  color: textBody,
  fontWeight: FontWeight.w400,
);
const TextStyle descBStyle = TextStyle(
  fontSize: 24,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const txtInputDeco = InputDecoration(
  hintText: "Email",
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: secondary, width: 1),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primary, width: 1),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
);

const txtInputDeco2 = InputDecoration(
  labelText: '',
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
    borderSide: BorderSide(color: secondary, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
    borderSide: BorderSide(color: primary, width: 2),
  ),
);

const buttonBorderRadius = BorderRadius.all(Radius.circular(20.0));

const buttonDeco = BoxDecoration(
  borderRadius: buttonBorderRadius,
  gradient: LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
);

// import 'package:flutter/material.dart';
// import 'package:fuel_finder/screens/cfc_result.dart';

// class CFCForm extends StatefulWidget {
//   const CFCForm({Key? key}) : super(key: key);

//   @override
//   _CFCFormState createState() => _CFCFormState();
// }

// class _CFCFormState extends State<CFCForm> {
//   String? selectedVehicleType;
//   TextEditingController distanceController = TextEditingController();

//   bool homemadeFood = true;
//   String? selectedFoodType;
//   double meatWeight = 0;
//   double dairyWeight = 0;
//   double vegetablesWeight = 0;
//   double grainsWeight = 0;
//   double fruitsWeight = 0;
//   double seafoodWeight = 0;
//   double processedFoodsWeight = 0;

//   double electricityConsumption = 0;
//   String? selectedElectricitySource;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Carbon Calculator'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text('The Distance that you have traveled'),
//               TextField(
//                 controller: distanceController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: 'Distance (km)',
//                 ),
//               ),
//               DropdownButton<String>(
//                 value: selectedVehicleType,
//                 items: const [
//                   DropdownMenuItem<String>(
//                     value: 'car',
//                     child: Text('Car'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'bus',
//                     child: Text('Bus'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'train',
//                     child: Text('Train'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'bicycle',
//                     child: Text('Bicycle'),
//                   ),
//                 ],
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedVehicleType = value;
//                   });
//                 },
//                 hint: Text('Select Vehicle Type'),
//               ),
//               SizedBox(height: 16.0),
//               Text('Food Consumption'),
//               DropdownButton<String>(
//                 value: selectedFoodType,
//                 items: [
//                   DropdownMenuItem<String>(
//                     value: 'homemade',
//                     child: Text('Homemade Food'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'bought',
//                     child: Text('Bought Food'),
//                   ),
//                 ],
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedFoodType = value;
//                   });
//                 },
//                 hint: Text('Select Food Type'),
//               ),
//               Text('Meat Weight (kg)'),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   meatWeight = double.tryParse(value) ?? 0;
//                 },
//               ),
//               Text('Dairy Weight (kg)'),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   dairyWeight = double.tryParse(value) ?? 0;
//                 },
//               ),
//               Text('Vegetables Weight (kg)'),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   vegetablesWeight = double.tryParse(value) ?? 0;
//                 },
//               ),
//               Text('Grains Weight (kg)'),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   grainsWeight = double.tryParse(value) ?? 0;
//                 },
//               ),
//               Text('Fruits Weight (kg)'),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   fruitsWeight = double.tryParse(value) ?? 0;
//                 },
//               ),
//               Text('Seafood Weight (kg)'),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   seafoodWeight = double.tryParse(value) ?? 0;
//                 },
//               ),
//               Text('Processed Foods Weight (kg)'),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   processedFoodsWeight = double.tryParse(value) ?? 0;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               Text('Electricity Consumption (kWh)'),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   electricityConsumption = double.tryParse(value) ?? 0;
//                 },
//               ),
//               DropdownButton<String>(
//                 value: selectedElectricitySource,
//                 items: const [
//                   DropdownMenuItem<String>(
//                     value: 'coal',
//                     child: Text('Coal'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'natural_gas',
//                     child: Text('Natural Gas'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'renewables',
//                     child: Text('Renewables'),
//                   ),
//                 ],
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedElectricitySource = value;
//                   });
//                 },
//                 hint: Text('Select Electricity Source'),
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () {
//                   double distance =
//                       double.tryParse(distanceController.text) ?? 0;
//                   double transportationEmissions =
//                       calculateTransportationEmissions(
//                           distance, selectedVehicleType);

//                   double dietaryEmissions = calculateDietaryEmissions(
//                     homemadeFood,
//                     meatWeight,
//                     dairyWeight,
//                     vegetablesWeight,
//                     grainsWeight,
//                     fruitsWeight,
//                     seafoodWeight,
//                     processedFoodsWeight,
//                   );

//                   double electricityEmissions = calculateElectricityEmissions(
//                     electricityConsumption,
//                     selectedElectricitySource,
//                   );

//                   double carbonFootprint = transportationEmissions +
//                       dietaryEmissions +
//                       electricityEmissions;

//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CFCResult(
//                         carbonFootprint: carbonFootprint,
//                         travelEmissions: transportationEmissions,
//                         dietEmissions: dietaryEmissions,
//                         electricityEmissions: electricityEmissions,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text('Calculate'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   double calculateTransportationEmissions(
//       double distance, String? vehicleType) {
//     double emissionsFactor = 0.0; // Default value for no emissions

//     // Define emission factors for different vehicle types
//     final double emissionFactorCar = 2.28; // kg CO2 per km for gasoline
//     final double emissionFactorBusTrain = 2.74; // kg CO2 per km for diesel

//     if (vehicleType == 'car') {
//       emissionsFactor = emissionFactorCar;
//     } else if (vehicleType == 'bus' || vehicleType == 'train') {
//       emissionsFactor = emissionFactorBusTrain;
//     }

//     return distance * emissionsFactor;
//   }

//   double calculateDietaryEmissions(
//     bool homemadeFood,
//     double meatWeight,
//     double dairyWeight,
//     double vegetablesWeight,
//     double grainsWeight,
//     double fruitsWeight,
//     double seafoodWeight,
//     double processedFoodsWeight,
//   ) {
//     final double emissionFactorHomemadeMeat = 3.0;
//     final double emissionFactorBoughtMeat = 4.0;
//     final double emissionFactorDairy = 2.5; // Emission factor for dairy
//     final double emissionFactorVegetables =
//         0.8; // Emission factor for vegetables
//     final double emissionFactorGrains = 0.6; // Emission factor for grains
//     final double emissionFactorFruits = 0.9; // Emission factor for fruits
//     final double emissionFactorSeafood = 5.0; // Emission factor for seafood
//     final double emissionFactorProcessedFoods =
//         3.5; // Emission factor for processed foods

//     double totalEmissions = 0;

//     if (selectedFoodType == 'homemade') {
//       totalEmissions += (meatWeight * emissionFactorHomemadeMeat);
//     } else if (selectedFoodType == 'bought') {
//       totalEmissions += (meatWeight * emissionFactorBoughtMeat);
//     }

//     totalEmissions += (dairyWeight * emissionFactorDairy);
//     totalEmissions += (vegetablesWeight * emissionFactorVegetables);
//     totalEmissions += (grainsWeight * emissionFactorGrains);
//     totalEmissions += (fruitsWeight * emissionFactorFruits);
//     totalEmissions += (seafoodWeight * emissionFactorSeafood);
//     totalEmissions += (processedFoodsWeight * emissionFactorProcessedFoods);

//     return totalEmissions;
//   }

//   double calculateElectricityEmissions(
//     double consumption,
//     String? source,
//   ) {
//     double emissionsFactor = 0.0; // Default value for no emissions

//     // Define emission factors for different electricity sources
//     final double emissionFactorCoal = 0.71; // kg CO2 per kWh for coal
//     final double emissionFactorNaturalGas =
//         0.71; // kg CO2 per kWh for natural gas

//     if (source == 'coal') {
//       emissionsFactor = emissionFactorCoal;
//     } else if (source == 'natural_gas') {
//       emissionsFactor = emissionFactorNaturalGas;
//     }

//     return consumption * emissionsFactor;
//   }
// }
