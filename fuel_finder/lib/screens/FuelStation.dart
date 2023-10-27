class FuelStation {
  final String location;
  final String sName;
  final bool evChargersAvailable;
  final Map<String, String> fuelTypeQuantityMap;
  final double latitude;
  final double longitude;
  final String noofpumps;
  final String status;

  FuelStation({
    required this.location,
    required this.sName,
    required this.evChargersAvailable,
    required this.fuelTypeQuantityMap,
    required this.latitude,
    required this.longitude,
    required this.noofpumps,
    required this.status,
  });
}
