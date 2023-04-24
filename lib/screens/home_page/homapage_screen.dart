import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '/app_routes.dart';
import '/common/constants.dart';
import '/providers/user_provider.dart';

import '../profile/profile_screen.dart';
import 'widgets/custom_nav_drawer.dart';
import '/data/quran_list.dart';
import 'widgets/custom_appbar.dart';
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

  @override
  void initState() {
    getdata().whenComplete(() => {
          setState(() {
            _isloading = false;
          })
        });
    super.initState();
  }

  Future<void> getdata() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void searchSurahName(String query) {
    final suggestations = quranList.where((element) {
      final surahName = element['SurahNameArabic'] as String;
      return (surahName).contains(query);
    }).toList();
    setState(() {
      searchablequranlist = suggestations;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                  .push(MaterialPageRoute(builder: (_) {
                                return const ProfileScreen();
                              }));
                            },
                            icon: Image.asset(
                              'assets/icons/male_profile_icon.png',
                              width: 45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: kdefualtHorizontalMargin,
                            vertical: kdefualtVerticalMargin),
                        padding: const EdgeInsets.symmetric(
                            horizontal: kdefualtHorizontalPadding),
                        child: TextField(
                          onChanged: (value) => searchSurahName(value),
                          decoration: const InputDecoration(
                              hintText: "Enter Surah Name",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                'SurahNameArabic': searchablequranlist[index]
                                    ['SurahNameArabic']
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text('${index + 1}'),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "سورة ${searchablequranlist[index]['SurahNameArabic']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          searchablequranlist[index]
                                              ['SurahNameEnglish'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          '${searchablequranlist[index]['VerusCount']} verses',
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
                        itemCount: searchablequranlist.length,
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
                  IconButton(icon: const Icon(Icons.home), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                  IconButton(
                      icon: const Icon(Icons.read_more), onPressed: () {}),
                ],
              ),
            ),
          );
  }
}

class testt extends StatelessWidget {
  const testt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Text(
            "Sat",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text("5", style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
