import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isLoading = false;
  UserCredential? userCredential;

  Future<dynamic> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("UID >>>>>>>>>>> ${userCredential!.user!.uid}");
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("in provider ${e.message}");
      return e.message;
    }
  }

  Future<dynamic> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("UID >>>>>>>>>>> ${userCredential!.user!.uid}");
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint(e.message);
      return e.message;
    }
  }
}
