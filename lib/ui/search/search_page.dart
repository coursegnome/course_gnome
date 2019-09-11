import 'package:course_gnome/state/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:course_gnome/ui/shared/shared.dart';
import 'package:course_gnome/ui/scheduling/scheduling.dart';
import 'package:course_gnome/ui/search/search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const EdgeInsets _padding = EdgeInsets.all(15.0);
  final SearchRepository searchRepository = SearchRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (_) => SearchBloc(searchRepository: searchRepository),
      child: Row(
        children: <Widget>[
          Expanded(child: Filters(), flex: 1),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: <Widget>[_searchField(), _filterButtons()],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    ListView(
                      padding: _padding,
                      children: <Widget>[Text('hello'), Text('eha')],
                      shrinkWrap: true,
                    ),
                    // Container(
                    //   margin: _padding.copyWith(right: 80),
                    //   height: 300,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(5)),
                    //   child: ListView(
                    //     shrinkWrap: true,
                    //     children: List.generate(departments.entries.length, (i) {
                    //       return CheckboxListTile(
                    //         value: false,
                    //         title: Text(departments.entries.toList()[i].value),
                    //         onChanged: (x) {},
                    //         dense: true,
                    //         controlAffinity: ListTileControlAffinity.leading,
                    //       );
                    //     }),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
