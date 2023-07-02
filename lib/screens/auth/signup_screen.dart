import 'package:flutter/material.dart';

import '../../services/authentication.dart';
import 'components/form_validator.dart';
import 'widgets/form_text_field_widget.dart';
import 'widgets/custom_elevated_button.dart';
import 'widgets/welcome_title.dart';

enum Gender { male, female }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formkey = GlobalKey<FormState>();
  // String _userName = '', _userPassword = '', _userEmail = '';
  Gender _userGender = Gender.male;
  DateTime _userBirthdayDate = DateTime.now();
  bool _isSelectedDate = false;

  final TextEditingController _nameTextEditingController =
      TextEditingController();

  final TextEditingController _userNameTextEditingController =
      TextEditingController();

  final TextEditingController _userEmailTextEditingController =
      TextEditingController();

  final TextEditingController _userPasswordTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _userNameTextEditingController.dispose();
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
    String ugender;
    if (_userGender == Gender.male) {
      ugender = 'male';
    } else {
      ugender = 'female';
    }
    if (isValid) {
      _formkey.currentState!.save();

      Authentication.createUser(
              _nameTextEditingController.text.trim(),
              _userNameTextEditingController.text.trim(),
              _userEmailTextEditingController.text.trim(),
              _userPasswordTextEditingController.text.trim(),
              ugender,
              _userBirthdayDate)
          .then((value) => Navigator.of(context).pop());
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _userBirthdayDate,
        firstDate: DateTime(1920, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != _userBirthdayDate) {
      setState(() {
        _isSelectedDate = true;
        _userBirthdayDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const WelcomeTitle(),
              Container(
                //padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FormTextField(
                          key: const ValueKey('name'),
                          labeltext: "Name",
                          validator: FormValidator.nameValidator,
                          textEditingController: _nameTextEditingController,
                          isObscuretext: false),
                      FormTextField(
                          key: const ValueKey('username'),
                          labeltext: "User Name",
                          validator: FormValidator.usernameValidator,
                          textEditingController: _userNameTextEditingController,
                          isObscuretext: false),
                      FormTextField(
                          key: const ValueKey('email'),
                          labeltext: 'Email Address',
                          validator: FormValidator.emailValidator,
                          textEditingController:
                              _userEmailTextEditingController,
                          isObscuretext: false),
                      FormTextField(
                          key: const ValueKey('password'),
                          labeltext: 'Password',
                          validator: FormValidator.passwordValidator,
                          textEditingController:
                              _userPasswordTextEditingController,
                          isObscuretext: true),
                      // passwordtestfield
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Gender: ",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Expanded(
                            child: RadioListTile<Gender>(
                              contentPadding: const EdgeInsets.all(0),
                              value: Gender.male,
                              groupValue: _userGender,
                              onChanged: (value) {
                                _userGender = value as Gender;
                                setState(() {});
                              },
                              title: const Text('Male'),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<Gender>(
                              contentPadding: const EdgeInsets.all(0),
                              value: Gender.female,
                              groupValue: _userGender,
                              onChanged: (value) {
                                _userGender = value as Gender;
                                setState(() {});
                              },
                              title: const Text('Female'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Birthday:',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                elevation: 1),
                            onPressed: () => _selectDate(context),
                            child: _isSelectedDate
                                ? Text(
                                    '${_userBirthdayDate.month.toString()}/${_userBirthdayDate.year.toString()}')
                                : const Text('Select date'),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              CustomElevatedButton(
                label: "Sign Up",
                size: size,
                submit: _submit,
              ),
              // const SizedBox(
              //   height: 7,
              // ),
              // const Text(
              //   'OR',
              //   style: TextStyle(
              //     fontSize: 25,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 7),
              // SignupWithGoogleButton(
              //   size: size,
              //   submit: _submit,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
