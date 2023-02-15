class StringSimilarity {
  StringSimilarity._();

  static int _min(int a, int b) {
    if (a > b) {
      return b;
    }
    return a;
  }

  static int _max(int a, int b) {
    if (a > b) {
      return a;
    }
    return b;
  }

  static int _levenshtein(String a, String b) {
    a = a.toUpperCase();
    b = b.toUpperCase();

    int sa = a.length;
    int sb = b.length;
    int i, j, cost, min1, min2, min3;
    int levenshtein;

    List<List<int>> d =
        List.generate(sa + 1, (int i) => List.filled(sb + 1, 0));

    // print(d.length);

    if (a.isEmpty) {
      levenshtein = b.length;
      return (levenshtein);
    }
    if (b.isEmpty) {
      levenshtein = a.length;
      return (levenshtein);
    }
    for (i = 0; i <= sa; i++) {
      d[i][0] = i;
    }
    for (j = 0; j <= sb; j++) {
      d[0][j] = j;
    }
    for (i = 1; i <= a.length; i++) {
      for (j = 1; j <= b.length; j++) {
        if (a[i - 1] == b[j - 1]) {
          cost = 0;
        } else {
          cost = 1;
        }

        min1 = (d[i - 1][j] + 1);
        min2 = (d[i][j - 1] + 1);
        min3 = (d[i - 1][j - 1] + cost);

        d[i][j] = _min(min1, _min(min2, min3));
      }
    }
    levenshtein = d[a.length][b.length];
    return (levenshtein);
  }

  static double similarity(String a, String b) {
    double similarity;
    a = a.toUpperCase();
    b = b.toUpperCase();
    similarity = 1 - _levenshtein(a, b) / (_max(a.length, b.length));
    return (similarity);
  }
}
