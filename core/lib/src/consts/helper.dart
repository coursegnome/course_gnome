class Helper {
  static removeLastChars(int chars, String string) {
    return string.replaceRange(string.length - chars, string.length, '');
  }
}
