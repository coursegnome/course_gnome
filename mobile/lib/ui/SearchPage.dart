import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:core/model/schedule.dart';
import 'package:core/model/course.dart';
import 'package:core/model/UtilityClasses.dart';
import 'package:core/controller/SchedulingPageController.dart';
import 'package:core/services/Networking.dart';

import 'package:course_gnome_mobile/ui/custom/CGExpansionTile.dart';
import 'package:course_gnome_mobile/utilities/UtilitiesClasses.dart';

class SearchPage extends StatefulWidget {
  final SchedulingPageController schedulingPageController;
  final VoidCallback toggleActivePage,
      clearResults,
      loadMoreResults,
      getSearchResults;
  final Function toggleOffering;
  SearchPage({
    @required this.schedulingPageController,
    @required this.toggleActivePage,
    @required this.loadMoreResults,
    @required this.clearResults,
    @required this.getSearchResults,
    @required this.toggleOffering,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _borderRadius = 3.0;
  final _searchTextFieldController = TextEditingController();
  var _searching = false;
  var _showingSearchResults = false;

  _clearSearch() {
    _searchTextFieldController.clear();
    widget.clearResults();
  }

  _onSearchFieldTap() {
    setState(() {
      _showingSearchResults = true;
    });
  }

  _dismissSearch() {
    setState(() {
      _showingSearchResults = false;
    });
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Search'),
        centerTitle: false,
        leading: _showingSearchResults
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: _dismissSearch,
              )
            : IconButton(icon: Icon(Icons.person), onPressed: () {}
                //TODO
                ),
        actions: [
          //TODO
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
          width < Breakpoints.split
              ? CalendarCounter(widget.schedulingPageController.calendars,
                  widget.toggleActivePage)
              : Container(),
        ],
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: _searchField(),
              floating: true,
              snap: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int i) {
                  return CourseCard(
                    currentCalendar: widget.schedulingPageController.calendars
                        .currentCalendar(),
                    toggleOffering: widget.toggleOffering,
                    course: widget
                        .schedulingPageController.searchResults.results[i],
                    borderRadius: _borderRadius,
                    color: FlutterTriColor(
                        CGColors.array[i % CGColors.array.length]),
//                        widget.schedulingPageController.colorFromIndex(i)),
                  );
                },
                addAutomaticKeepAlives: true,
                childCount:
                    widget.schedulingPageController.searchResults.results !=
                            null
                        ? widget.schedulingPageController.searchResults.results
                            .length
                        : 0,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: [
                        !_searching
                            ? widget.schedulingPageController.searchResults
                                            .results !=
                                        null &&
                                    widget.schedulingPageController
                                            .searchResults.total >
                                        widget.schedulingPageController
                                                .searchObject.offset +
                                            10
                                ? _loadMoreButton()
                                : Container()
                            : _progressIndicator()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SafeArea _searchField() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: TextField(
          onTap: _onSearchFieldTap,
          controller: _searchTextFieldController,
          onSubmitted: (text) => widget.getSearchResults(),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search for anything',
            prefixIcon: Icon(Icons.search),
            suffixIcon: _searchTextFieldController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                    onPressed: () => _clearSearch(),
                  )
                : null,
          ),
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.search,
        ),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(const Radius.circular(_borderRadius)),
          color: Colors.white,
        ),
      ),
    );
  }

  RaisedButton _loadMoreButton() {
    return RaisedButton.icon(
      icon: Icon(
        Icons.expand_more,
        color: Colors.white,
      ),
      color: CGColor.cgred,
      label: Text(
        'Load More',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onPressed: widget.loadMoreResults,
    );
  }

  Container _progressIndicator() {
    return Container(
      width: 60,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              CGColor.cgred,
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarCounter extends StatefulWidget {
  final Calendars _calendars;
  final VoidCallback _toggleActivePage;

  CalendarCounter(this._calendars, this._toggleActivePage);

  @override
  _CalendarCounterState createState() => _CalendarCounterState();
}

class _CalendarCounterState extends State<CalendarCounter> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FloatingActionButton(
          backgroundColor: Colors.transparent,
          highlightElevation: 0,
          elevation: 0,
          onPressed: widget._toggleActivePage,
          child: Stack(
            children: [
              IconButton(
                icon: Icon(Icons.calendar_today),
                disabledColor: Colors.white,
                onPressed: null,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    decoration: widget._calendars.currentCalendar().ids.length >
                            0
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: CGColor.cgred, width: 4))
                        : null,
                    width: 28,
                    height: 28,
                  ),
                  Positioned(
                    top: 5,
                    left: 9,
                    child: widget._calendars.currentCalendar().ids.length > 0
                        ? Text(
                            widget._calendars
                                .currentCalendar()
                                .ids
                                .length
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CGColor.cgred),
                          )
                        : Container(),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Filters extends StatelessWidget {
  final SearchObject searchObject;
  final Function updateSearchObject;

  Filters({this.searchObject, this.updateSearchObject});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: CGColor.cgred,
      child: Column(
//            mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'Department',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 1.0,
                  ),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 10,
                    children: List.generate(
                      Departments.departments.length,
                      (i) => GestureDetector(
                            onTap: () {
                              updateSearchObject(SearchObject(
                                  departmentAcronym: Departments.departments[i]
                                      ['acronym']));
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                color: searchObject.departmentAcronym ==
                                        Departments.departments[i]['acronym']
                                    ? Colors.green
                                    : Colors.transparent,
                              ),
                              child: Text(
                                Departments.departments[i]['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RaisedButton(
              color: Colors.orange,
              child: Text('Done'),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Function toggleOffering;
  final Calendar currentCalendar;
  final Course course;
  final double borderRadius;
  final FlutterTriColor color;

  CourseCard({
    this.toggleOffering,
    this.currentCalendar,
    this.course,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.med,
                borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(2),
                  topRight: const Radius.circular(2),
                ),
              ),
              height: 4,
            ),
            Container(
              padding: EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        course.departmentAcronym + course.departmentNumber,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: color.med),
                      ),
                      Text(
                        course.credit == '0'
                            ? course.credit + ' credit'
                            : course.credit + ' credits',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: color.med),
                      ),
                    ],
                  ),
                  Text(
                    course.name,
                    style: Theme.of(context).textTheme.title.copyWith(
                        color: color.med, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(
                course.offerings.length,
                (j) => Container(
                      color:
                          currentCalendar.ids.contains(course.offerings[j].crn)
                              ? color.med.withOpacity(0.1)
                              : Colors.transparent,
                      child: CGExpansionTile(
                        key: PageStorageKey<String>(course.offerings[j].crn),
                        color: color.med,
                        onLongPress: () {
                          HapticFeedback.selectionClick();
                          toggleOffering(
                              course, course.offerings[j], color.toTriColor());
                        },
                        title: GestureDetector(
                          child: OfferingRow(color.med, course.offerings[j]),
                        ),
                        children: [
                          ExtraInfoContainer(color, course.offerings[j], course)
                        ],
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferingRow extends StatelessWidget {
  final Color color;
  final Offering offering;

  OfferingRow(this.color, this.offering);

  @override
  Widget build(BuildContext context) {
    final spaceAllowance =
        Breakpoints.allowance(MediaQuery.of(context).size.width);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            offering.sectionNumber,
            style: TextStyle(color: color),
          ),
        ),
        offering.instructors != null && spaceAllowance >= 3
            ? Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    offering.instructors.join(', '),
                    style: TextStyle(color: color),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            : Container(),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              offering.classTimes.length,
              (k) => ClassTimeRow(offering.classTimes[k], color),
            ),
          ),
        ),
        offering.crn != null && spaceAllowance >= 2
            ? Expanded(
                flex: 2,
                child: Text(
                  offering.crn,
                  style: TextStyle(color: color),
                  textAlign: TextAlign.right,
                ),
              )
            : Container(),
      ],
    );
  }
}

class CGChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffffcdd2),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Text(
        'C',
        style: TextStyle(color: Color(0xffc62828)),
      ),
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      margin: EdgeInsets.only(right: 5),
    );
  }
}

