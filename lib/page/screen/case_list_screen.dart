import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/notifiers/registered_cases_model.dart';
import 'package:selftrackingapp/page/screen/user_register_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:selftrackingapp/widgets/case_item.dart';

class CaseListScreen extends StatefulWidget {
  @override
  _CaseListScreenState createState() => _CaseListScreenState();
}

class _CaseListScreenState extends State<CaseListScreen> {
  String _searchKey = "";
  List<ReportedCase> _cases = [];
  final AsyncMemoizer<List<ReportedCase>> _memoizer = AsyncMemoizer();

  _fetchCases() {
    return _memoizer.runOnce(() async {
      return await GetIt.instance<DataRepository>().fetchCases(
          AppLocalizations.of(context).locale.toString().split("_")[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<RegisteredCasesModel>(context).reportedCases.length);
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            snap: true,
            expandedHeight: 100.0,
            flexibleSpace: Container(
              margin: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: TrackerColors.primaryColor),
                  labelText: AppLocalizations.of(context)
                      .translate("case_screen_search"),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: TrackerColors.primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: TrackerColors.primaryColor, width: 1.0),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: TrackerColors.primaryColor,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchKey = value;
                  });
                },
              ),
            ),
          ),
          Provider.of<RegisteredCasesModel>(context).reportedCases.length > 0
              ? SliverAppBar(
                  backgroundColor: Colors.white,
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(10.0),
                    child: Text(''), // Add this code
                  ),
                  flexibleSpace: Container(
                      child: Center(
                          child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            Provider.of<RegisteredCasesModel>(context,
                                    listen: false)
                                .reportedCases
                                .clear();
                          });
                        },
                        child: Text("Remove all"),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        color: TrackerColors.primaryColor,
                        onPressed: () {
                          RegisteredCasesModel model =
                              Provider.of<RegisteredCasesModel>(context,
                                  listen: false);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: model,
                              child: UserRegisterScreen(),
                            ),
                          ));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "See Added (${Provider.of<RegisteredCasesModel>(context).reportedCases.length})",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ))),
                )
              : SliverToBoxAdapter(
                  child: Container(),
                ),
          FutureBuilder(
            future: _fetchCases(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ReportedCase>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return SliverToBoxAdapter(
                    child: Center(
                        child:
                            Text("Error getting the cases, try again later.")),
                  );
                  break;
                case ConnectionState.waiting:
                  return SliverToBoxAdapter(
                    child: Container(
                        child: Center(child: CircularProgressIndicator()),
                        padding: const EdgeInsets.all(30.0)),
                  );
                  break;
                case ConnectionState.active:
                  return SliverToBoxAdapter(
                    child: Center(
                        child:
                            Text("Error getting the cases, try again later.")),
                  );
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    _cases = snapshot.data
                        .where((_) => _.locations
                            .where((location) => location.address
                                .toLowerCase()
                                .contains(_searchKey.toLowerCase()))
                            .isNotEmpty)
                        .toList();
                    if (_cases.length > 0) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return CaseItem(_cases[index]);
                        }, childCount: _cases.length),
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(child: Text("No cases found there.")),
                        ),
                      );
                    }
                  } else {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                            child: Text("No cases found for that search.")),
                      ),
                    );
                  }
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  // _changeTab(int tab) {
  //   setState(() {
  //     // _selectedTab = tab;
  //   });
  // }
}
