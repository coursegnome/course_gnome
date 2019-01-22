import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:course_gnome/model/Calendar.dart';

import 'package:course_gnome_mobile/utilities/UtilitiesClasses.dart';

class CalendarPage extends StatefulWidget {
  final Calendars _calendars;
  final TextEditingController _calendarNameController;
  final TabController _tabController;
  final Function _removeOffering;
  final bool _inSplitView;
  final VoidCallback _addCalendar,
      _editCalendar,
      _deleteCalendar,
      _toggleActivePage;

  CalendarPage(
    this._calendars,
    this._calendarNameController,
    this._tabController,
    this._addCalendar,
    this._editCalendar,
    this._deleteCalendar,
    this._removeOffering,
    this._inSplitView,
    this._toggleActivePage,
  );

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const hourCount = 17;
  static const startHour = 7;
  static const dayCount = 7;
  var hourHeight = 100.0;
  var dayWidth = 100.0;

  ScrollController hourController;
  ScrollController dayController;
  ScrollController horizontalCalController;
  ScrollController verticalCalController;

  Timer timer;

  _calHorizontallyScrolled() {
//    print('x');
//    timer.cancel();
//    print('y');
//
//    timer = Timer(Duration(milliseconds: 200), _roundHorizontalScroll);
    dayController.jumpTo(horizontalCalController.offset);
//    print(horizontalCalController.offset);
  }

  _roundHorizontalScroll() {
    print('rounding');
  }

  _calVerticallyScrolled() {
    hourController.jumpTo(verticalCalController.offset);
  }

//  scaleStart(ScaleStartDetails details) {}
//  scaleUpdate(ScaleUpdateDetails details) {}
//  scaleEnd(ScaleEndDetails details) {}

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
    return TextField(
      autofocus: true,
      controller: widget._calendarNameController,
      textCapitalization: TextCapitalization.words,
      onSubmitted: (text) => widget._addCalendar(),
      maxLength: 20,
      maxLengthEnforced: true,
      style: Theme.of(context).textTheme.headline,
      decoration: InputDecoration(
        suffixIcon: widget._calendarNameController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    widget._calendarNameController.clear();
                  });
                },
              )
            : Container(),
      ),
    );
  }

  _showAddCalendarDialog() {
    _showDialog(
      'Add Calendar',
      _textField(),
      'Add',
      'Cancel',
      widget._addCalendar,
      () => Navigator.pop(context),
    );
  }

  _showEditCalendarDialog() {
    widget._calendarNameController.text =
        widget._calendars.list[widget._calendars.currentCalendarIndex].name;
    _showDialog(
      'Edit Calendar',
      _textField(),
      'Save',
      'Cancel',
      widget._editCalendar,
      () {
        widget._calendarNameController.clear();
        Navigator.pop(context);
      },
    );
  }

  _showDeleteCalendarDialog() {
    _showDialog(
      'Delete Calendar',
      Text('Delete calendar ' +
          widget._calendars.list[widget._calendars.currentCalendarIndex].name +
          '?'),
      'Delete',
      'Cancel',
      widget._deleteCalendar,
      () => Navigator.pop(context),
    );
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

  Color caughtColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Calendar'),
        leading: !widget._inSplitView
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: widget._toggleActivePage)
            : null,
        actions: [
          IconButton(
              icon: Icon(Icons.playlist_add),
              onPressed: () => _showAddCalendarDialog()),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _showEditCalendarDialog()),
          widget._calendars.list.length > 1
              ? IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () => _showDeleteCalendarDialog())
              : Container(),
        ],
        bottom: TabBar(
          controller: widget._tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: List.generate(
            widget._calendars.list.length,
            (i) => Tab(text: widget._calendars.list[i].name),
          ),
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: widget._tabController,
        children: List.generate(
          widget._calendars.list.length,
          (i) => Column(
                children: <Widget>[
                  DayList(dayCount, dayWidth, dayController),
                  Expanded(
                    child: SafeArea(
                      right: false,
                      child: Row(
                        children: <Widget>[
                          HourList(
                              hourCount, startHour, hourHeight, hourController),
                          CalendarView(
                              dayCount,
                              hourCount,
                              startHour,
                              dayWidth,
                              hourHeight,
                              horizontalCalController,
                              verticalCalController,
                              widget._calendars.list[i],
                              widget._removeOffering),
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

class CalendarView extends StatefulWidget {
  final int dayCount, hourCount, startHour;
  final double dayWidth, hourHeight;
  final ScrollController horizontalCalController, verticalCalController;
  final Calendar calendar;
  final Function removeOffering;

  CalendarView(
      this.dayCount,
      this.hourCount,
      this.startHour,
      this.dayWidth,
      this.hourHeight,
      this.horizontalCalController,
      this.verticalCalController,
      this.calendar,
      this.removeOffering);

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
//            onScaleStart: (details) => scaleStart(details),
//            onScaleUpdate: (details) => scaleUpdate(details),
//            onScaleEnd: (details) => scaleEnd(details),
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
                              widget.calendar.blocksByDay[i].length != 0
                                  ? Stack(
                                      children: List.generate(
                                        widget.calendar.blocksByDay[i].length,
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
                                                  widget.calendar.blocksByDay[i]
                                                      [k],
                                                ),
                                                feedback: ClassBlockWidget(
                                                  true,
                                                  widget.startHour,
                                                  widget.dayWidth,
                                                  widget.hourHeight,
                                                  widget.calendar.blocksByDay[i]
                                                      [k],
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
                                                  widget.removeOffering(widget
                                                      .calendar
                                                      .blocksByDay[i][k]
                                                      .id);
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
                                accepted.length > 0
                                    ? Icons.delete_outline
                                    : Icons.delete,
                                size: accepted.length > 0 ? 50 : 40),
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
                  child: Text(
                    dayStrings[i],
                  ),
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
  final ClassBlock classBlock;

  ClassBlockWidget(this.hover, this.startHour, this.dayWidth, this.hourHeight,
      this.classBlock);

  @override
  _ClassBlockWidgetState createState() => _ClassBlockWidgetState();
}

class _ClassBlockWidgetState extends State<ClassBlockWidget> {
  static const heightBreakpoint = 1;
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
    final color = FlutterTriColor(widget.classBlock.color);
    print(widget.classBlock.color.light);
    print(FlutterTriColor(widget.classBlock.color).light);
    return Opacity(
      opacity: widget.hover ? 0.5 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: color.light.withOpacity(0.75),
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
                    color: color.med,
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
                      Text(
                        widget.classBlock.departmentInfo,
                        style: TextStyle(color: color.med),
                      ),
                      Text(
                        widget.classBlock.id,
                        style: TextStyle(
                            color: color.med,
                            fontWeight: FontWeight.bold),
                      ),
                      height > heightBreakpoint * widget.hourHeight
                          ? Text(
                              widget.classBlock.name,
                              style:
                                  TextStyle(color:color.med),
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
