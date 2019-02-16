import 'package:color/color.dart';

class CGColors {
  static const cgRed = Color.rgb(195, 40, 43);
  static const lightGray = Color.rgb(250, 250, 250);

  static const array = [
    //TODO: change all these to rgb
//    TriColor('FCE6EA', 'D74660', '96263A'),
//    TriColor('FDEADC', 'E4813D', 'A05320'),
//    TriColor('FDF0D4', 'E1AC3D', '9E7520'),
//    TriColor('E3F6EC', '30B36E', '157A45'),
//    TriColor('DAF4F2', '21AEA8', '0A7671'),
//    TriColor('D8ECF7', '298BC7', '1D618B'),
//    TriColor('DAE3F7', '335EC3', '244289'),
//    TriColor('E9DFF6', '7C4DBE', '573685'),
//    TriColor('DEE2E8', '455C78', '304154'),
  ];
}

class TriColor {
  final Color light, med, dark;

  const TriColor(this.light, this.med, this.dark);

  factory TriColor.fromJson(Map<String, dynamic> json) {
    return TriColor(json["light"], json["med"], json["dark"]);
  }

  Map<String, dynamic> toJson() => {
        'light': light,
        'med': med,
        'dark': dark,
      };
}
