import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class UpdateProfile extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();

  Future<void> updateUserData(
      String profilePicture,
      String firstName,
      String lastName,
      String phone,
      String newEmail,
      String newPassword,
      Function(String) callback,
      ) async {
    try {
      final String userId = box.read('docId');
      final FirebaseAuth auth = FirebaseAuth.instance;

      final Map<String, dynamic> updateData = {};

      if (profilePicture.isNotEmpty) {
        updateData['profilePicture'] = profilePicture;
      }
      if (firstName.isNotEmpty) {
        updateData['firstname'] = firstName;
      }
      if (lastName.isNotEmpty) {
        updateData['lastname'] = lastName;
      }
      if (phone.isNotEmpty) {
        updateData['phone'] = phone;
      }

      final User? user = auth.currentUser;
      if (user != null) {
        if (newPassword.isNotEmpty) {
          await user.updatePassword(newPassword);
        }

        if (newEmail.isNotEmpty && newEmail != user.email) {
          await user.sendEmailVerification();
        }
      }

      if (newEmail.isNotEmpty) {
        updateData['email'] = newEmail;
      }

      final DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(userId);
      await userRef.update(updateData);

      return callback('success');
    } catch (e) {
      debugPrint('Error updating user data: $e');
      return callback('error');
    }
  }
}
