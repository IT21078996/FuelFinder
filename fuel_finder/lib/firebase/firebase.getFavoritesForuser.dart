import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GetFavouritesController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();

  Stream<QuerySnapshot> getuserFav() {
    return FirebaseFirestore.instance
        .collection('feedback')
        .where("email", isEqualTo: box.read('email'))
        .snapshots();
  }

  Future<void> deleteFav(String id) async {
    await FirebaseFirestore.instance.collection('feedback').doc(id).delete();
  }
}
