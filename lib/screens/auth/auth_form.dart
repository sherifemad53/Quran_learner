import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitAuthForm, {super.key});

  final void Function(
          String userName, String userPassword, String userEmail, bool isLogin)
      submitAuthForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  String _userName = '', _userPassword = '', _userEmail = '';
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey("username"),
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: "Username",
                      ),
                      onSaved: (newValue) {
                        _userName = newValue.toString();
                      },
                      validator: (value) {
                        if (value!.isEmpty || (value.length < 4)) {
                          return 'Enter correct username';
                        }
                        return null;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                    ),
                    onSaved: (newValue) {
                      _userEmail = newValue.toString();
                    },
                    validator: (value) {
                      if (value!.isEmpty || !(value.contains('@'))) {
                        return 'Enter correct email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey("password"),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                    onSaved: (newValue) {
                      _userPassword = newValue.toString();
                    },
                    validator: (value) {
                      if (value!.isEmpty || (value.length < 4)) {
                        return 'Enter correct password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Text(_isLogin ? "Log in" : "Sign Up"),
                  ),
                  TextButton(
                      onPressed: () {
                        _isLogin = !_isLogin;
                        setState(() {});
                      },
                      child: Text(_isLogin
                          ? "Create new account"
                          : "Already have account")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
