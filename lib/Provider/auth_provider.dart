import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Api Services/Services/authentication.dart';


class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthMethod _authMethod = AuthMethod();  // Use AuthMethod
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<String> loginUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    String result = await _authMethod.loginUser(email: email, password: password);

    if (result == "success") {
      _user = _auth.currentUser;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<String> signUpUser(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();
    String result = await _authMethod.signupUser(email: email, password: password, name: name);

    if (result == "success") {
      _user = _auth.currentUser;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
