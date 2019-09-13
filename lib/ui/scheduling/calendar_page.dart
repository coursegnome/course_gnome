import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:course_gnome/state/scheduling/scheduling.dart';
import 'package:course_gnome/ui/shared/shared.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({this.filtersAreOpen});
  final bool filtersAreOpen;
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static final minHourHeight = 60.0;
  static final minDayWidth = 60.0;
  static final maxHourHeight = 140.0;
  static final maxDayWidth = 140.0;
  var hourHeight = 100.0;
  var dayWidth = 100.0;

  ScrollController hourController;
  ScrollController dayController;
  ScrollController horizontalCalController;
  ScrollController verticalCalController;

  _calHorizontallyScrolled() {
    dayController.jumpTo(horizontalCalController.offset);
  }

  _calVerticallyScrolled() {
    hourController.jumpTo(verticalCalController.offset);
  }

  double initialValue;
  double initialScrollPosition;

  double initialWidth;
  double initialHeight;

  scaleStart(ScaleStartDetails details) {
    // setState(() {
    //   initialWidth = dayWidth;
    //   initialHeight = hourHeight;
    // });
  }

  scaleUpdate(ScaleUpdateDetails details) {
    // final width = initialWidth * details.horizontalScale;
    // if (width > maxDayWidth || width < minDayWidth) return;
    // final height = initialValue * details.verticalScale;
    // if (height > maxHourHeight || height < minHourHeight) return;
    // setState(() {
    //   dayWidth = width;
    //   hourHeight = height;
    // });
    // verticalCalController.jumpTo(
    //   initialScrollPosition * details.verticalScale,
    // );
    // horizontalCalController.jumpTo(
    //   initialScrollPosition * details.horizontalScale,
    // );
  }

  _showDialog(String title, Widget body, String opOneText, String opTwoText,
      VoidCallback opOneAction, VoidCallback opTwoAction) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(title),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: body,
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text(opOneText),
                    onPressed: opOneAction,
                  ),
                  FlatButton(
                    child: Text(opTwoText),
                    onPressed: opTwoAction,
                  )
                ],
              )
            ],
          );
        });
  }

  Widget _textField() {
//     return TextField(
//       autofocus: true,
//       controller: widget.calendarNameController,
//       textCapitalization: TextCapitalization.words,
//       onSubmitted: (text) => widget.addCalendar(),
//       maxLength: 20,
//       maxLengthEnforced: true,
//       style: Theme.of(context).textTheme.headline,
// //      decoration: InputDecoration(
// //        suffixIcon: widget.calendarNameController.text.isNotEmpty
// //            ? IconButton(
// //                icon: const Icon(
// //                  Icons.clear,
// //                  color: Colors.grey,
// //                ),
// //                onPressed: () {
// //                  setState(() {
// //                    widget.calendarNameController.clear();
// //                  });
// //                },
// //              )
// //            : Container(),
// //      ),
//     );
  }

  _showAddCalendarDialog() {
    // _showDialog(
    //   'Add Calendar',
    //   _textField(),
    //   'Add',
    //   'Cancel',
    //   widget.addCalendar,
    //   () => Navigator.pop(context),
    // );
  }

  _showEditCalendarDialog() {
    // widget.calendarNameController.text = widget
    //     .schedulingPageController
    //     .calendars
    //     .list[widget.schedulingPageController.calendars.currentScheduleIndex]
    //     .name;
    // _showDialog(
    //   'Edit Calendar',
    //   _textField(),
    //   'Save',
    //   'Cancel',
    //   widget.editCurrentCalendarName,
    //   () {
    //     widget.calendarNameController.clear();
    //     Navigator.pop(context);
    //   },
    // );
  }

  _showDeleteCalendarDialog() {
    // _showDialog(
    //   'Delete Calendar',
    //   Text('Delete calendar ' +
    //       widget
    //           .schedulingPageController
    //           .calendars
    //           .list[widget
    //               .schedulingPageController.calendars.currentScheduleIndex]
    //           .name +
    //       '?'),
    //   'Delete',
    //   'Cancel',
    //   widget.deleteCurrentCalendar,
    //   () => Navigator.pop(context),
    // );
  }

  @override
  void initState() {
    super.initState();
    hourController = ScrollController(initialScrollOffset: hourHeight * 4);
    verticalCalController =
        ScrollController(initialScrollOffset: hourHeight * 4);
    dayController = ScrollController(initialScrollOffset: dayWidth);
    horizontalCalController = ScrollController(initialScrollOffset: dayWidth);
    horizontalCalController.addListener(_calHorizontallyScrolled);
    verticalCalController.addListener(_calVerticallyScrolled);
  }

  @override
  void dispose() {
    hourController.dispose();
    dayController.dispose();
    horizontalCalController.dispose();
    verticalCalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<ScheduleBloc>(context),
      builder: (_, ScheduleState state) {
        return !(state is SchedulesLoaded)
            ? DefaultTabController(
                length: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      color: cgRed,
                      child: TabBar(
                        indicatorColor: Colors.white,
                        isScrollable: true,
                        tabs: [
                          Tab(child: Text('My Calendar')),
                          Tab(child: Text('Computer Science')),
                        ],
                        // tabs: List.generate(
                        //   calendars.list.length,
                        //   (i) => Tab(
                        //       text: widget.schedulingPageController.calendars
                        //           .list[i].name),
                        // ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          Text('hello'),
                          Text('hello2'),
                        ],
                      ),
                    ),
                  ],
                  // return DefaultTabController(length:1,child: TabBar(
                  //       controller: widget.tabController,
                  //       isScrollable: true,
                  //       indicatorColor: Colors.white,
                  //       tabs: List.generate(
                  //         widget.schedulingPageController.calendars.list.length,
                  //         (i) => Tab(
                  //             text: widget.schedulingPageController.calendars.list[i].name),
                  //       ),
                  //     ),
                  //   ),
                  //   body: TabBarView(
                  //     physics: NeverScrollableScrollPhysics(),
                  //     controller: widget.tabController,
                  //     children: List.generate(
                  //       widget.schedulingPageController.calendars.list.length,
                  //       (i) => Column(
                  //         children: <Widget>[
                  //           DayList(
                  //               CalendarValues.dayCount,
                  //               widget.schedulingPageController.calendarValues.dayWidth,
                  //               dayController),
                  //           Expanded(
                  //             child: SafeArea(
                  //               right: false,
                  //               child: Row(
                  //                 children: <Widget>[
                  //                   HourList(
                  //                       CalendarValues.hourCount,
                  //                       CalendarValues.startHour,
                  //                       widget.schedulingPageController.calendarValues
                  //                           .hourHeight,
                  //                       hourController),
                  //                   CalendarView(
                  //                     CalendarValues.dayCount,
                  //                     CalendarValues.hourCount,
                  //                     CalendarValues.startHour,
                  //                     widget.schedulingPageController.calendarValues.dayWidth,
                  //                     widget
                  //                         .schedulingPageController.calendarValues.hourHeight,
                  //                     horizontalCalController,
                  //                     verticalCalController,
                  //                     widget.schedulingPageController.calendars.list[i],
                  //                     widget.removeOffering,
                  //                     scaleStart,
                  //                     scaleUpdate,
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                ),
              )
            : Container();
      },
    );
  }
}

