import 'package:flutter/material.dart';
import 'package:quranic_tool_box/common/constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About Us'),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(kdefualtPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Brief',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "This is a graduation Project is submitted to Computer and Systems Engineering Department  Helwan university in Partial fulfillment of the requirements for bachelor's degree of Computer and Systems Engineering",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Text(
                        "By:",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const ContactCard(
                          name: 'Sherif Emad',
                          title: 'App development',
                          email: 'sherifemad53@gmail.com'),
                      const ContactCard(
                          name: 'Omar ElSayed',
                          title: 'Machine learing part',
                          email: 'OmarElSayed@gmail.com'),
                      const ContactCard(
                          name: 'Ali ElShimy',
                          title: 'App development',
                          email: 'alielshimy2000@gmail.com'),
                      const ContactCard(
                          name: 'Mohamed Ali ',
                          title: 'UI design',
                          email: 'mohamedali@gmail.com'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class ContactCard extends StatelessWidget {
  const ContactCard({
    required this.name,
    required this.title,
    required this.email,
    Key? key,
  }) : super(key: key);

  final String name;
  final String title;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            'Working on: $title',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Email: ',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SelectableText(
                email,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
