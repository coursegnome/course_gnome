class Breakpoints {
  // Returns a space allowance, 1-4, for laying out progressively large rows
  // 1. section, days, times
  // 2. crn
  // 3. instructors
  // 4. location
  static const int xxs = 350;
  static const int xs = 450;
  static const int sm = 670;
  static const int split = 850;
  static const int lg = 1010;
  static const int xl = 1170;
  static int allowance(double width) {
    if (width <= xxs) {
      return 1;
    }
    if ((width >= xxs && width < xs) || (width >= split && width < lg)) {
      return 2;
    }
    if ((width >= xs && width < sm) || (width >= lg && width < xl)) {
      return 3;
    }
    if ((width >= sm && width < split) || width >= xl) {
      return 4;
    }
    return -1;
  }
}
