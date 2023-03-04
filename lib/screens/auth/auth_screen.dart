import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/auth_form.dart';

//TODO: Sperate login from signup screen ??

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key, required this.islogin}) : super(key: key);
  bool islogin;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(String userName, String userPassword, String userEmail,
      DateTime userBirthday, String userGender, bool isLogin) async {
    User? userCredential;
    //TODO: more sign in options like google, facebook
    try {
      if (isLogin) {
        //TODO: handle login errors
        (await _auth
            .signInWithEmailAndPassword(
                email: userEmail, password: userPassword)
            .then((value) => Navigator.of(context).pop()));
        userCredential = _auth.currentUser;
        //print(userCredential!.uid);
      } else {
        //TODO: create account error handling
        //TODO: ADD GENDER, AGE AND NAME
        (await _auth
            .createUserWithEmailAndPassword(
                email: userEmail, password: userPassword)
            .then((value) => Navigator.of(context).pop()));
        userCredential = _auth.currentUser;
        final firebaseFirestore = FirebaseFirestore.instance;
        await firebaseFirestore
            .collection('users')
            .doc(userCredential!.uid)
            .set({
          'username': userName,
          'email': userEmail,
          'gender': userGender,
          'birthdate':
              '${userBirthday.month.toString()}/${userBirthday.year.toString()}'
        }).onError((error, stackTrace) => print("errorr:$error"));
      }
    } on FirebaseAuthException catch (err) {
      var errorMsg = "Error occured in auth";
      if (err.code == "user-not-found") {
        //TODO: handle all error types

        errorMsg = "user not found";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } on PlatformException catch (err) {
      var message = "An error occured please check your credentials";
      if (err.message != null) {
        message = err.message.toString();
        debugPrint(message);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, widget.islogin),
    );
  }
}