class CalendarView extends StatefulWidget {
  final int dayCount, hourCount, startHour;
  final double dayWidth, hourHeight;
  final ScrollController horizontalCalController, verticalCalController;
  final Schedule schedule;
  final Function removeOffering;
  final Function scaleStart, scaleUpdate;

  CalendarView(
    this.dayCount,
    this.hourCount,
    this.startHour,
    this.dayWidth,
    this.hourHeight,
    this.horizontalCalController,
    this.verticalCalController,
    this.schedule,
    this.removeOffering,
    this.scaleStart,
    this.scaleUpdate,
  );

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  static const BorderSide border = BorderSide(color: Colors.grey, width: 0.25);
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SingleChildScrollView(
              controller: widget.verticalCalController,
              scrollDirection: Axis.vertical,
              child: GestureDetector(
                onScaleStart: (details) => widget.scaleStart(details),
                onScaleUpdate: (details) => widget.scaleUpdate(details),
                child: SizedBox(
                  height: widget.hourHeight * widget.hourCount,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    controller: widget.horizontalCalController,
                    children: List.generate(
                      widget.dayCount,
                      (i) => Stack(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: List.generate(
                                widget.hourCount,
                                (j) => Container(
                                  decoration: BoxDecoration(
                                    border: i == widget.dayCount - 1
                                        ? const Border(
                                            top: border,
                                            left: border,
                                            right: border,
                                          )
                                        : const Border(
                                            top: border,
                                            left: border,
                                          ),
                                  ),
                                  height: widget.hourHeight,
                                  width: widget.dayWidth,
                                ),
                              ),
                            ),
                          ),
                          widget.schedule.graphicsForDay(i).isNotEmpty
                              ? Stack(
                                  children: List.generate(
                                    widget.schedule.graphicsForDay(i).length,
                                    (k) => Positioned(
                                      child: LongPressDraggable(
                                        data: 2,
                                        childWhenDragging: Container(),
                                        maxSimultaneousDrags: 1,
                                        child: ClassBlockWidget(
                                          false,
                                          widget.startHour,
                                          widget.dayWidth,
                                          widget.hourHeight,
                                          widget.schedule.graphicsForDay(i)[k],
                                        ),
                                        feedback: ClassBlockWidget(
                                          true,
                                          widget.startHour,
                                          widget.dayWidth,
                                          widget.hourHeight,
                                          widget.schedule.graphicsForDay(i)[k],
                                        ),
                                        onDragStarted: () {
                                          setState(() {
                                            _dragging = true;
                                          });
                                        },
                                        onDragEnd: (details) {
                                          setState(() {
                                            _dragging = false;
                                          });
                                        },
                                        onDraggableCanceled:
                                            (velocity, offset) {},
                                        onDragCompleted: () {
                                          // widget.removeOffering(widget
                                          // .schedule.blocksByDay[i][k].id);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _dragging
                ? Positioned(
                    bottom: 30,
                    child: SafeArea(
                      child: DragTarget(
                        onAccept: (int color) {},
                        onWillAccept: (ni) {
                          HapticFeedback.mediumImpact();
                          return true;
                        },
                        builder: (
                          BuildContext context,
                          List<dynamic> accepted,
                          List<dynamic> rejected,
                        ) {
                          return Container(
                            width: 100.0,
                            height: 100.0,
                            child: Icon(
                                accepted.isNotEmpty
                                    ? Icons.delete_outline
                                    : Icons.delete,
                                size: accepted.isNotEmpty ? 50 : 40),
                          );
                        },
                      ),
                    ),
                  )
                : Positioned(child: Container()),
          ],
        ),
      ),
    );
  }
}

class DayList extends StatelessWidget {
  static const dayStrings = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  final int dayCount;
  final double dayWidth;
  final ScrollController dayController;

  DayList(this.dayCount, this.dayWidth, this.dayController);

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Color.fromRGBO(10, 10, 10, 0.05),
      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
      height: 40,
      child: SafeArea(
        bottom: false,
        child: ListView(
          itemExtent: dayWidth,
          physics: NeverScrollableScrollPhysics(),
          controller: dayController,
          scrollDirection: Axis.horizontal,
          children: List.generate(
            dayCount,
            (i) => Container(
              alignment: Alignment.center,
              width: dayWidth,
              child: Text(dayWidth > 80 ? dayStrings[i] : dayStrings[i][0]),
            ),
          ),
        ),
      ),
    );
  }
}

class HourList extends StatelessWidget {
  final int hourCount, startHour;
  final double hourHeight;
  final ScrollController hourController;

