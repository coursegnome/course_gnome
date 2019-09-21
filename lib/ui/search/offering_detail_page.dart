import 'package:flutter/material.dart';

import 'package:course_gnome_data/models.dart';

import 'package:course_gnome/state/scheduling/scheduling.dart';
import 'package:course_gnome/ui/shared/shared.dart';
import 'package:course_gnome/ui/search/search.dart';

class OfferingDetailPage extends StatefulWidget {
  @override
  _OfferingDetailPageState createState() => _OfferingDetailPageState();
}

class _OfferingDetailPageState extends State<OfferingDetailPage> {
  @override
  Widget build(BuildContext context) {
    final ColoredOffering colloredOffering =
        ModalRoute.of(context).settings.arguments;
    return BasePage(
      showDrawer: false,
      page: Page.OfferingDetail,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hero(
          transitionOnUserGestures: true,
          tag: colloredOffering.offering.id,
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context)
                  .textTheme
                  .apply(bodyColor: colloredOffering.color),
            ),
            child: CourseCard(
              courses: [colloredOffering.offering],
              extraInfo: ExtraInfoContainer(
                color: colloredOffering.color,
                offering: colloredOffering.offering,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExtraInfoContainer extends StatelessWidget {
  final Offering offering;
  final Color color;

  ExtraInfoContainer({this.offering, this.color});

  @override
  Widget build(BuildContext context) {
    // final spaceAllowance =
    //     Breakpoints.allowance(MediaQuery.of(context).size.width);
    bool hasLocation = false;
    String locationString =
        offering.classTimes.length > 1 ? 'Locations: ' : 'Location: ';
    offering.classTimes.forEach((time) {
      locationString += time.location + ', ';
      hasLocation = true;
    });
    // locationString = Helper.removeLastChars(2, locationString);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Teachers: ' + offering.teachers.join(", "),
              style: TextStyle(color: color),
            ),
            Text(
              locationString,
              style: TextStyle(color: color),
            )
          ],
        ),
//         Container(
//           padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
//           color: lightGray,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Choose a Linked Course',
//                 style: TextStyle(color: color),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: List.generate(
//                   offering.linkedOfferings.length,
//                   (i) => FlatButton(
// //                              color: color.light,
//                     onPressed: () {},
//                     child: OfferingRow(color.med, offering),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )
      ],
    );
  }
}
