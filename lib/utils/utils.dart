class Utils {
  static bool isProbablyArabic(String str) {
    for (int i = 0; i < str.length; i++) {
      int c = str.codeUnitAt(i);
      if (c >= 0x0600 && c <= 0x06E0) {
        return true;
      }
    }
    return false;
  }
}
