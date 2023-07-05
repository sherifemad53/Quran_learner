import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranic_tool_box/screens/ayat_ahadith_semantic_search/ayat_ahadith_semantic_search.dart';

import '../../models/surah_model.dart';
import '../../models/juz_model.dart';
import '../../models/user_model.dart';

import '../../providers/quran_provider.dart';
import '../../providers/user_provider.dart';

import '../../app_routes.dart';
import '../../common/constants.dart';

import 'widgets/custom_nav_drawer.dart';
import 'widgets/custom_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  bool _isloading = true;
  //Providers the surahs,juzs
  QuranProvider quranProvider = QuranProvider();

  List<SurahModel> surahs = [];
  List<JuzModel> juzs = [];

  @override
  void initState() {
    super.initState();
    //when the init function finishes it sets the isloading to false
    init().whenComplete(() => setState(() {
          _isloading = false;
        }));
  }

  Future<void> init() async {
    //GET USER DATA
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();

    //GET SURAH MODEL DATA
    await quranProvider.init();
    surahs = quranProvider.getSurahModel();
    juzs = quranProvider.getJuzModel();

    //Simple delay to illustrate loading
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void searchSurah(String a) async {
    surahs = quranProvider.getSearchedSurahModel(a);
  }

  Size? size;
  double? appbarheight;
  double? nameBarHeight;
  double? searchBarHeight;

  double? surahNamesCardHeight;
  double? bottomNavBarHeight;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    appbarheight = size!.height * 0.06;
    nameBarHeight = size!.height * 0.10;
    searchBarHeight = size!.height * 0.09;
    surahNamesCardHeight = size!.height * 0.05;
    bottomNavBarHeight = size!.height * 0.05;
    if (!_isloading) user = Provider.of<UserProvider>(context).getUser;
    return _isloading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          )
        : Scaffold(
            drawer: const CustomNavigationDrawer(),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: appbarheight, child: const CustomAppBar()),
                  Container(
                    height: nameBarHeight,
                    padding:
                        const EdgeInsets.symmetric(horizontal: kdefualtPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello,',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              user!.name.toUpperCase(),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.profile);
                          },
                          icon: Image.asset(
                            user!.gender == 'male'
                                ? 'assets/icons/male_icon.png'
                                : 'assets/icons/female_icon.png',
                            width: 45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: searchBarHeight,
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
                    height: size!.height * 0.63,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Card(
                      elevation: 3,
                      child: ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(surahs[index].id.toString()),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    textAlign: TextAlign.right,
                                    "سورة ${surahs[index].surahNameArabic}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                              onTap: () => Navigator.of(context)
                                  .pushNamed(AppRoutes.surahView, arguments: {
                                'SurahNameArabic':
                                    surahs[index].surahNameArabic,
                                'SurahNo': surahs[index].id.toString(),
                              }),
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
            resizeToAvoidBottomInset: false,
            drawerEnableOpenDragGesture: true,
            bottomNavigationBar: SizedBox(
              height: size!.height * 0.05,
              child: BottomAppBar(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(icon: const Icon(Icons.home), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
                    IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  const AyaAhdithSemanticSearchScreen()));
                        }),
                  ],
                ),
              ),
            ),
          );
  }
}
