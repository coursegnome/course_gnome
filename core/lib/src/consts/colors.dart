import 'package:color/color.dart';

class CGColors {
  static const cgRed = Color.rgb(195, 40, 43);
  static const lightGray = Color.rgb(250, 250, 250);

  static const array = <TriColor>[
  ];
}

class TriColor {

  const TriColor(this.light, this.med, this.dark);

  factory TriColor.fromJson(Map<String, dynamic> json) {
    return TriColor(json['light'], json['med'], json['dark']);
  }

  final Color light, med, dark;
  
  Map<String, dynamic> toJson() => <String, dynamic>{
        'light': light,
        'med': med,
        'dark': dark,
      };
}
