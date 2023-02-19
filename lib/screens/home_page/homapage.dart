import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'components/navigationdrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authInstance = FirebaseAuth.instance;

  final _firebaseFirestore = FirebaseFirestore.instance;

  var _username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future test() async {
    _username = await _firebaseFirestore
        .collection('users')
        .doc(_authInstance.currentUser!.uid)
        .get();
    return _username['username'];
    //print(f['username']);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    test();
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
                    _authInstance.signOut();
                  }
                }),
              ),
            ),
          )
        ],
      ),
      drawer: const NavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TODO image for user in home and profile?
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: FutureBuilder(
                  future: test(),
                  builder: (context, snapshot) {
                    return Text(
                      // " Hello, ${_username['username']} ",
                      'Hello, ${snapshot.data}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    );
                  }),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                color: Colors.blueAccent,
                child: const FittedBox(child: Text("test")),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                color: Colors.blueAccent,
                child: const FittedBox(child: Text("test")),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                color: Colors.blueAccent,
                child: const FittedBox(child: Text("test")),
              ),
            ),
          ],
        ),
      ),
      drawerEnableOpenDragGesture: true,
      bottomNavigationBar: BottomAppBar(
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            side: BorderSide(),
          ),
        ),
        notchMargin: 6,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {},
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: const Icon(Icons.mic),
      ),
    );
  }
}
