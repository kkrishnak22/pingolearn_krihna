import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  // SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );


        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
        });

        res = "success";
      } else {
        res = "Please fill all the fields";
      }
    } on FirebaseAuthException catch (err) {
      print("---------------------");
      print(err.code);
      print(err);
      if (err.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (err.code == 'email-already-in-use') {
        res = 'The email address is already in use by another account.';
      } else {
        res = err.message!;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // LogIn User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      print("lhooooooooooooooooo");

      //print(err.toString());
      if (email.isNotEmpty && password.isNotEmpty) {
        // Logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (err) {
      print("---------------------");
      print(err.code);
      print(err);
      if (err.code == 'invalid-credential') {
        res = 'Incorrect email / password.';
      } else {
        res = err.message!;
      }
    } catch (err) {

      print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
      print(err);
      res = err.toString();
    }
    return res;
  }

  // SignOut User
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
