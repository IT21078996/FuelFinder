import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddFeedback extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();

  AddFeedback() {
    // Initialize GetStorage if not done already
    GetStorage.init();
  }

  Future<void> addFeedback(
      String fuelstation,
      String name,
      double rate,
      String comment,
      Function(String) callback,
      ) async {
    isLoading(true);

    try {
      // Add a document to the 'feedback' collection
      final feedbackRef = FirebaseFirestore.instance.collection('feedback');
      final userUid = box.read('docId');
      final email = box.read('email');
      final profilePicture = box.read('profilePicture');

      final feedbackData = {
        'fuelstation': fuelstation,
        'email': email,
        'image': profilePicture,
        'name': name,
        'rating': rate,
        'comment': comment,
        "points": 100,
        'dateCreated': DateTime.now(),
      };

      final feedbackDoc = await feedbackRef.add(feedbackData);

      // Update user points
      final usersRef = FirebaseFirestore.instance.collection('users');
      await usersRef.doc(userUid).update({
        'points': FieldValue.increment(100),
      });

      callback('success');
    } catch (e) {
      print('Error adding feedback: $e');
      callback('error');
    } finally {
      isLoading(false);
    }
  }
}
