import 'package:flutter/material.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/page/routes.dart';
import 'package:selftrackingapp/page/screen/case_list_screen.dart';
import 'package:selftrackingapp/page/screen/news_details_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Self Tracker"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)
                .translate('dashboard_screen_welcome_message'),
          ),
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
