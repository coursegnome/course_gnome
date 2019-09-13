import 'package:course_gnome/state/search/search.dart';
import 'package:course_gnome/state/shared/models/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:course_gnome/ui/shared/shared.dart';
import 'package:course_gnome/ui/search/search.dart';

class SearchPage extends StatefulWidget {
  SearchPage({this.filtersAreOpen, this.filtersToggled});
  final bool filtersAreOpen;
  final VoidCallback filtersToggled;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchRepository searchRepository = SearchRepository();
  final ScrollController resultsScrollController = ScrollController();
  bool loadingMore = false;

  void overscrolled() async {
    setState(() => loadingMore = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() => loadingMore = false);
  }

  @override
  void initState() {
    super.initState();
    resultsScrollController.addListener(() {
      if (resultsScrollController.offset >
          resultsScrollController.position.maxScrollExtent + 100) {
        overscrolled();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (BuildContext context) =>
          SearchBloc(searchRepository: searchRepository),
      child: Column(
        children: <Widget>[
          SearchField(
            filtersAreOpen: widget.filtersAreOpen,
            filtersToggled: widget.filtersToggled,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                widget.filtersAreOpen
                    ? Expanded(child: Filters(), flex: 2)
                    : Container(),
                Expanded(
                  child: Results(
                    scrollController: resultsScrollController,
                    loadingMore: loadingMore,
                  ),
                  flex: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  SearchField({this.filtersAreOpen, this.filtersToggled});
  final bool filtersAreOpen;
  final VoidCallback filtersToggled;
  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final bool detatched = MediaQuery.of(context).size.width > sm;
    return Padding(
      padding: EdgeInsets.all(detatched ? 10.0 : 0.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            child: Text(filtersAreOpen ? 'Hide' : 'Filter'),
            onPressed: filtersToggled,
            textColor: cgRed,
          ),
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
                  borderRadius:
                      BorderRadius.all(Radius.circular(detatched ? 10 : 0)),
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
  Results({this.scrollController, this.loadingMore});

  final ScrollController scrollController;
  final bool loadingMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (_, searchState) {
          if (searchState is SearchLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(cgRed),
                strokeWidth: 5,
              ),
            );
          }
          if (searchState is SearchError) {
            return Text('An error occured');
          }
          if (searchState is SearchSuccess) {
            List<Widget> listChildren() {
              final List<Widget> list = List.generate(
                searchState.searchResult.courses.length,
                (i) => Theme(
                  data: Theme.of(context).copyWith(
                      textTheme: Theme.of(context).textTheme.apply(
                          bodyColor:
                              scheduleColors[i % scheduleColors.length])),
                  child: CourseCard(
                    searchState.searchResult.courses[i],
                  ),
                ),
              );
              list.add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Load More'),
                  loadingMore
                      ? Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.black87),
                          ),
                          width: 15,
                          height: 15,
                        )
                      : Icon(Icons.arrow_downward),
                ],
              ));
              return list;
            }

            return searchState.searchResult.courses.isEmpty
                ? Text('No results!')
                : ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    padding: const EdgeInsets.all(15.0),
                    children: listChildren(),
                  );
          }
          // empty
          return Text('Please enter a search term or select a filter');
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  CourseCard(this.courses);
  final List<Offering> courses;

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
          margin: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  (j) => ExpansionTile(
                    title: OfferingRow(courses[j]),
                    // color: currentCalendar.ids.contains(offering.offerings[j].id)
                    //     ? color.med.withOpacity(0.1)
                    //     : Colors.transparent,
                    // child: ExpansionTile(
                    // key: PageStorageKey<String>(offering.offerings[j].id),
                    // onLongPress: () {
                    //   HapticFeedback.selectionClick();
                    //   toggleOffering(
                    //       offering, offering.offerings[j], color.toTriColor());
                    // },
                    // title: GestureDetector(
                    // child: OfferingRow(color.med, offering.offerings[j]),
                    // ),
                    // children: [
                    // ExtraInfoContainer(color, offering.offerings[j], offering)
                    // ],
                    // ),
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

class OfferingRow extends StatelessWidget {
  final Offering offering;

  OfferingRow(this.offering);

  @override
  Widget build(BuildContext context) {
    final spaceAllowance = allowance(MediaQuery.of(context).size.width);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
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
              offering.teachers != null ? offering.teachers.join(', ') : 'TBA',
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

// class ExtraInfoContainer extends StatelessWidget {
