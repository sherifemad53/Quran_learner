import 'package:flutter/material.dart';
import 'package:quranic_tool_box/navigator_key.dart';

void showError(String errorMessage) {
  showDialog(
    useRootNavigator: false,
    context: navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(errorMessage),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"))
        ],
      );
    },
  );
}
