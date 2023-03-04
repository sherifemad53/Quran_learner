import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Authentication {
  static final _auth = FirebaseAuth.instance;

  static void createUser(String userName, String userPassword, String userEmail,
      DateTime userBirthday, String userGender, bool isLogin) async {
    User? userCredential;
    //TODO: more sign in options like google, facebook
    try {
      //TODO: create account error handling
      //TODO: ADD GENDER, AGE AND NAME
      // (await _auth
      //     .createUserWithEmailAndPassword(
      //         email: userEmail, password: userPassword)
      //     .then((value) => Navigator.of(context).pop()));
      userCredential = _auth.currentUser;
      final firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection('users').doc(userCredential!.uid).set({
        'username': userName,
        'email': userEmail,
        'gender': userGender,
        'birthdate':
            '${userBirthday.month.toString()}/${userBirthday.year.toString()}'
      }).onError((error, stackTrace) => print("errorr:$error"));
    } on FirebaseAuthException catch (err) {
      var errorMsg = "Error occured in auth";
      if (err.code == "user-not-found") {
        //TODO: handle all error types
        errorMsg = "user not found";
      }
    } on PlatformException catch (err) {
      var message = "An error occured please check your credentials";
      if (err.message != null) {
        message = err.message.toString();
        debugPrint(message);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  static void login(
    String userEmail,
    String userPassword,
  ) async {
    User? userCredential;
    //TODO: more sign in options like google, facebook
    try {
      //TODO: handle login errors
      // (await _auth
      //     .signInWithEmailAndPassword(email: userEmail, password: userPassword)
      //     .then((value) => Navigator.of(context).pop()));
      userCredential = _auth.currentUser;
      //print(userCredential!.uid);
      //TODO: create account error handling
      //TODO: ADD GENDER, AGE AND NAME
    } on FirebaseAuthException catch (err) {
      var errorMsg = "Error occured in auth";
      if (err.code == "user-not-found") {
        //TODO: handle all error types
        errorMsg = "user not found";
      }
    } on PlatformException catch (err) {
      var message = "An error occured please check your credentials";
      if (err.message != null) {
        message = err.message.toString();
        debugPrint(message);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
