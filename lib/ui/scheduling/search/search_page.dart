import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../../shared/shared.dart';
import '../calendar/calendar_page.dart';

class SearchPage extends StatefulWidget {
  SearchPage({@required this.singleColumn});
  final bool singleColumn;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const EdgeInsets _padding = const EdgeInsets.all(15.0);

  _goToCalendar() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => CalendarPage(singleColumn: true)));
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      page: Page.Search,
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                _searchField(),
                _filterButtons(),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              ListView(
                padding: _padding,
                children: <Widget>[Text('hello'), Text('eha')],
                shrinkWrap: true,
              ),
              Container(
                margin: _padding.copyWith(right: 80),
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: ListView(
                  shrinkWrap: true,
                  children: List.generate(departments.entries.length, (i) {
                    return CheckboxListTile(
                      value: false,
                      title: Text(departments.entries.toList()[i].value),
                      onChanged: (x) {},
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
      actionIcons: [Icons.filter_list, Icons.calendar_today],
      actionCallbacks: [
        () {},
        _goToCalendar,
      ],
    );
  }

  TextField _searchField() {
    return TextField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.search),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  Container _filterButtons() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.25))),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: MaterialButton(
              padding: EdgeInsets.all(4.0),
              child: Column(
                children: <Widget>[
                  Text('Any department'),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: MaterialButton(
              padding: EdgeInsets.all(4.0),
              child: Column(
                children: <Widget>[
                  Text('Any status'),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
              onPressed: () {},
            ),
          ),
          // Expanded(
          //   child: MaterialButton(
          //     child: Column(
          //       children: <Widget>[
          //         Text('Any status'),
          //         Icon(Icons.keyboard_arrow_down),
          //       ],
          //     ),
          //     onPressed: () {},
          //   ),
          // )
        ],
      ),
    );
  }
}
