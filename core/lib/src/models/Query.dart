class Query {
  String text;

  //facets
  String departmentAcronym;
  String status;

  // nujmeric
  String minDepartmentNumber;
  String maxDepartmentNumber;
  String startTime;
  String endTime;
  String m;
  String t;
  String w;
  String r;

  String get stringCode {
    //TODO
    return '';
  }
}

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
