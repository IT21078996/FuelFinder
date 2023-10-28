import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart'; // Import Firebase Firestore

class GetUserDetails extends GetxController {
  final box = GetStorage();

  Stream<QuerySnapshot> getCartdetails() {
    Query query = FirebaseFirestore.instance.collection('users');
    query = query.where(
      'email',
      isEqualTo: box.read('email'),
    );
    debugPrint('email: ${query.toString()}');
    return query.snapshots();
  }

  void deletecart(
      id,
      Function(String) callback,
      ) {
    FirebaseFirestore.instance.collection('cart').doc(id).delete();
    callback('success');
  }
}
