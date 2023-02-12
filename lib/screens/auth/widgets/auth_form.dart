import 'package:flutter/material.dart';
import 'package:quran_leaner/screens/auth/components/form_validator.dart';

enum gender { male, female }

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitAuthForm, this.islogin, {super.key});

  final void Function(
          String userName, String userPassword, String userEmail, bool isLogin)
      submitAuthForm;

  final bool islogin;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  String _userName = '', _userPassword = '', _userEmail = '';
  gender? _gender;
  bool _isLogin = true;

  void _submit() {
    final isValid = _formkey.currentState!.validate();

    //To dismiss the keyboard on pressing the login button
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (isValid) {
      _formkey.currentState!.save();
      widget.submitAuthForm(
          _userName.trim(), _userPassword.trim(), _userEmail.trim(), _isLogin);
    }
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    _isLogin = widget.islogin;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Hero(
                tag: 'welcome_image',
                child: Image(
                  image: const AssetImage('assets/images/welcome_image.jpg'),
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
                        TextFormField(
                          key: const ValueKey("username"),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: "User Name",
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (newValue) {
                            _userName = newValue.toString();
                          },
                          validator: (value) =>
                              FormValidator.usernameValidator(value),
                        ),
                      const SizedBox(height: 15),
                      TextFormField(
                        key: const ValueKey("email"),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email Address",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (newValue) {
                          _userEmail = newValue.toString();
                        },
                        validator: (value) =>
                            FormValidator.emailValidator(value),
                      ), //emailtextfield
                      const SizedBox(height: 15),
                      TextFormField(
                        key: const ValueKey("password"),
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        onSaved: (newValue) {
                          _userPassword = newValue.toString();
                        },
                        validator: (value) =>
                            FormValidator.passwordValidator(value),
                      ), // passwordtestfield
                      const SizedBox(height: 10),
                      if (!_isLogin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Gender: ",
                            ),
                            Expanded(
                              child: RadioListTile<gender>(
                                contentPadding: const EdgeInsets.all(0),
                                value: gender.male,
                                dense: true,
                                groupValue: _gender,
                                onChanged: (value) {
                                  _gender = value;
                                  setState(() {});
                                },
                                title: const Text('Male'),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<gender>(
                                contentPadding: const EdgeInsets.all(0),
                                value: gender.female,
                                dense: true,
                                groupValue: _gender,
                                onChanged: (value) {
                                  _gender = value;
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
                            const Text('Birthday:'),
                            const SizedBox(
                              width: 20.0,
                            ),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: const Text('Select date'),
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
                    image: AssetImage(
                        'assets/icons/icons8-google-192(-xxxhdpi).png'),
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
