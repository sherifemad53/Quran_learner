import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_leaner/common/constants.dart';

import '../../services/authentication.dart';
import '../../providers/user_provider.dart';
import '../../model/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(kdefualtPadding),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 25,
                    )),
                Center(
                  child: Text(
                    'Profile',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ],
            ),
            //Name
            Text(
              user.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            //Email
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            //edit profile button
            ElevatedButton(
              child: const Text('Edit Profile'),
              onPressed: () {},
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Text(
                'Terms and Conditons',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Text(
                'About us',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            ElevatedButton.icon(
              label: const Text('Logout'),
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.of(context).pop();
                Authentication.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
