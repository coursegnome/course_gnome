import 'package:core/core.dart';

class Query {
  String text;

  //facets
  List<String> departments;
  List<Status> statuses;

  // numeric
  int minDepartmentNumber;
  int maxDepartmentNumber;
  TimeOfDay earliestStartTime;
  TimeOfDay latestEndTime;
  bool onlyDays;
  List<bool> days;

  bool isEmpty() {
    return text.isEmpty && departments.isEmpty;
  }

  String get queryString {
    String query = '';
    bool atLeastOneAdded = false;

    void addFilter(String string) {
      if (atLeastOneAdded) {
        query += 'AND';
      }
      query += ' $string ';
    }

    if (departments != null) {
//      addFilter('departmentAcronym:$departmentAcronym');
    }
    if (statuses != null) {
//      addFilter('status:${status.toString().split('.')[1]} ');
    }
    if (minDepartmentNumber != null) {
      addFilter('departmentNumber >= $minDepartmentNumber');
    }
    if (maxDepartmentNumber != null) {
      addFilter('departmentNumber <= $maxDepartmentNumber');
    }
    if (earliestStartTime != null) {
      addFilter('offerings.earliestStartTime > $earliestStartTime');
    }
    if (latestEndTime != null) {
      addFilter('offerings.latestEndTime > $latestEndTime');
    }
    return query;
  }

  String get stringCode {
    String code = '';
    if (departmentAcronym != null) {
      addFilter('departmentAcronym:$departmentAcronym ');
    }
    if (status != null) {
      code += 'status:${status.toString().split('.')[1]} ';
    }
    if (minDepartmentNumber != null) {
      code += '';
    }
    return code;
  }

  addFilter(String string) {
//    if (code) {}
  }
}

/// ```price < 10 AND (category:Book OR NOT category:Ebook)```

//filters: 'attribute:value AND | OR | NOT attribute:value'
//'numeric_attribute = | != | > | >= | < | <= numeric_value'
//'attribute:lower_value TO higher_value'
//'facetName:facetValue'
//'_tags:value'
//'attribute:value'
//
//var object = {
//'available': 1,
//'ornot': {,
//'category': 'book',
//
//}
//}
//
//String filters = new String(
//    "available = 1"
//        + " AND (category:Book OR NOT category:Ebook)"
//        + " AND _tags:published"
//        + " AND publication_date:1441745506 TO 1441755506"
//        + " AND inStock > 0"
//        + " AND author:\"John Doe\""
//);
