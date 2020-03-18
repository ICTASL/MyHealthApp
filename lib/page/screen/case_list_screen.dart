import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/widgets/case_item.dart';

class CaseListScreen extends StatefulWidget {
  @override
  _CaseListScreenState createState() => _CaseListScreenState();
}

class _CaseListScreenState extends State<CaseListScreen> {
  // int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: <Widget>[
      //     Container(
      //       color: Colors.black26,
      //       height: 1.0,
      //     ),
      //     Material(
      //       elevation: 12.0,
      //       child: Container(
      //         child: Row(
      //           children: <Widget>[
      //             Expanded(
      //               child: InkWell(
      //                 child: Container(
      //                   margin: EdgeInsets.only(top: 16.0),
      //                   child: Column(
      //                     children: <Widget>[
      //                       Text("NEWEST"),
      //                       SizedBox(height: 16.0),
      //                       _selectedTab == 0
      //                       ? Container(
      //                           height: 4.0,
      //                           decoration: BoxDecoration(
      //                               gradient: LinearGradient(colors: [
      //                             Color(0xff4a00e0),
      //                             Color(0xff0cebeb)
      //                           ])),
      //                         )
      //                       : Container()
      //                     ],
      //                   ),
      //                 ),
      //                 onTap: () => _changeTab(0),
      //               ),
      //             ),
      //             Container(
      //               color: Colors.black26,
      //               height: 52,
      //               width: 1.0,
      //             ),
      //             Expanded(
      //               child: InkWell(
      //                 child: Container(
      //                   margin: EdgeInsets.only(top: 16.0),
      //                   child: Column(
      //                     children: <Widget>[
      //                       Text("TESTED"),
      //                       SizedBox(height: 16.0),
      //                       _selectedTab == 1
      //                           ? Container(
      //                               height: 4.0,
      //                               decoration: BoxDecoration(
      //                                   gradient: LinearGradient(colors: [
      //                                 Color(0xff4a00e0),
      //                                 Color(0xff0cebeb)
      //                               ])),
      //                             )
      //                           : Container()
      //                     ],
      //                   ),
      //                 ),
      //                 onTap: () => _changeTab(1),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Stack(
      //         children: <Widget>[
      //           Container(
      //             color: Color(0xffeceff1),
      //           ),
      //           _selectedTab == 0 ? _buildNewestList() : _buildTestedList(),
      //         ],
      //       ),
      //     )
      //   ],
      // ),
      child: _buildNewestList(context),
    );
  }

  _changeTab(int tab) {
    setState(() {
      // _selectedTab = tab;
    });
  }

  Widget _buildNewestList(BuildContext context) {
    // return Text(AppLocalizations.of(context).locale.toString());

    return FutureBuilder(
      future: GetIt.instance<DataRepository>().fetchCases(
          AppLocalizations.of(context).locale.toString().split("_")[0]),
      builder:
          (BuildContext context, AsyncSnapshot<List<ReportedCase>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return CaseItem(snapshot.data[index]);
              });
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // _buildTestedList() {
  //   return Container();
  // }
}
