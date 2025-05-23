import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:quranic_tool_box/common/navigator_key.dart';
import 'authentication_error_handling.dart';
import '../models/user_model.dart' as model;

class Authentication {
  static final _auth = FirebaseAuth.instance;
  static final _firebaseFirestore = FirebaseFirestore.instance;
  static User? _userCredential;

  Future<model.User> getUserDetails() async {
    _userCredential = _auth.currentUser;
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('users')
        .doc(_userCredential!.uid)
        .get();
    return model.User.fromSpan(snap);
  }

  static Future<void> createUser(
    String name,
    String userName,
    String userEmail,
    String userPassword,
    String userGender,
    DateTime userBirthday,
  ) async {
    try {
      (await _auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword));

      _userCredential = _auth.currentUser;
      model.User user = model.User(
        uid: _userCredential!.uid,
        name: name,
        username: userName,
        email: userEmail,
        gender: userGender,
        birthdate: userBirthday,
      );

      await _firebaseFirestore
          .collection('users')
          .doc(_userCredential!.uid)
          .set(user.tojson());
    } on FirebaseAuthException catch (err) {
      var errorMsg = err.code;
      debugPrint(errorMsg);

      switch (err.code) {
        case "user-not-found":
          errorMsg = "User no found!";
          showError(errorMsg);
          debugPrint(errorMsg);
          break;
        case "email-already-in-use":
          errorMsg = "Email already in use!";
          showError(errorMsg);
          debugPrint(errorMsg);
          break;
        case "account-exists-with-different-credential":
          errorMsg = "Account already exists!";
          showError(errorMsg);
          debugPrint(errorMsg);
          break;
        case "network-request-failed":
          errorMsg = "No network connections!";
          showError(errorMsg);
          debugPrint(errorMsg);
          break;
        default:
          errorMsg = "Error occured in user creation, please try again!";
          showError(errorMsg);
          debugPrint(errorMsg);
          break;
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

  static Future<void> login(
    String userEmail,
    String userPassword,
  ) async {
    try {
      (await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword));
      _userCredential = _auth.currentUser;
      Navigator.of(navigatorKey.currentContext!).pop();
    } on FirebaseAuthException catch (err) {
      var errorMsg = "";
      switch (err.code) {
        case "user-not-found":
          errorMsg = "user not found";
          showError(errorMsg);
          debugPrint(errorMsg);
          break;
        case "wrong-password":
          errorMsg = "wrong password!";
          showError(errorMsg);
          debugPrint(errorMsg);
          break;
        default:
          errorMsg = "An error occured!";
          showError(errorMsg);
          debugPrint(errorMsg);
          break;
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

  static void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
