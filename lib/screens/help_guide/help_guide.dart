import 'package:flutter/material.dart';

import '../../widgets/guide_container.dart';

import 'custom_image.dart';
import 'custom_title.dart';
import 'app_version.dart';

class HelpGuide extends StatelessWidget {
  const HelpGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // App.init(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomImage(
              imagePath: "assets/images/welcome_image.png",
              opacity: 0.5,
              height: MediaQuery.of(context).size.height * 0.18,
            ),
            // const AppBackButton(),
            const CustomTitle(title: "Help Guide"),
            const Guidelines(),
            const AppVersion(),
          ],
        ),
      ),
    );
  }
}

class Guidelines extends StatelessWidget {
  const Guidelines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: EdgeInsets.fromLTRB(0, height * 0.2, 0, height * 0.1),
      child: ListView(
        children: const <Widget>[
          GuideContainer(
            guideNo: 1,
            title: "Internet Connectivity",
            guideDescription:
                "The application is available in Offline Mode. However, you will need internet connection for the memoriztion and search feature",
          ),
          GuideContainer(
            title: "Home page",
            guideNo: 2,
            guideDescription:
                "Contains the profile button,name and list of surahs and searchbar to search surah by name",
          ),
          GuideContainer(
            guideNo: 3,
            title: "Introduction Tab",
            guideDescription:
                "It will re-open the introduction of app that you might have seen when opened the app for the first time",
          ),
          GuideContainer(
            guideNo: 4,
            title: "Report Bugs",
            guideDescription:
                "Go to the report bugs screen to send us an email expling the bug",
          ),
          GuideContainer(
            guideNo: 5,
            title: "Rate & Feedback",
            guideDescription:
                "You can give your precious feedback by contacting one of us from about us screen",
          ),
        ],
      ),
    );
  }
}

