import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/models/profile.dart';

class ProfileProvider with ChangeNotifier {
  Profile? _profile;
  bool _isLoading = false;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    // Wrap notifyListeners in a post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot doc = await firestore.collection("Users").doc(uid).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        _profile = Profile(
          firstName: data['First Name'] ?? 'No First Name',
          lastName: data['Last Name'] ?? 'No Last Name',
          phoneNumber: data['Phone Number'] ?? 'No Phone',
          email: data['Email'] ?? 'No Email',
          profileImage: data['ProfileImage'] != null ? File(data['ProfileImage']) : null,
        );
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print("Error getting document: $e");
    }

    _isLoading = false;
    // Wrap notifyListeners in a post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> updateProfile(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    File? profileImage,
  ) async {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    _profile = Profile(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      email: email,
      profileImage: profileImage ?? _profile?.profileImage,
    );

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String? profileImagePath;
      if (profileImage != null) {
        profileImagePath = profileImage.path;
      }

      await firestore.collection("Users").doc(uid).set({
        'First Name': firstName,
        'Last Name': lastName,
        'Phone Number': phoneNumber,
        'Email': email,
        'ProfileImage': profileImagePath,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating profile: $e");
    }

    _isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
