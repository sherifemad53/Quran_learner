import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../providers/settings_provider.dart';

class SurahViewSettingsScreen extends StatefulWidget {
  const SurahViewSettingsScreen({super.key});

  @override
  State<SurahViewSettingsScreen> createState() =>
      _SurahViewSettingsScreenState();
}

class _SurahViewSettingsScreenState extends State<SurahViewSettingsScreen> {
  SettingsProvider settingsProvider = SettingsProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Surah View Settings',
        style: Theme.of(context).textTheme.headlineMedium,
      )),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: const Text('English'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .updateTheme(value);
                  });
                },
                initialValue: false,
                leading: const Icon(Icons.format_paint),
                title: const Text('Enable custom theme'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
