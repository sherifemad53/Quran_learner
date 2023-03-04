import 'package:flutter/material.dart';
import 'package:quran_leaner/screens/auth/components/form_validator.dart';

import 'form_text_field_widget.dart';

enum Gender { male, female }

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitAuthForm, this.islogin, {super.key});

  final void Function(String userName, String userPassword, String userEmail,
      DateTime userBirthday, String userGender, bool isLogin) submitAuthForm;

  final bool islogin;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  String _userName = '', _userPassword = '', _userEmail = '';
  Gender _userGender = Gender.male;
  bool _isLogin = true;
  DateTime _userBirthdayDate = DateTime.now();
  bool _isSelectedDate = false;

  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _userEmailTextEditingController =
      TextEditingController();
  final TextEditingController _userPasswordTextEditingController =
      TextEditingController();

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
      widget.submitAuthForm(
          _userNameTextEditingController.text.trim(),
          _userPasswordTextEditingController.text.trim(),
          _userEmailTextEditingController.text.trim(),
          _userBirthdayDate,
          ugender,
          _isLogin);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // setState(() {
    //   _isSelectedDate = false;
    // });
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
    _isLogin = widget.islogin;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Hero(
                tag: 'welcome_image',
                child: Image(
                  image: const AssetImage('assets/images/welcome_image.png'),
                  width: size.width,
                  height: size.height * 0.3,
                  alignment: Alignment.center,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    'Create an account to start learning',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!_isLogin) const SizedBox(height: 10),
                      if (!_isLogin)
                        FormTextField(
                            key: const ValueKey('username'),
                            labeltext: "User Name",
                            validator: FormValidator.usernameValidator,
                            textEditingController:
                                _userNameTextEditingController,
                            isObscuretext: false),
                      const SizedBox(height: 15),
                      FormTextField(
                          key: const ValueKey('email'),
                          labeltext: 'Email Address',
                          validator: FormValidator.emailValidator,
                          textEditingController:
                              _userEmailTextEditingController,
                          isObscuretext: false),
                      const SizedBox(height: 15),
                      FormTextField(
                          key: const ValueKey('password'),
                          labeltext: 'Password',
                          validator: FormValidator.passwordValidator,
                          textEditingController:
                              _userPasswordTextEditingController,
                          isObscuretext: true),
                      // passwordtestfield
                      const SizedBox(height: 10),
                      if (!_isLogin)
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
                      if (!_isLogin)
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
              SizedBox(
                width: size.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      foregroundColor: Colors.black),
                  onPressed: () {
                    _submit();
                  },
                  child: Text(_isLogin ? "Log in" : "Sign Up"),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              const Text(
                'OR',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              SizedBox(
                width: size.width * 0.9,
                child: OutlinedButton.icon(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      foregroundColor: Colors.black),
                  onPressed: () {
                    _submit();
                  },
                  label: const Text('Sign up with Google'),
                  icon: const Image(
                    image: AssetImage('assets/icons/google_icon.png'),
                    width: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
