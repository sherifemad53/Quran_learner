import 'package:flutter/material.dart';

import '../../../common/constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          right: kdefualtRightPadding,
          left: kdefualtLeftPadding,
          top: kdefualtTopPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Image.asset(
              'assets/icons/nav_drawer_icon.png',
              width: 25,
            ),
          ),
        ],
      ),
    );
  }
}