import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/models/favorite.dart';

class FavoriteProvider with ChangeNotifier {
  bool _loading = false;
  bool get isLoading => _loading;
  List<Favorite> _favorites = [];

  List<Favorite> get favorites => _favorites;

  Future<void> fetchFavorites() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> doc = await firestore.collection("Users").doc(uid).get();
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('Favorites')) {
        _favorites = List.from(data['Favorites']).map<Favorite>((value) => Favorite.fromMap(value)).toList();
      }
    } catch (e) {
      print("Error getting document: $e");
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> saveToFavorites(Favorite favorite) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> doc = await firestore.collection("Users").doc(uid).get();
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('Favorites')) {
        _favorites = List.from(data['Favorites']).map<Favorite>((value) => Favorite.fromMap(value)).toList();
        _favorites.add(favorite);
        Map<String, List<Map<String, dynamic>>> updatedData = {
          'Favorites': _favorites.map((favorite) => favorite.toMap()).toList(),
        };
        await firestore.collection("Users").doc(uid).update(updatedData);
      } else {
        Map<String, List<Map<String, dynamic>>> updatedData = {
          'Favorites': [favorite.toMap()],
        };
        await firestore.collection("Users").doc(uid).set(updatedData, SetOptions(merge: true));
      }
    } catch (e) {
      print("Error getting document: $e");
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> removeFromFavorites(Favorite favorite) async {
    _loading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> doc = await firestore.collection("Users").doc(uid).get();
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('Favorites')) {
        _favorites = List.from(data['Favorites']).map<Favorite>((value) => Favorite.fromMap(value)).toList();
        _favorites.remove(favorite);
        Map<String, List<Map<String, dynamic>>> updatedData = {
          'Favorites': _favorites.map((favorite) => favorite.toMap()).toList(),
        };
        await firestore.collection("Users").doc(uid).update(updatedData);
      } else {
        print("Favorites not found");
      }
    } catch (e) {
      print("Error getting document: $e");
    }
    _loading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
