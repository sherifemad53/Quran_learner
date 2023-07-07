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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              ContactCard(
                  name: 'Sherif Emad',
                  title: 'App development',
                  email: 'sherifemad53@gmail.com'),
              ContactCard(
                  name: 'Sherif Emad',
                  title: 'App development',
                  email: 'sherifemad53@gmail.com'),
              ContactCard(
                  name: 'Sherif Emad',
                  title: 'App development',
                  email: 'sherifemad53@gmail.com'),
              ContactCard(
                  name: 'Sherif Emad',
                  title: 'App development',
                  email: 'sherifemad53@gmail.com'),
            ],
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
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            'Worded on: $title',
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
