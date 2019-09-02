// Returns a space allowance, 1-4, for laying out progressively large rows
// 1. section, days, times
// 2. crn
// 3. instructors
// 4. location
const int xxs = 350;
const int xs = 450;
const int sm = 670;
const int split = 850;
const int lg = 1010;
const int xl = 1170;

enum Allowance { S, M, L, XL }

Allowance allowance(double width) {
  if (width <= xxs) {
    return Allowance.S;
  }
  if ((width >= xxs && width < xs) || (width >= split && width < lg)) {
    return Allowance.M;
  }
  if ((width >= xs && width < sm) || (width >= lg && width < xl)) {
    return Allowance.L;
  }
  // if ((width >= sm && width < split) || width >= xl) {
  return Allowance.XL;
  // }
}
