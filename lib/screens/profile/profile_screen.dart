import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ElevatedButton.icon(
          label: const Text('Logout'),
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.of(context).pop();
            FirebaseAuth.instance.signOut();
          },
        ),
      ),
    );
  }
}
