import 'package:flutter/material.dart';

import 'package:course_gnome/ui/profile/profile_page.dart';
import 'package:course_gnome/ui/advising/advising_page.dart';
import 'package:course_gnome/ui/scheduling/scheduling.dart';

enum Page {
  Create,
  Calendar,
  Search,
  Schedules,
  Advising,
  Profile,
  OfferingDetail
}

class BasePage extends StatelessWidget {
  BasePage({
    @required this.page,
    @required this.body,
    this.showDrawer = true,
    this.actionIcons,
    this.actionCallbacks,
  });
  final Page page;
  final Widget body;
  final bool showDrawer;
  final List<IconData> actionIcons;
  final List<VoidCallback> actionCallbacks;

  void _goToProfilePage(BuildContext context) {
    Navigator.pushNamed(context, '/profile', arguments: 'Hello');
  }

  void _goToSchedulingPage(BuildContext context) {
    Navigator.pop(context);
    if (page == Page.Search || page == Page.Calendar || page == Page.Create) {
      return;
    }
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
      case Page.Create:
        return 'Create';
      case Page.Schedules:
        return 'Your Schedules';
      case Page.Advising:
        return 'Advising';
      case Page.Profile:
        return 'Profile';
      case Page.Calendar:
        return 'Calendar';
      case Page.Search:
        return 'Search';
      case Page.OfferingDetail:
        return 'Offering Detail';
      default:
        return 'Title';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
          title: Text(_getTitle()),
          actions: actionIcons != null
              ? List.generate(actionIcons.length, (i) {
                  return IconButton(
                    icon: Icon(actionIcons[i]),
                    onPressed: actionCallbacks[i],
                  );
                })
              : null),
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
