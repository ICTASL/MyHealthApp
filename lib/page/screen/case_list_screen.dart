// import 'package:async/async.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:selftrackingapp/app_localizations.dart';
// import 'package:selftrackingapp/models/reported_case.dart';
// import 'package:selftrackingapp/networking/api_client.dart';
// import 'package:selftrackingapp/notifiers/registered_cases_model.dart';
// import 'package:selftrackingapp/page/screen/user_register_screen.dart';
// import 'package:selftrackingapp/utils/tracker_colors.dart';
// import 'package:selftrackingapp/widgets/case_item.dart';
// import 'package:selftrackingapp/widgets/custom_text.dart';

// class CaseListScreen extends StatefulWidget {
//   @override
//   _CaseListScreenState createState() => _CaseListScreenState();
// }

// class _CaseListScreenState extends State<CaseListScreen> {
//   String _searchKey = "";
//   final AsyncMemoizer<List<ReportedCase>> _memorizer = AsyncMemoizer();

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<List<ReportedCase>> _fetchCases() async {
//     return this._memorizer.runOnce(() async {
//       List<ReportedCase> _cases = [];
//       int id = await ApiClient().getLastCaseId();
//       if (id == -1) {
//         return _cases;
//       }
//       for (int i = id; i > 0; i--) {
//         ReportedCase reportedCase =
//             await ApiClient().getCase(i, forceUpdate: false);
//         if (reportedCase != null) _cases.add(reportedCase);
//       }
//       print("Cases found Retreived: ${_cases.length}");
//       return _cases;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(Provider.of<RegisteredCasesModel>(context).reportedCases.length);
//     return Container(
//       child: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             backgroundColor: Colors.white,
//             floating: true,
//             snap: true,
//             expandedHeight: 100.0,
//             flexibleSpace: Container(
//               margin: const EdgeInsets.all(20.0),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   labelStyle: TextStyle(color: TrackerColors.primaryColor),
//                   labelText: AppLocalizations.of(context)
//                       .translate("case_list_screen_search"),
//                   border: OutlineInputBorder(),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                     borderSide: BorderSide(
//                       color: TrackerColors.primaryColor,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: TrackerColors.primaryColor, width: 1.0),
//                   ),
//                   suffixIcon: Icon(
//                     Icons.search,
//                     color: TrackerColors.primaryColor,
//                   ),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _searchKey = value;
//                   });
//                 },
//               ),
//             ),
//           ),
//           Provider.of<RegisteredCasesModel>(context).reportedCases.length > 0
//               ? SliverAppBar(
//                   backgroundColor: Colors.white,
//                   pinned: true,
//                   bottom: PreferredSize(
//                     preferredSize: Size.fromHeight(10.0),
//                     child: Text(''), // Add this code
//                   ),
//                   flexibleSpace: Container(
//                       child: Center(
//                           child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     mainAxisSize: MainAxisSize.max,
//                     children: <Widget>[
//                       FlatButton(
//                         onPressed: () {
//                           setState(() {
//                             Provider.of<RegisteredCasesModel>(context,
//                                     listen: false)
//                                 .reportedCases
//                                 .clear();
//                           });
//                         },
//                         child: Text(AppLocalizations.of(context)
//                             .translate('case_list_screen_remove_text')),
//                       ),
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(20.0))),
//                         color: TrackerColors.primaryColor,
//                         onPressed: () {
//                           RegisteredCasesModel model =
//                               Provider.of<RegisteredCasesModel>(context,
//                                   listen: false);

//                           Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => ChangeNotifierProvider.value(
//                               value: model,
//                               child: UserRegisterScreen(),
//                             ),
//                           ));
//                         },
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 AppLocalizations.of(context)
//                                         .translate("cse_list_screen_see-text") +
//                                     "(${Provider.of<RegisteredCasesModel>(context).reportedCases.length})",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                             ),
//                             Icon(Icons.keyboard_arrow_right,
//                                 color: Colors.white),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ))),
//                 )
//               : SliverToBoxAdapter(
//                   child: Container(),
//                 ),
//           FutureBuilder<List<ReportedCase>>(
//             future: _fetchCases(),
//             builder: (BuildContext context,
//                 AsyncSnapshot<List<ReportedCase>> snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.none:
//                   return SliverToBoxAdapter(
//                     child: Center(
//                         child:
//                             Text("Error getting the cases, try again later.")),
//                   );
//                   break;
//                 case ConnectionState.waiting:
//                   return SliverToBoxAdapter(
//                     child: Container(
//                         child: Center(child: CircularProgressIndicator()),
//                         padding: const EdgeInsets.all(30.0)),
//                   );
//                   break;
//                 case ConnectionState.active:
//                   return SliverToBoxAdapter(
//                     child: Center(
//                         child:
//                             Text("Error getting the cases, try again later.")),
//                   );
//                   break;
//                 case ConnectionState.done:
//                   // print('DATA: ${snapshot.data}');
//                   if (snapshot.hasData) {
//                     List<ReportedCase> _cases = List();
//                     print("Error here ${snapshot.data}");
//                     if (snapshot.data != null)
//                       _cases = snapshot.data
//                           .where((_) => _.locations
//                               .where((location) => location.address
//                                   .toLowerCase()
//                                   .contains(_searchKey.toLowerCase()))
//                               .isNotEmpty)
//                           .toList();
//                     else
//                       return SliverToBoxAdapter(
//                         child: Padding(
//                           padding: const EdgeInsets.all(30.0),
//                           child: Center(child: Text("No cases found there.")),
//                         ),
//                       );
//                     if (_cases.length > 0) {
//                       return SliverList(
//                         delegate: SliverChildBuilderDelegate(
//                             (BuildContext context, int index) {
//                           return CaseItem(_cases[index]);
//                         }, childCount: _cases.length),
//                       );
//                     } else {
//                       return SliverToBoxAdapter(
//                         child: Padding(
//                           padding: const EdgeInsets.all(30.0),
//                           child: Center(child: Text("No cases found there.")),
//                         ),
//                       );
//                     }
//                   } else {
//                     return SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.all(30.0),
//                         child: Center(child: Text("No cases found.")),
//                       ),
//                     );
//                   }
//                   break;
//                 default:
//                   return SliverToBoxAdapter(
//                     child: Center(child: Text("")),
//                   );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
