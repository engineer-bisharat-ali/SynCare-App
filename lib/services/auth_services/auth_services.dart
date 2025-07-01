import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:syncare/provider/records_provider.dart';


class AuthServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ----------------------------
  // Signup Logic
  // ----------------------------

  Future<User?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Check if the user was created successfully
      await _firebaseFirestore.collection("users").doc(user!.uid).set({
        'name': name,
        'email': email,
        'uid': user.uid,
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during sign up.";
    }
  }

  // ----------------------------
  // Login Logic
  // ----------------------------

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during sign in.";
    }
  }

  // ----------------------------
  // Google Sign-In Logic
  // ----------------------------

  Future<User?> signInWithGoogle() async {
    try {
      // Step 1: Trigger Google Sign-In Flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in

      // Step 2: Obtain Auth Details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 3: Create Firebase Credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign into Firebase with Credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Step 5: Add User to Firestore (if new)
      if (user != null && userCredential.additionalUserInfo!.isNewUser) {
        await _firebaseFirestore.collection("users").doc(user.uid).set({
          'name': user.displayName ?? "No Name",
          'email': user.email,
          'uid': user.uid,
          'photoUrl': user.photoURL,
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Google Sign-In failed.";
    } catch (e) {
      throw "Error during Google Sign-In: $e";
    }
  }

  // ----------------------------
  // Forgot Password Logic
  // ----------------------------

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      // Do nothing, as Firebase does not return an error for unregistered emails
    }
  }

  // ----------------------------
  // Logout Logic
  // ----------------------------

  Future<void> logout(BuildContext context) async {
    try {
      final recordsProvider =
          Provider.of<RecordsProvider>(context, listen: false);
      await recordsProvider.closeBoxOnLogout();
      await _auth.signOut();
      await _googleSignIn.disconnect();
    } catch (e) {
      print("Error logging out: $e");
    }
  }
}
