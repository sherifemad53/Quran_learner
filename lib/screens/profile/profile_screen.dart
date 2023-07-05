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
      body: Container(
        padding: const EdgeInsets.all(kdefualtPadding),
        margin: const EdgeInsets.all(kdefualtMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(
                          user.gender == 'male'
                              ? 'assets/icons/male_icon.png'
                              : 'assets/icons/female_icon.png',
                        ),
                        width: 90,
                      ),
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
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    title: Text(
                      'Introduction',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                      leading: const Icon(Icons.bug_report_outlined),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      title: Text(
                        'Bug Report',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () {}),
                  ListTile(
                      leading: const Icon(Icons.help_outline_outlined),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      title: Text(
                        'Help Guide',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () {}),
                  ListTile(
                      leading: const Icon(Icons.gavel),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      title: Text(
                        'Terms and Conditons',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () {}),
                  ListTile(
                      leading: const Icon(Icons.group),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      title: Text(
                        'About us',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () {}),
                ],
              ),
            ),
            ElevatedButton.icon(
              label: const Text('Logout'),
              icon: const Icon(Icons.logout),
              onPressed: () {
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () {
      Navigator.of(context).pop();
      Authentication.signOut();
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Confirmation"),
    content: const Text("Are you sure you wnat to logout"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
