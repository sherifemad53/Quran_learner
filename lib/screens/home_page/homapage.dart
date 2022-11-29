import 'package:flutter/material.dart';

import 'components/navigationdrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return Scaffold(
          appBar: AppBar(
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
        );
      },
    );
  }
}
