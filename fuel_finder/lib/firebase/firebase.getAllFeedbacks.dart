import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class getcartController extends GetxController {
  var isLoading = false.obs;
  var filteredFeedbacks = [].obs;
  var feedbackList = [].obs;

  Stream<QuerySnapshot> getAllFeedbacks(String searchText) {
    Query query = FirebaseFirestore.instance.collection('feedback');
    if (searchText.isNotEmpty) {
      // Filter by any letter in 'fuelstation'
      query = query
          .where('fuelstation', isGreaterThanOrEqualTo: searchText)
          .where('fuelstation', isLessThan: searchText + 'z');
    }

    return query.snapshots();
  }

  void filterFeedbacks(String searchText) {
    if (searchText.isEmpty) {
      filteredFeedbacks.value = feedbackList;
      return;
    }

    final allFeedbacks = feedbackList;
    final filtered = allFeedbacks
        .where((feedback) => feedback['fuelstation']
        .toLowerCase()
        .contains(searchText.toLowerCase()))
        .toList();
    filteredFeedbacks.value = filtered;
  }
}
