const cgRed = CGColor('d12027');

class CGColor {
  const CGColor(this.hex);

  /// Color as hex, i.e. 3H2CC9
  final String hex;

  /// For Flutter
  int get asInt => int.parse('0xFF$hex');

  /// For Web
  String get asString => '#$hex';
}
