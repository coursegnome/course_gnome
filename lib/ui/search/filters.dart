import 'package:flutter/material.dart';

import 'package:course_gnome/ui/shared/shared.dart';
import 'package:course_gnome/state/search/search.dart';
import 'package:course_gnome/state/shared/models/course.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  updateStatus({bool active, Status status, Query currentQuery}) {
    List<Status> statuses = List<Status>.from(currentQuery.statuses ?? []);
    if (active) {
      statuses.add(status);
    } else {
      statuses.remove(status);
    }
    BlocProvider.of<SearchBloc>(context).dispatch(
      SearchChanged(Query(statuses: statuses)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    return BlocBuilder(
      bloc: BlocProvider.of<SearchBloc>(context),
      builder: (_, SearchState searchState) => ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Text('Status'),
          FilterCheckbox(
            title: 'Open',
            value: searchState.query.statuses.contains(Status.Open),
            onChanged: (bool active) => updateStatus(
              active: active,
              status: Status.Open,
              currentQuery: searchState.query,
            ),
          ),
          FilterCheckbox(
            title: 'Closed',
            value: searchState.query.statuses.contains(Status.Closed),
            onChanged: (bool active) => updateStatus(
              active: active,
              status: Status.Closed,
              currentQuery: searchState.query,
            ),
          ),
          FilterCheckbox(
            title: 'Waitlist',
            value: searchState.query.statuses.contains(Status.Waitlist),
            onChanged: (bool active) => updateStatus(
              active: active,
              status: Status.Waitlist,
              currentQuery: searchState.query,
            ),
          ),
          Text('Department'),
          Text('Course Number'),
          RangeSlider(
            onChanged: (values) {
              print('h');
              searchBloc.dispatch(SearchChanged(
                Query(
                    minDepartmentNumber: values.start.toInt(),
                    maxDepartmentNumber: values.end.toInt()),
              ));
            },
            inactiveColor: cgRed.withOpacity(0.2),
            values: RangeValues(
              searchState.query.minDepartmentNumber != null
                  ? searchState.query.minDepartmentNumber.toDouble()
                  : 1000,
              searchState.query.maxDepartmentNumber != null
                  ? searchState.query.maxDepartmentNumber.toDouble()
                  : 10000,
            ),
            activeColor: cgRed,
            max: 10000,
            min: 1000,
            divisions: 18,
          ),
          Text('Time'),
          RangeSlider(
            onChanged: (v) {},
            inactiveColor: cgRed.withOpacity(0.2),
            values: RangeValues(1000, 3000),
            activeColor: cgRed,
            max: 10000,
            min: 1000,
            divisions: 18,
          ),
          Text('Days'),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: true,
                    onChanged: (x) {},
                    activeColor: cgRed,
                  ),
                  Text('U')
                ],
              ),
              Column(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: true,
                    onChanged: (x) {},
                    activeColor: cgRed,
                  ),
                  Text('M')
                ],
              ),
              Column(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: true,
                    onChanged: (x) {},
                    activeColor: cgRed,
                  ),
                  Text('T')
                ],
              ),
              Column(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: true,
                    onChanged: (x) {},
                    activeColor: cgRed,
                  ),
                  Text('W')
                ],
              ),
              Column(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: true,
                    onChanged: (x) {},
                    activeColor: cgRed,
                  ),
                  Text('R')
                ],
              ),
              Column(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: true,
                    onChanged: (x) {},
                    activeColor: cgRed,
                  ),
                  Text('F')
                ],
              ),
              Column(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: true,
                    onChanged: (x) {},
                    activeColor: cgRed,
                  ),
                  Text('S')
                ],
              ),
            ],
          )
        ],
      ),
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
