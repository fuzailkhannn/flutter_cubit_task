import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit_task/bloc/states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _firebaseAuth;

  LoginCubit(this._firebaseAuth) : super(LoginInitial());

  String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests. Try again later.";
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
      default:
        return errorCode.toString().toUpperCase();
    }
  }

  Future<void> logInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginError("Please fill in all fields"));
      return;
    }

    try {
      // Try signing in
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      log('User signed in: ${userCredential.user?.email}');
      emit(LoginSuccess("Login successful."));
    } on FirebaseAuthException catch (e) {
      // Handle specific error codes
      if (e.code == 'user-not-found') {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account not found. Creating new account.')),
          );
          UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User account created: ${userCredential.user?.email}')),
          );
          emit(LoginSuccess("Account created successfully."));
        } on FirebaseAuthException catch (e) {
          log('Failed to create account: ${e.message}');
          emit(LoginError(getMessageFromErrorCode(e.code)));
        }
      } else {
        log('Failed to sign in: ${e.message}');
        emit(LoginError(getMessageFromErrorCode(e.code)));
      }
    } catch (e) {
      log('Unexpected error: $e');
      emit(LoginError("Something went wrong. Please try again."));
    }
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
      log('User signed out successfully.');
    } catch (e) {
      log('Failed to sign out: $e');
      emit(LoginError("Failed to sign out. Please try again."));
    }
  }
}
