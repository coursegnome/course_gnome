import 'package:flutter/material.dart';

import 'package:course_gnome/ui/shared/shared.dart';
import 'package:course_gnome/state/search/search.dart';
import 'package:course_gnome/state/shared/models/course.dart';
import 'package:course_gnome/state/shared/models/course.dart' as cg;

import 'package:flutter_bloc/flutter_bloc.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int minDepartmentNumber = 1000;
  int maxDepartmentNumber = 10000;

  cg.TimeOfDay earliestStartTime = cg.TimeOfDay.min;
  cg.TimeOfDay latestEndTime = cg.TimeOfDay.max;

  RangeLabels _getCourseNumberLabel() => RangeLabels(
      minDepartmentNumber.toString(), maxDepartmentNumber.toString());

  RangeLabels _getTimeLabel() =>
      RangeLabels(earliestStartTime.toString(), latestEndTime.toString());

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    return BlocBuilder(
        bloc: BlocProvider.of<SearchBloc>(context),
        builder: (_, SearchState searchState) {
          final Query query = searchState.query;
          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              FilterSection(
                title: 'Status',
                children: <Widget>[
                  StatusCheckbox(
                      searchBloc: searchBloc,
                      status: Status.Open,
                      query: query),
                  StatusCheckbox(
                      searchBloc: searchBloc,
                      status: Status.Closed,
                      query: query),
                  StatusCheckbox(
                      searchBloc: searchBloc,
                      status: Status.Waitlist,
                      query: query),
                ],
              ),
              FilterSection(
                title: 'Course Number',
                children: <Widget>[
                  RangeSlider(
                    labels: _getCourseNumberLabel(),
                    onChanged: (values) {
                      setState(() {
                        minDepartmentNumber = values.start.toInt();
                        maxDepartmentNumber = values.end.toInt();
                      });
                      searchBloc.dispatch(SearchChanged(
                        Query(
                            minDepartmentNumber: values.start.toInt(),
                            maxDepartmentNumber: values.end.toInt()),
                      ));
                    },
                    inactiveColor: cgRed.withOpacity(0.2),
                    values: RangeValues(
                      minDepartmentNumber.toDouble(),
                      maxDepartmentNumber.toDouble(),
                    ),
                    activeColor: cgRed,
                    min: 1000,
                    max: 10000,
                    divisions: 18,
                  ),
                ],
              ),
              FilterSection(
                title: 'Time',
                children: <Widget>[
                  RangeSlider(
                    labels: _getTimeLabel(),
                    onChanged: (v) {
                      setState(() {
                        earliestStartTime =
                            cg.TimeOfDay.fromTimestamp(v.start.toInt());
                        latestEndTime =
                            cg.TimeOfDay.fromTimestamp(v.end.toInt());
                      });
                      searchBloc.dispatch(SearchChanged(Query(
                        earliestStartTime:
                            cg.TimeOfDay.fromTimestamp(v.start.toInt()),
                        latestEndTime:
                            cg.TimeOfDay.fromTimestamp(v.end.toInt()),
                      )));
                    },
                    inactiveColor: cgRed.withOpacity(0.2),
                    values: RangeValues(
                      earliestStartTime.timestamp.toDouble(),
                      latestEndTime.timestamp.toDouble(),
                    ),
                    activeColor: cgRed,
                    max: cg.TimeOfDay.max.timestamp.toDouble(),
                    min: cg.TimeOfDay.min.timestamp.toDouble(),
                    divisions: cg.TimeOfDay.max.hour - cg.TimeOfDay.min.hour,
                  ),
                ],
              ),
              Text('Days'),
              Row(
                children: List.generate(
                    7,
                    (i) => DayCheckbox(
                          day: i,
                          searchBloc: searchBloc,
                          query: query,
                        )),
              )
            ],
          );
        });
  }
}

class FilterSection extends StatelessWidget {
  FilterSection({this.title, this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[Text(title)].followedBy(children).toList(),
    );
  }
}

class StatusCheckbox extends StatelessWidget {
  StatusCheckbox({this.searchBloc, this.query, this.status});

  final SearchBloc searchBloc;
  final Query query;
  final Status status;

  updateStatus(bool active) {
    List<Status> statuses = List<Status>.from(query.statuses ?? []);
    active ? statuses.add(status) : statuses.remove(status);
    searchBloc.dispatch(SearchChanged(Query(statuses: statuses)));
  }

  @override
  Widget build(BuildContext context) {
    return FilterCheckbox(
      title: status.toString().split('.').last,
      value: query.statuses.contains(status),
      onChanged: (bool active) => updateStatus(active),
    );
  }
}

class DayCheckbox extends StatelessWidget {
  const DayCheckbox({Key key, this.day, this.query, this.searchBloc})
      : super(key: key);
  final int day;
  final Query query;
  final SearchBloc searchBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: query.days[day],
          onChanged: (val) => searchBloc.dispatch(SearchChanged(Query(
            u: day == 0 ? val : null,
            m: day == 1 ? val : null,
            t: day == 2 ? val : null,
            w: day == 3 ? val : null,
            r: day == 4 ? val : null,
            f: day == 5 ? val : null,
            s: day == 6 ? val : null,
          ))),
          activeColor: cgRed,
        ),
        Text(Query.dayStrings[day].toUpperCase()),
      ],
    );
  }
}

class FilterCheckbox extends StatelessWidget {
  FilterCheckbox({this.title, this.value, this.onChanged});
  final String title;
  final bool value;
  final Function(bool) onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: value,
          onChanged: onChanged,
          activeColor: cgRed,
        ),
        Text(title),
      ],
    );
  }
}
