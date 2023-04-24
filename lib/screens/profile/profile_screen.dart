import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/services/authentication.dart';
import '/providers/user_provider.dart';
import '/models/user_model.dart';
import '/common/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(kdefualtPadding),
            margin: const EdgeInsets.all(kdefualtMargin),
            child: Column(
              children: [
                //Name
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(
                              user.name.toUpperCase(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            //Email
                            Text(
                              user.email,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      //edit profile button
                      ElevatedButton(
                        child: const Text('Edit Profile'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                    ],
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
        ],
      ),
    );
  }
}
