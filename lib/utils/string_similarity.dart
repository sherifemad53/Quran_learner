class StringSimilarity {
  StringSimilarity._();

  static int _min(int a, int b) => a < b ? a : b;
  static int _max(int a, int b) => a > b ? a : b;

  static String needlemanWunsch(String refText, String recitedText) {
    int rows = refText.length + 1;
    int cols = recitedText.length + 1;
    List<List<int>> scoreMatrix =
        List.generate(rows, (_) => List.filled(cols, 0));

    int gapPenalty = -1;

    for (int i = 1; i < rows; i++) {
      scoreMatrix[i][0] = gapPenalty * i;
    }

    for (int j = 1; j < cols; j++) {
      scoreMatrix[0][j] = gapPenalty * j;
    }

    int matchScore = 1;
    int mismatchPenalty = -1;

    for (int i = 1; i < rows; i++) {
      for (int j = 1; j < cols; j++) {
        int diagonalScore;
        if (refText[i - 1] == recitedText[j - 1]) {
          diagonalScore = scoreMatrix[i - 1][j - 1] + matchScore;
        } else {
          diagonalScore = scoreMatrix[i - 1][j - 1] + mismatchPenalty;
        }

        int upScore = scoreMatrix[i - 1][j] + gapPenalty;
        int leftScore = scoreMatrix[i][j - 1] + gapPenalty;
        scoreMatrix[i][j] =
            [diagonalScore, upScore, leftScore].reduce((a, b) => a > b ? a : b);
      }
    }

    String alignedRefText = "";
    String alignedRecitedText = "";

    int i = rows - 1;
    int j = cols - 1;

    while (i > 0 || j > 0) {
      if (i > 0 && j > 0 && refText[i - 1] == recitedText[j - 1]) {
        alignedRefText = refText[i - 1] + alignedRefText;
        alignedRecitedText = recitedText[j - 1] + alignedRecitedText;
        i--;
        j--;
      } else if (i > 0 &&
          scoreMatrix[i][j] == scoreMatrix[i - 1][j] + gapPenalty) {
        alignedRefText = refText[i - 1] + alignedRefText;
        alignedRecitedText = "-$alignedRecitedText";
        i--;
      } else {
        alignedRefText = "-$alignedRefText";
        alignedRecitedText = recitedText[j - 1] + alignedRecitedText;
        j--;
      }
    }

    String highlightedRefText = "";
    for (int i = 0; i < alignedRefText.length; i++) {
      if (alignedRefText[i] == alignedRecitedText[i]) {
        highlightedRefText += alignedRefText[i];
      } else if (alignedRecitedText[i] == "-") {
        highlightedRefText +=
            "<span style='color: red;'>${alignedRefText[i]}</span>";
      } else {
        highlightedRefText +=
            "<span style='color: orange;'>${alignedRefText[i]}</span>";
      }
    }

    return "<p>$highlightedRefText</p>";
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
