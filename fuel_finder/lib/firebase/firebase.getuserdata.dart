import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class getUserInformations extends GetxController {
  var isloading = true;
  final box = GetStorage();
  Stream<QuerySnapshot> getuserdata() {
    Query query = FirebaseFirestore.instance.collection('user');

    return query.snapshots();
  }
}