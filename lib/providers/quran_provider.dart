import 'package:flutter/cupertino.dart';

import '../models/quran_model.dart';

//TODO return Quran list right why
class QuranProvider extends ChangeNotifier {
  List<QuranModel>? _quran;

  //QuranProvider get getQuran => _quran;

  Future<void> qq() async {
    List<QuranModel>? quran;
    notifyListeners();
  }
}
