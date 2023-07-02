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

class _SurahViewSettingsScreenState extends State<SurahViewSettingsScreen>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  bool _isEnglishTransEnabled = false;

  SettingsProvider? settingsProvider;
  @override
  Widget build(BuildContext context) {
    settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Surah View Settings',
        style: Theme.of(context).textTheme.headlineMedium,
      )),
      body: SettingsList(
        sections: [
          CustomSettingsSection(
            child: TabBar(
                onTap: (value) {
                  if (value == 0) {
                    settingsProvider!.updateSurahViewMode('Recitation');
                  } else if (value == 1) {
                    settingsProvider!.updateSurahViewMode('Memorization');
                  }
                },
                controller: tabController,
                padding: const EdgeInsets.all(5),
                labelPadding: const EdgeInsets.all(5),
                tabs: const [
                  Text('Recitation'),
                  Text('Memorization'),
                ]),
          ),
          SettingsSection(
            title: const Text('Recitation section'),
            tiles: [
              SettingsTile.switchTile(
                onToggle: (value) {
                  settingsProvider!.updateIsEnglishViewEnableed(value);
                  setState(() {
                    _isEnglishTransEnabled = value;
                  });
                },
                initialValue: settingsProvider!.getIsEnglishTransEnabled,
                leading: const Icon(Icons.format_paint),
                title: const Text('Enable English Translation'),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Recitation section'),
            tiles: [
              SettingsTile.switchTile(
                  initialValue: false,
                  onToggle: (value) {},
                  title: const Text('Enable custom theme'))
            ],
          )
        ],
      ),
    );
  }
}