  HourList(
      this.hourCount, this.startHour, this.hourHeight, this.hourController);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 4, 8),
      width: 30,
      child: ListView(
        itemExtent: hourHeight,
        physics: NeverScrollableScrollPhysics(),
        controller: hourController,
        children: List.generate(
          hourCount,
          (i) => Container(
            height: hourHeight,
            child: Text(
              ((i + startHour - 1) % 12 + 1).toString(),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
    );
  }
}

class ClassBlockWidget extends StatefulWidget {
  final bool hover;
  final int startHour;
  final double dayWidth, hourHeight;
  final GraphicalClassTime classBlock;

  ClassBlockWidget(this.hover, this.startHour, this.dayWidth, this.hourHeight,
      this.classBlock);

  @override
  _ClassBlockWidgetState createState() => _ClassBlockWidgetState();
}

class _ClassBlockWidgetState extends State<ClassBlockWidget> {
//  static const heightBreakpoint = 1;
  static const borderRadius = 3.0;
  static const lighteningFactor = 80;
  static const hoverSizeIncrease = 20;

  double calculateOffset() {
    return widget.classBlock.offset * widget.hourHeight -
        widget.startHour * widget.hourHeight -
        (widget.hover ? hoverSizeIncrease / 2 : 0);
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.classBlock.height * widget.hourHeight;
    return Opacity(
      opacity: widget.hover ? 0.5 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          // color: color.light.withOpacity(0.75),
        ),
        margin: EdgeInsets.only(top: calculateOffset()),
        height: height + (widget.hover ? hoverSizeIncrease : 0),
        width: widget.dayWidth + (widget.hover ? hoverSizeIncrease : 0) - 3,
        child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          child: Column(
            children: <Widget>[
              Container(
                height: 3,
                decoration: BoxDecoration(
                    // color: color.med,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(borderRadius),
                        topLeft: Radius.circular(borderRadius))),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      // widget.classBlock.classTime,
                      // style: TextStyle(color: color.med),
                      // ),
                      height > 70
                          ? Text(
                              'test',
                              // widget.classBlock.id,
                              style: TextStyle(
                                  // color: color.med,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      height > 90
                          ? Expanded(
                              child: LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                return Text(
                                  'test',
                                  // widget.classBlock.name,
                                  overflow: TextOverflow.ellipsis,
                                  // style: TextStyle(color: color.med),
                                  maxLines: (constraints.maxHeight /
                                          Theme.of(context)
                                              .textTheme
                                              .body1
                                              .fontSize)
                                      .floor(),
                                );
                              }),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
