import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/navigationdrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                elevation: 0,
                items: [
                  DropdownMenuItem(
                    value: 'Settings',
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: const [
                          Icon(Icons.settings),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Settings")
                        ],
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'logout',
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: const [
                          Icon(Icons.exit_to_app),
                          SizedBox(
                            width: 5,
                          ),
                          Text("logout")
                        ],
                      ),
                    ),
                  )
                ],
                icon: const Icon(Icons.settings),
                onChanged: ((value) {
                  if (value == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                }),
              ),
            ),
          )
        ],
        title: const Text('Home'),
      ),
      drawer: const NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Home",
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
      drawerEnableOpenDragGesture: true,
    );
  }
}