class ClassTimeRow extends StatelessWidget {
  final ClassTime classTime;
  final Color color;

  ClassTimeRow(this.classTime, this.color);

  @override
  Widget build(BuildContext context) {
    final spaceAllowance =
        Breakpoints.allowance(MediaQuery.of(context).size.width);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        classTime.location != null && spaceAllowance >= 4
            ? Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  classTime.location,
                  style: TextStyle(color: color),
                ),
              )
            : Container(),
        Row(
          children: List.generate(
            5,
            (i) => Container(
                  margin: EdgeInsets.only(right: 2, top: 2),
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: _dayIsIncluded(classTime, i)
                        ? color
                        : Colors.transparent,
                    border: Border.all(color: color, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(
            classTime.timeRange,
            style: TextStyle(color: color),
          ),
        )
      ],
    );
  }

  bool _dayIsIncluded(ClassTime ct, int i) {
    switch (i) {
      case 0:
        return ct.mon == true;
      case 1:
        return ct.tues == true;
      case 2:
        return ct.weds == true;
      case 3:
        return ct.thur == true;
      case 4:
        return ct.fri == true;
      default:
        return true;
    }
  }
}

class ExtraInfoContainer extends StatelessWidget {
  final FlutterTriColor color;
  final Offering offering;
  final Course course;

  ExtraInfoContainer(this.color, this.offering, this.course);

  openCoursePage() async {
    final url = course.bulletinLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final spaceAllowance =
        Breakpoints.allowance(MediaQuery.of(context).size.width);
    bool hasLocation = false;
    String locationString =
        offering.classTimes.length > 1 ? 'Locations: ' : 'Location: ';
    offering.classTimes.forEach((time) {
      locationString += time.location + ', ';
      hasLocation = true;
    });
    locationString = Helper.removeLastChars(2, locationString);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              offering.instructors != null && spaceAllowance < 3
                  ? Text(
                      'Instructors: ' + offering.instructors.join(", "),
                      style: TextStyle(color: color.med),
                    )
                  : Container(),
              hasLocation && spaceAllowance < 4
                  ? Text(
                      locationString,
                      style: TextStyle(color: color.med),
                    )
                  : Container(),
            ],
          ),
        ),
        offering.linkedOfferings != null
            ? Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                color: CGColor.lightGray,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Choose a Linked Course',
                      style: TextStyle(color: color.med),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        offering.linkedOfferings.length,
                        (i) => FlatButton(
//                              color: color.light,
                              onPressed: () {},
                              child: OfferingRow(color.med, offering),
                            ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        course.bulletinLink != null
            ? FlatButton.icon(
                padding: EdgeInsets.only(left: 15),
                icon: Icon(
                  Icons.open_in_browser,
                  color: color.med,
                ),
                label: Text(
                  'See More',
                  style: TextStyle(color: color.med),
                ),
                onPressed: () => openCoursePage(),
              )
            : Container(),
      ],
    );
  }
}
