import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranic_tool_box/app_routes.dart';

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
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 102, 82),
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 25), //Theme.of(context).textTheme.headlineLarge,
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
                              user.name.toUpperCase(), //USER NAME DISPALY
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            elevation: 10,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            foregroundColor:
                                const Color.fromARGB(255, 0, 0, 0)),
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
                        leading:
                            const Icon(Icons.settings, color: Colors.black),
                        trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                elevation: 10,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0)),
                            child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.black),
                            onPressed: () {}),
                        title: Text(
                          'Settings',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.settings, color: Colors.black),
                        trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                elevation: 10,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0)),
                            child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.black),
                            onPressed: () {}),
                        title: Text(
                          'Settings',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.bookmark, color: Colors.black),
                        trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                elevation: 10,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0)),
                            child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.black),
                            onPressed: () {}),
                        title: Text(
                          'Terms & Conditons',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.info, color: Colors.black),
                        title: Text(
                          'About us',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                              elevation: 10,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
                              foregroundColor:
                                  const Color.fromARGB(255, 0, 0, 0)),
                          child: const Icon(Icons.arrow_forward_ios,
                              color: Colors.black),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(AppRoutes.aboutUs),
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      elevation: 10,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
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
