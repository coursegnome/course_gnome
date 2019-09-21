import 'package:course_gnome/state/scheduling/models/schedule.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:course_gnome_data/models.dart';

import 'package:course_gnome/ui/shared/shared.dart';
import 'package:course_gnome/ui/search/search.dart';
import 'package:course_gnome/state/search/search.dart';
import 'package:course_gnome/ui/shared/breakpoints.dart' as breakpoints;

class SearchPage extends StatefulWidget {
  SearchPage({@required this.filtersAreOpen, @required this.filtersToggled});
  final bool filtersAreOpen;
  final VoidCallback filtersToggled;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchRepository searchRepository = SearchRepository();
  final ScrollController resultsScrollController = ScrollController();
  bool loadingMore = false;

  @override
  void initState() {
    super.initState();
    resultsScrollController.addListener(() {
      if (resultsScrollController.offset >
          resultsScrollController.position.maxScrollExtent - 600) {}
    });
  }

  String _resultsText(SearchState searchState) {
    if (searchState is SearchSuccess) {
      return '${searchState.searchResult.totalCount} Results';
    }
    if (searchState is SearchLoading || searchState is LoadMoreLoading) {
      return 'Loading';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Navigator(
      initialRoute: 'create/results',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case ('create/results'):
            builder = (BuildContext _) => BlocProvider(
                  builder: (BuildContext context) =>
                      SearchBloc(searchRepository: searchRepository),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SearchField(
                          filtersAreOpen: widget.filtersAreOpen,
                          filtersToggled: widget.filtersToggled,
                        ),
                        BlocBuilder<SearchBloc, SearchState>(
                            builder: (_, searchState) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _resultsText(searchState),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      searchState is SearchLoading ||
                                              searchState is LoadMoreLoading
                                          ? Container(
                                              width: 13,
                                              height: 13,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.black87),
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                searchState is! SearchEmpty
                                    ? FlatButton(
                                        child: Text('RESET FILTERS'),
                                        onPressed: () {},
                                      )
                                    : Container()
                              ],
                            ),
                          );
                        }),
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  widget.filtersAreOpen
                                      ? Expanded(child: Filters(), flex: 10)
                                      : Container(),
                                  !widget.filtersAreOpen ||
                                          width > breakpoints.sm
                                      ? Expanded(
                                          child: Results(
                                            scrollController:
                                                resultsScrollController,
                                            loadingMore: loadingMore,
                                            filtersToggled:
                                                widget.filtersToggled,
                                          ),
                                          flex: 3,
                                        )
                                      : Container(),
                                ],
                              ),
                              kIsWeb ||
                                      MediaQuery.of(context).size.width >
                                          breakpoints.sm
                                  ? Container()
                                  : Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: SafeArea(
                                        child: Container(
                                          margin: EdgeInsets.all(20.0),
                                          child: FloatingActionButton(
                                            onPressed: widget.filtersToggled,
                                            backgroundColor: cgRed,
                                            foregroundColor: Colors.white,
                                            child: Icon(
                                              widget.filtersAreOpen
                                                  ? Icons.done
                                                  : Icons.filter_list,
                                              // Icons.filter
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            break;
          case ('search/offeringDetail'):
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class SearchField extends StatelessWidget {
  SearchField({this.filtersAreOpen, this.filtersToggled});
  final bool filtersAreOpen;
  final VoidCallback filtersToggled;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final bool detatched = MediaQuery.of(context).size.width > sm;
    return Padding(
      padding: EdgeInsets.all(detatched ? 10.0 : 0.0),
      child: Row(
        children: <Widget>[
          width > breakpoints.sm
              ? FlatButton(
                  child: Text(filtersAreOpen ? 'Hide' : 'Filter'),
                  onPressed: filtersToggled,
                  textColor: cgRed,
                )
              : Container(),
          Expanded(
            child: TextField(
              onChanged: (text) {
                searchBloc.dispatch(SearchChanged(Query(text: text)));
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
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
            ),
          ),
        ],
      ),
    );
  }
}

class Results extends StatelessWidget {
  Results({this.scrollController, this.loadingMore, this.filtersToggled});

  final ScrollController scrollController;
  final bool loadingMore;
  final VoidCallback filtersToggled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (_, searchState) {
        if (searchState is SearchLoading) {
          return Container();
        }
        if (searchState is SearchError) {
          return Container();
        }
        if (searchState is SearchSuccess) {
          List<Widget> listChildren() {
            final List<Widget> list =
                List.generate(searchState.searchResult.courses.length, (i) {
              return Hero(
                transitionOnUserGestures: true,
                tag: searchState.searchResult.courses[i].first.id,
                child: Theme(
                  data: Theme.of(context).copyWith(
                      textTheme: Theme.of(context).textTheme.apply(
                          bodyColor:
                              scheduleColors[i % scheduleColors.length])),
                  child: CourseCard(
                    courses: searchState.searchResult.courses[i],
                  ),
                ),
              );
            });

            list.add(
              Container(height: 80),
            );
            return list;
          }

          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            children: listChildren(),
          );
        }
        // empty
        return Container();
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  CourseCard({this.courses, this.extraInfo});
  final List<Offering> courses;
  final Widget extraInfo;

  @override
  Widget build(BuildContext context) {
    final Offering course = courses.first;
    return SafeArea(
      bottom: false,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
                color: Theme.of(context).textTheme.body1.color, width: 4),
          ),
        ),
        child: Card(
          // elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          margin: EdgeInsets.all(0.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${course.deptAcr} ${course.deptNum}'),
                          Text(
                            course.credit == '0'
                                ? course.credit + ' credit'
                                : course.credit + ' credits',
                          ),
                        ],
                      ),
                      Text(course.name,
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Column(
                  children: List.generate(
                    courses.length,
                    (j) => Container(
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: lightGray)),
                      ),
                      child: OfferingRow(
                        offering: courses[j],
                        expanded: extraInfo != null,
                      ),
                    ),
                  ),
                ),
                extraInfo ?? Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OfferingRow extends StatelessWidget {
  OfferingRow({this.offering, this.expanded});
  final Offering offering;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    // final spaceAllowance = allowance(MediaQuery.of(context).size.width);
    return MouseRegion(
      // onEnter: (_) => print('Enter'),
      child: Padding(
        padding: const EdgeInsets.only(
            right: 5.0, left: 5.0, top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                offering.section,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  offering.teachers != null
                      ? offering.teachers.join(', ')
                      : 'TBA',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  offering.classTimes.length,
                  (k) => ClassTimeRow(offering.classTimes[k]),
                ),
              ),
            ),
            offering.id != null
                ? Expanded(
                    flex: 2,
                    child: Text(
                      offering.id,
                      textAlign: TextAlign.right,
                    ),
                  )
                : Container(),
            InkWell(
              onTap: () => expanded
                  ? Navigator.of(context).pop()
                  : Navigator.of(context).pushNamed(
                      'create/offeringDetail',
                      arguments: ColoredOffering(
                        color: Theme.of(context).textTheme.body1.color,
                        offering: offering,
                      ),
                    ),
              customBorder: CircleBorder(),
              child: Icon(
                expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Theme.of(context).textTheme.body1.color,
                size: 30.0,
              ),
            ),
          ],
        ),
      ),
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

  ClassTimeRow(this.classTime);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        false
            // classTime.location != null
            ? Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  classTime.location,
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
                    ? Theme.of(context).textTheme.body1.color
                    : Colors.transparent,
                border: Border.all(
                    color: Theme.of(context).textTheme.body1.color, width: 1),
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
          ),
        )
      ],
    );
  }

  bool _dayIsIncluded(ClassTime ct, int i) {
    switch (i) {
      case 0:
        return ct.m == true;
      case 1:
        return ct.t == true;
      case 2:
        return ct.w == true;
      case 3:
        return ct.r == true;
      case 4:
        return ct.f == true;
      default:
        return true;
    }
  }
}
