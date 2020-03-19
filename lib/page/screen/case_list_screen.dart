import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:selftrackingapp/widgets/case_item.dart';

class CaseListScreen extends StatefulWidget {
  @override
  _CaseListScreenState createState() => _CaseListScreenState();
}

class _CaseListScreenState extends State<CaseListScreen> {
  // int _selectedTab = 0;

  String _searchKey = "";
  List<ReportedCase> _cases = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            snap: true,
            title: Container(
              margin: EdgeInsets.symmetric(horizontal: 6.0),
              height: 36,
              child: TextField(
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: TrackerColors.primaryColor, fontSize: 12.0),
                    labelStyle: TextStyle(color: TrackerColors.primaryColor),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: TrackerColors.primaryColor, width: 1.0),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: TrackerColors.primaryColor,
                    ),
                    hintText: AppLocalizations.of(context)
                        .translate("case_screen_search")),
                onChanged: (value) {
                  setState(() {
                    _searchKey = value;
                  });
                },
              ),
            ),
          ),
          _buildNewestList(context),
        ],
      ),
    );
  }

  // _changeTab(int tab) {
  //   setState(() {
  //     // _selectedTab = tab;
  //   });
  // }

  Widget _buildNewestList(BuildContext context) {
    return FutureBuilder(
      future: GetIt.instance<DataRepository>().fetchCases(
          AppLocalizations.of(context).locale.toString().split("_")[0]),
      builder:
          (BuildContext context, AsyncSnapshot<List<ReportedCase>> snapshot) {
        if (snapshot.hasData) {
          _cases = snapshot.data
              .where((_) => _.locations
                  .where((location) => location.address
                      .toLowerCase()
                      .contains(_searchKey.toLowerCase()))
                  .isNotEmpty)
              .toList();

          return SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return CaseItem(_cases[index]);
            }, childCount: _cases.length),
          );
        }

        return SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
