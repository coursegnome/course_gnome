import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import '../profile/profile_page.dart';
import '../advising/advising_page.dart';
import '../schedules/schedules_page.dart';
import '../scheduling/scheduling_page.dart';

enum Page { Scheduling, Schedules, Advising, Profile }

class BasePage extends StatelessWidget {
  BasePage({
    @required this.page,
    @required this.body,
    this.showDrawer = true,
  });
  final Page page;
  final Widget body;
  final bool showDrawer;

  void _goToProfilePage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
  }

  void _goToSchedulingPage(BuildContext context) {
    Navigator.pop(context);
    if (page == Page.Scheduling) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SchedulingPage()));
  }

  void _goToSchedulesPage(BuildContext context) {
    Navigator.pop(context);
    if (page == Page.Schedules) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SchedulesPage()));
  }

  void _goToAdvisingPage(BuildContext context) {
    Navigator.pop(context);
    if (page == Page.Advising) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => AdvisingPage()));
  }

  String _getTitle() {
    switch (page) {
      case Page.Scheduling:
        return 'Create';
      case Page.Schedules:
        return 'Your Schedules';
      case Page.Advising:
        return 'Advising';
      case Page.Profile:
        return 'Profile';
      default:
        return 'Title';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      drawer: showDrawer
          ? Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: GestureDetector(
                      onTap: () => _goToProfilePage(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/pro-pic.jpeg'),
                              backgroundColor: Theme.of(context).primaryColor,
                              // child: Text(
                              //   'TT',
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .body1
                              //       .copyWith(color: Colors.white),
                              // ),
                              radius: 30.0,
                            ),
                          ),
                          Text(
                            'Timothy Raymond Traversy',
                            style: Theme.of(context).textTheme.title,
                          ),
                          Text('timtraversy@gwu.edu'),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.school),
                    title: DropdownButton(
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (u) {},
                      value: 'gwu',
                      items: [
                        DropdownMenuItem(
                          value: 'gwu',
                          child: Text(
                            'George Washington University',
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.wb_sunny),
                    title: DropdownButton(
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (u) {},
                      value: 'fall2019',
                      items: [
                        DropdownMenuItem(
                          value: 'fall2019',
                          child: Text('Fall 2019'),
                        ),
                        DropdownMenuItem(
                          value: 'spring2019',
                          child: Text('Spring 2019'),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Create'),
                    onTap: () => _goToSchedulingPage(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Your schedules'),
                    onTap: () => _goToSchedulesPage(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.check),
                    title: Text('Advising'),
                    onTap: () => _goToAdvisingPage(context),
                  )
                ],
              ),
            )
          : null,
      body: body,
    );
  }
}
