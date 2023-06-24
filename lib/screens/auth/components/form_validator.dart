class FormValidator {
  // const Alerts alert;

  static String? nameValidator(String? str) {
    if (str!.isEmpty || str.length < 4) {
      return 'Enter correct name';
    }
    return null;
  }

  static String? usernameValidator(String? str) {
    if (str!.isEmpty || str.length < 4) {
      return 'Enter correct name';
    }
    return null;
  }

  static String? emailValidator(String? str) {
    if (str!.isEmpty || !(str.contains('@'))) {
      return 'Enter correct email';
    }
    return null;
  }

  static String? passwordValidator(String? str) {
    if (str!.isEmpty || (str.length < 4)) {
      return 'Enter correct password';
    }
    return null;
  }
}
