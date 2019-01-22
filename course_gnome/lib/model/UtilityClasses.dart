class CGColors {

  static String toFlutterHex (String color) => '0xff$color';
  static String toWebHex (String color) => '#$color';

  static const array = [
    TriColor('FCE6EA', 'D74660', '96263A'),
    TriColor('FDEADC', 'E4813D', 'A05320'),
    TriColor('FDF0D4', 'E1AC3D', '9E7520'),
    TriColor('E3F6EC', '30B36E', '157A45'),
    TriColor('DAF4F2', '21AEA8', '0A7671'),
    TriColor('D8ECF7', '298BC7', '1D618B'),
    TriColor('DAE3F7', '335EC3', '244289'),
    TriColor('E9DFF6', '7C4DBE', '573685'),
    TriColor('DEE2E8', '455C78', '304154'),
  ];

}

class TriColor {
  final String light, med, dark;

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

class Helper {
  static removeLastChars(int chars, String string) {
    return string.replaceRange(string.length - chars, string.length, '');
  }
}

class Breakpoints {
  static int sm = 400;
  static int md = 600;
  static int lg = 813;
}

class TimeOfDay {
  final int hour, minute;
  TimeOfDay({this.hour, this.minute});
}

class Departments {
  static const departments = [
    { 'name': 'Accountancy', 'acronym': 'ACCY' },
    { 'name': 'American Studies', 'acronym': 'AMST' },
    { 'name': 'Anatomy and Regenerative Biology', 'acronym': 'ANAT' },
    { 'name': 'Anthropology', 'acronym': 'ANTH' },
    { 'name': 'Applied Science', 'acronym': 'APSC' },
    { 'name': 'Arabic', 'acronym': 'ARAB' },
    { 'name': 'Art History', 'acronym': 'AH' },
    { 'name': 'Astronomy', 'acronym': 'ASTR' },
    { 'name': 'Biochemistry', 'acronym': 'BIOC' },
    { 'name': 'Biological Sciences', 'acronym': 'BISC' },
    { 'name': 'Biomedical Engineering', 'acronym': 'BME' },
    { 'name': 'Biomedical Sciences', 'acronym': 'BMSC' },
    { 'name': 'Business Administration', 'acronym': 'BADM' },
    { 'name': 'Chemistry', 'acronym': 'CHEM' },
    { 'name': 'Chinese', 'acronym': 'CHIN' },
    { 'name': 'Civil Engineering', 'acronym': 'CE' },
    { 'name': 'Classical Studies', 'acronym': 'CLAS' },
    { 'name': 'Columbian College', 'acronym': 'CCAS' },
    { 'name': 'Communication', 'acronym': 'COMM' },
    { 'name': 'Computer Science', 'acronym': 'CSCI' },
    { 'name': 'Corcoran Art History', 'acronym': 'CAH' },
    { 'name': 'Corcoran Continuing Education', 'acronym': 'CCE' },
    { 'name': 'Corcoran Digital Media Design', 'acronym': 'CDM' },
    { 'name': 'Corcoran Fine Art', 'acronym': 'CFA' },
    { 'name': 'Corcoran First Year Foundation', 'acronym': 'CFN' },
    { 'name': 'Corcoran Photography', 'acronym': 'CPH' },
    { 'name': 'Corcoran Photojournalism', 'acronym': 'CPJ' },
    { 'name': 'Counseling', 'acronym': 'CNSL' },
    { 'name': 'Curriculum and Pedagogy', 'acronym': 'CPED' },
    { 'name': 'Data Science', 'acronym': 'DATS' },
    { 'name': 'Decision Sciences', 'acronym': 'DNSC' },
    { 'name': 'East Asian Language and Literature', 'acronym': 'EALL' },
    { 'name': 'Economics', 'acronym': 'ECON' },
    { 'name': 'Educational Leadership', 'acronym': 'EDUC' },
    { 'name': 'Electrical and Computer Engineering', 'acronym': 'ECE' },
    { 'name': 'Emergency Health Services', 'acronym': 'EHS' },
    { 'name': 'Engineering Management and Systems Engineering', 'acronym': 'EMSE' },
    { 'name': 'English', 'acronym': 'ENGL' },
    { 'name': 'English for Academic Purposes', 'acronym': 'EAP' },
    { 'name': 'Environmental Resource Policy', 'acronym': 'ENRP' },
    { 'name': 'Environmental Studies', 'acronym': 'ENVR' },
    { 'name': 'Epidemiology', 'acronym': 'EPID' },
    { 'name': 'Exercise and Nutrition Sciences', 'acronym': 'EXNS' },
    { 'name': 'Film Studies', 'acronym': 'FILM' },
    { 'name': 'Finance', 'acronym': 'FINA' },
    { 'name': 'Fine Arts', 'acronym': 'FA' },
    { 'name': 'Forensic Sciences', 'acronym': 'FORS' },
    { 'name': 'French', 'acronym': 'FREN' },
    { 'name': 'Geography', 'acronym': 'GEOG' },
    { 'name': 'Geology', 'acronym': 'GEOL' },
    { 'name': 'Germanic Language and Literature', 'acronym': 'GER' },
    { 'name': 'Government Contracts', 'acronym': 'GCON' },
    { 'name': 'Greek', 'acronym': 'GREK' },
    { 'name': 'GWTeach', 'acronym': 'GTCH' },
    { 'name': 'Health Sciences Programs', 'acronym': 'HSCI' },
    { 'name': 'Health Services Management and Leadership', 'acronym': 'HSML' },
    { 'name': 'Health and Wellness', 'acronym': 'HLWL' },
    { 'name': 'Hebrew', 'acronym': 'HEBR' },
    { 'name': 'History', 'acronym': 'HIST' },
    { 'name': 'Hominid Paleobiology', 'acronym': 'HOMP' },
    { 'name': 'Honors', 'acronym': 'HONR' },
    { 'name': 'Human Development', 'acronym': 'HDEV' },
    { 'name': 'Human Organizational Learning', 'acronym': 'HOL' },
    { 'name': 'Human Services and Social Justice', 'acronym': 'HSSJ' },
    { 'name': 'Information Systems Technology Management', 'acronym': 'ISTM' },
    { 'name': 'International Affairs', 'acronym': 'IAFF' },
    { 'name': 'International Business', 'acronym': 'IBUS' },
    { 'name': 'Italian', 'acronym': 'ITAL' },
    { 'name': 'Japanese', 'acronym': 'JAPN' },
    { 'name': 'Judaic Studies', 'acronym': 'JSTD' },
    { 'name': 'Korean', 'acronym': 'KOR' },
    { 'name': 'Latin', 'acronym': 'LATN' },
    { 'name': 'Law', 'acronym': 'LAW' },
    { 'name': 'Lifestyle, Sport, and Physical Activity', 'acronym': 'LSPA' },
    { 'name': 'Management', 'acronym': 'MGT' },
    { 'name': 'Marketing', 'acronym': 'MKTG' },
    { 'name': 'Master of Business Administration', 'acronym': 'MBAD' },
    { 'name': 'Mathematics', 'acronym': 'MATH' },
    { 'name': 'Mechanical and Aerospace Engineering', 'acronym': 'MAE' },
    { 'name': 'Medical Laboratory Science', 'acronym': 'MLS' },
    { 'name': 'Microbiology, Immunology, and Tropical Medicine', 'acronym': 'MICR' },
    { 'name': 'Molecular Medicine', 'acronym': 'MMED' },
    { 'name': 'Museum Studies', 'acronym': 'MSTD' },
    { 'name': 'Music', 'acronym': 'MUS' },
    { 'name': 'Naval Science', 'acronym': 'NSC' },
    { 'name': 'Nursing', 'acronym': 'NURS' },
    { 'name': 'Organizational Sciences', 'acronym': 'ORSC' },
    { 'name': 'Patent Practice', 'acronym': 'PATN' },
    { 'name': 'Peace Studies', 'acronym': 'PSTD' },
    { 'name': 'Persian', 'acronym': 'PERS' },
    { 'name': 'Pharmacogenomics', 'acronym': 'PHRG' },
    { 'name': 'Pharmacology', 'acronym': 'PHAR' },
    { 'name': 'Philosophy', 'acronym': 'PHIL' },
    { 'name': 'Physical Therapy', 'acronym': 'PT' },
    { 'name': 'Physician Assistant', 'acronym': 'PA' },
    { 'name': 'Physics', 'acronym': 'PHYS' },
    { 'name': 'Physiology', 'acronym': 'PHYL' },
    { 'name': 'Political Management', 'acronym': 'PMGT' },
    { 'name': 'Political Psychology', 'acronym': 'PPSY' },
    { 'name': 'Political Science', 'acronym': 'PSC' },
    { 'name': 'Portuguese', 'acronym': 'PORT' },
    { 'name': 'Professional Psychology', 'acronym': 'PSYD' },
    { 'name': 'Psychology', 'acronym': 'PSYC' },
    { 'name': 'Public Health', 'acronym': 'PUBH' },
    { 'name': 'Public Policy and Public Admin', 'acronym': 'PPPA' },
    { 'name': 'Religion', 'acronym': 'REL' },
    { 'name': 'School of Engineering and Applied Science', 'acronym': 'SEAS' },
    { 'name': 'School of Media and Public Affairs', 'acronym': 'SMPA' },
    { 'name': 'Slavic Languages and Literature', 'acronym': 'SLAV' },
    { 'name': 'Sociology', 'acronym': 'SOC' },
    { 'name': 'Spanish', 'acronym': 'SPAN' },
    { 'name': 'Special Education', 'acronym': 'SPED' },
    { 'name': 'Speech and Hearing Science', 'acronym': 'SPHR' },
    { 'name': 'Statistics', 'acronym': 'STAT' },
    { 'name': 'Strategic Management and Public Policy', 'acronym': 'SMPP' },
    { 'name': 'Sustainability', 'acronym': 'SUST' },
    { 'name': 'Theatre and Dance', 'acronym': 'TRDA' },
    { 'name': 'Tourism Studies', 'acronym': 'TSTD' },
    { 'name': 'Turkish', 'acronym': 'TURK' },
    { 'name': 'University Writing', 'acronym': 'UW' },
    { 'name': 'Vietnamese', 'acronym': 'VIET' },
    { 'name': 'Women and Leadership Program', 'acronym': 'WLP' },
    { 'name': 'Women\'s, Gender, and Sexuality Studies', 'acronym': 'WGSS' },
    { 'name': 'Yiddish', 'acronym': 'YDSH' }
  ];
}
