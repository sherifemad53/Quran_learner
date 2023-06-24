import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/user_provider.dart';
import '/models/user_model.dart';
import '/app_routes.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    Size size = MediaQuery.of(context).size;

    return Drawer(
      width: size.width * 0.65,
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.only(bottom: 35, left: 20),
            decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20)),
                color: Color.fromARGB(255, 117, 179, 145)),
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
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
                ]),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text(
              'الايات المشابهة',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.ayatMotshbha);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: Text(
              'Recitation',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.recitation);
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text(
              'الاحاديث المشابهة',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.ahadithMotshbha);
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text(
              'Tajweed Correction',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.tajweedCorrection);
            },
          ),
        ]),
      ),
    );
  }
}
