import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../providers/settings_provider.dart';
import '../../widgets/guide_container.dart';

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

  List<String> tabs = ['Recitaion', 'Memorization'];

  SettingsProvider? settingsProvider;
  int current = 0;
  Size? size;
  double? _currentSliderValue = 24;
  @override
  Widget build(BuildContext context) {
    settingsProvider = Provider.of<SettingsProvider>(context);
    _currentSliderValue =
        Provider.of<SettingsProvider>(context).getSurahViewFontSize;
    if (Provider.of<SettingsProvider>(context).getSurahViewMode ==
        'Recitation') {
      current = 0;
    } else {
      current = 1;
    }
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Surah View Settings',
        style: Theme.of(context).textTheme.headlineMedium,
      )),
      body: SettingsList(
        sections: [
          CustomSettingsSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Text(
                    "Mode Selection",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: size!.height * 0.10,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // padding: const EdgeInsets.all(),
                      itemCount: tabs.length,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          if (index == 0) {
                            settingsProvider!.updateSurahViewMode('Recitation');
                          } else {
                            settingsProvider!
                                .updateSurahViewMode('Memorization');
                          }
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.all(7),
                          padding: const EdgeInsets.all(7),
                          width: size!.width * 0.4,
                          height: size!.height * 0.1,
                          decoration: BoxDecoration(
                            color: current == index
                                ? Colors.white70
                                : Colors.white54,
                            borderRadius: current == index
                                ? BorderRadius.circular(15)
                                : BorderRadius.circular(10),
                            border: current == index
                                ? Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2)
                                : null,
                          ),
                          child: Center(
                            child: FittedBox(
                              child: Text(tabs[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SettingsSection(
            title: Text('Recitation section',
                style: Theme.of(context).textTheme.headlineMedium),
            tiles: [
              SettingsTile.switchTile(
                onToggle: (value) {
                  settingsProvider!.updateIsEnglishViewEnableed(value);
                  setState(() {
                    // _isEnglishTransEnabled = value;
                  });
                },
                initialValue: settingsProvider!.getIsEnglishTransEnabled,
                leading: const Icon(Icons.translate),
                title: const Text('Enable English Translation'),
              ),
            ],
          ),
          CustomSettingsSection(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "Surah View Font Size",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Slider(
                    value: _currentSliderValue!,
                    max: 42,
                    divisions: 9,
                    min: 24,
                    label: _currentSliderValue!.round().toString(),
                    onChanged: (double value) {
                      settingsProvider!.updateSurahViewFontSize(value);
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "Notes for Recitation mode",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Card(
                    child: Column(
                      children: const [
                        GuideContainer(
                          guideNo: 1,
                          title: "The Algorithm",
                          guideDescription:
                              "It tries tto get the most reasonable text alignment between both transcripted text and orignal text",
                        ),
                        GuideContainer(
                          title: "Explaination",
                          guideNo: 2,
                          guideDescription:
                              "The red dash means thet their is a mismatch while the yellow means there is a mis alignment (the charactor not in the place where it suppose to be)",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
