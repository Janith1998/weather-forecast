import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter/auth/controller/email_service.dart';
import 'package:gorouter/locator.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Future<void> logout() async {
  //   await auth.signOut();
  // }
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      // Clear the stored email
      getIt<EmailService>().clearEmail();

      // Navigate to login screen
      context.go('/login'); // or Navigator.pushReplacement()
    } catch (e) {
      log('Logout error: $e');
      // show a snackbar or dialog if needed
    }
  }

  Stream<User?> get authStateChanges => auth.authStateChanges();
}
