import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranic_tool_box/models/surah_model.dart';
import 'package:quranic_tool_box/providers/quran_provider.dart';

import '/app_routes.dart';
import '/common/constants.dart';
import '/providers/user_provider.dart';

import 'widgets/custom_nav_drawer.dart';
import 'widgets/custom_appbar.dart';
import '/data/quran_list.dart';
import '../../models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> searchablequranlist = quranList;
  User? user;
  bool _isloading = true;
  QuranProvider quranProvider = QuranProvider();

  List<SurahModel> surahs = [];

  void searchSurah(String a) async {
    surahs = quranProvider.getSearchedSurahModel(a);
  }

  @override
  void initState() {
    super.initState();
    init().whenComplete(() => {
          setState(() {
            _isloading = false;
          })
        });
  }

  Future<void> init() async {
    //GET USER DATA
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();

    //GET SURAH MODEL DATA
    await quranProvider.init();
    surahs = quranProvider.getSurahModel();

    await Future.delayed(const Duration(milliseconds: 200));
  }

  Size? size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    Provider.of<ConnectivityResult>(context) == ConnectivityResult.wifi ||
            Provider.of<ConnectivityResult>(context) ==
                ConnectivityResult.mobile
        ? print('hello')
        : print('world');

    // Provider.of<SettingsProvider>(context).setTheme(false);

    if (!_isloading) user = Provider.of<UserProvider>(context).getUser;
    return _isloading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          )
        : Scaffold(
            drawer: const CustomNavigationDrawer(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(),
                    Container(
                      margin: const EdgeInsets.all(kdefualtMargin),
                      padding: const EdgeInsets.only(left: kdefualtLeftPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello,',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                user!.name.toUpperCase(),
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.profile);
                            },
                            icon: Image.asset(
                              'assets/icons/male_profile_icon.png',
                              width: 45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: kdefualtHorizontalMargin,
                          vertical: kdefualtVerticalMargin),
                      padding: const EdgeInsets.symmetric(
                          horizontal: kdefualtHorizontalPadding),
                      child: TextField(
                        textDirection: TextDirection.rtl,
                        onChanged: (value) => setState(() {
                          searchSurah(value);
                        }),
                        decoration: const InputDecoration(
                            hintTextDirection: TextDirection.ltr,
                            hintText: "Enter Surah Name",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                    ),
                    Container(
                      height: size!.height * 0.6,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        elevation: 3,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              enableFeedback: true,
                              canRequestFocus: true,
                              key: ValueKey(index),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.surahView, arguments: {
                                  'SurahNameArabic':
                                      surahs[index].surahNameArabic,
                                  'SurahNo': surahs[index].id.toString(),
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(surahs[index].id.toString()),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.right,
                                        "سورة ${surahs[index].surahNameArabic}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            surahs[index].surahNameEnglish!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          Text(
                                            '${surahs[index].totalVerses} verses',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: surahs.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            drawerEnableOpenDragGesture: true,
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: const Icon(Icons.home),
                      onPressed: () async {
                        //
                      }),
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                  IconButton(
                      icon: const Icon(Icons.read_more), onPressed: () {}),
                ],
              ),
            ),
          );
  }
}
