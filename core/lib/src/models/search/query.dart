import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class Query extends Equatable {
  Query({
    this.text,
    this.departments,
    this.statuses,
    this.minDepartmentNumber,
    this.maxDepartmentNumber,
    this.earliestStartTime,
    this.latestEndTime,
    this.onlyDays,
    this.days,
  }) : super([
          text,
          departments,
          statuses,
          minDepartmentNumber,
          maxDepartmentNumber,
          earliestStartTime,
          latestEndTime,
          onlyDays,
          days,
        ]);

  // search text
  String text;

  //facets
  List<String> departments;
  List<Status> statuses;

  // numeric
  int minDepartmentNumber, maxDepartmentNumber;
  TimeOfDay earliestStartTime, latestEndTime;
  bool onlyDays;
  List<bool> days;

  bool get isEmpty =>
      text == null &&
      departments == null &&
      statuses == null &&
      minDepartmentNumber == null &&
      maxDepartmentNumber == null &&
      earliestStartTime == null &&
      latestEndTime == null &&
      onlyDays == null &&
      days == null;

  @override
  String toString() {
    String query = '';
    bool atLeastOneAdded = false;

    void addFilter(String string) {
      if (atLeastOneAdded) {
        query += 'AND';
      }
      query += ' $string ';
      atLeastOneAdded = true;
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
}

// ```price < 10 AND (category:Book OR NOT category:Ebook)```

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
