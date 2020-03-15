import 'package:flutter/material.dart';
import 'package:selftrackingapp/page/routes.dart';
import 'package:selftrackingapp/page/screen/case_list_screen.dart';
import 'package:selftrackingapp/page/screen/news_details_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Dashboard Screen"),
          FlatButton(
            color: Colors.green,
            child: Text("Select News"),
            onPressed: () {
              Navigator.push(context, createRoute(NewsDetailScreen()));
            },
          ),
          FlatButton(
            color: Colors.blue,
            child: Text("Case List Screen"),
            onPressed: () {
              Navigator.push(context, createRoute(CaseListScreen()));
            },
          )
        ],
      )),
    );
  }
}
