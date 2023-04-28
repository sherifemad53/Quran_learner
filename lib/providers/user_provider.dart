import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/authentication.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final Authentication _authentication = Authentication();
  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authentication.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
