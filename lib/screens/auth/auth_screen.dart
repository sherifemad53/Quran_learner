import 'package:flutter/material.dart';
import '../../services/authentication.dart';

import 'widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key, required this.islogin}) : super(key: key);
  bool islogin;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  void _submitAuthForm(String userName, String userPassword, String userEmail,
      DateTime userBirthday, String userGender, bool isLogin) async {
    if (isLogin) {
      Authentication.login(userEmail, userPassword)
          .then((value) => Navigator.of(context).pop());
    } else {
      Authentication.createUser(userName, userName, userPassword, userEmail,
              userGender, userBirthday)
          .then((value) => Navigator.of(context).pop());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, widget.islogin),
    );
  }
}
