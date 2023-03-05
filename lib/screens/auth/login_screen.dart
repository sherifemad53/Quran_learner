import 'package:flutter/material.dart';

import '../../services/authentication.dart';
import 'components/form_validator.dart';
import 'widgets/custom_elevated_button.dart';
import 'widgets/form_text_field_widget.dart';
import 'widgets/signup_with_google_button.dart';
import 'widgets/welcome_image.dart';
import 'widgets/welcome_title.dart';

enum Gender { male, female }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _userEmailTextEditingController =
      TextEditingController();

  final TextEditingController _userPasswordTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _userEmailTextEditingController.dispose();
    _userPasswordTextEditingController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formkey.currentState!.validate();
    //To dismiss the keyboard on pressing the login button
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (isValid) {
      _formkey.currentState!.save();
      Authentication.login(
        _userEmailTextEditingController.text.trim(),
        _userPasswordTextEditingController.text.trim(),
      ).then((value) => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          WelcomeImage(size: size),
          const WelcomeTitle(),
          Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 15),
                FormTextField(
                    key: const ValueKey('email'),
                    labeltext: 'Email Address',
                    validator: FormValidator.emailValidator,
                    textEditingController: _userEmailTextEditingController,
                    isObscuretext: false),
                const SizedBox(height: 15),
                FormTextField(
                    key: const ValueKey('password'),
                    labeltext: 'Password',
                    validator: FormValidator.passwordValidator,
                    textEditingController: _userPasswordTextEditingController,
                    isObscuretext: true),
                // passwordtestfield
                const SizedBox(height: 10),
                 CustomElevatedButton(
                label: "Login",
                size: size,
                submit: _submit,
              ),
                const SizedBox(height: 7),
                const Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                SignupWithGoogleButton(
                  size: size,
                  submit: _submit,
                ),
              ],
            ),
          )
        ],
      ),
    )));
  }
}
