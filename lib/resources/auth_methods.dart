import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_confrence_app/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authChanges => _auth.authStateChanges();

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      // Initiate Google Sign-In process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if the user canceled the sign-in process
      if (googleUser == null) {
        return res; // User canceled sign-in, return false
      }

      // Retrieve authentication details from the Google account
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Check if googleAuth is null
      if (googleAuth == null) {
        showSnackBar(context, 'Google Authentication failed.');
        return res;
      }

      // Create Firebase OAuth credentials using Google authentication details
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the generated credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      // Check if user is new and store user information in Firestore
      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firestore.collection("users").doc(user.uid).set({
            "username": user.displayName,
            "uid": user.uid,
            "profilePhoto": user.photoURL,
          });
        }
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? "An error occurred during sign-in");
      res = false;
    }
    return res;
  }
}
