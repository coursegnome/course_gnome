import 'package:core/core.dart';

class Query {
  String text;

  //facets
  String departmentAcronym;
  Status status;

  // numeric
  int minDepartmentNumber;
  int maxDepartmentNumber;
  String earliestStartTime;
  String latestEndTime;
  bool onlyDays;
  List<bool> days;

  String get queryString {
    String query = '';
    bool atLeastOneAdded = false;

    addFilter(String string) {
      if (atLeastOneAdded) {
        query += 'AND';
      }
      query += ' $string ';
    }

    if (departmentAcronym != null) {
      addFilter('departmentAcronym:$departmentAcronym');
    }
    if (status != null) {
      addFilter('status:${status.toString().split('.')[1]} ');
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
