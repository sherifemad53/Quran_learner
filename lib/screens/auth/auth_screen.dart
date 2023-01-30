import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(String userName, String userPassword, String userEmail,
      bool isLogin) async {
    User? userCredential;
    //todo more sign in options like google, facebook
    try {
      if (isLogin) {
        //todo handle login errors
        userCredential = (await _auth.signInWithEmailAndPassword(
                email: userEmail, password: userPassword))
            .user;
        //print(userCredential!.uid);
      } else {
        //todo create account error handling
        userCredential = (await _auth.createUserWithEmailAndPassword(
                email: userEmail, password: userPassword))
            .user;
        final firebaseFirestore = FirebaseFirestore.instance;
        await firebaseFirestore
            .collection('users')
            .doc(userCredential!.uid)
            .set({'username': userName, 'email': userEmail});
        //print(userCredential!.uid);
      }
    } on FirebaseAuthException catch (err) {
      var errorMsg = "Error occured in auth";
      if (err.code == "user-not-found") {
        //todo handle
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: AuthForm(_submitAuthForm),
    );
  }
}
