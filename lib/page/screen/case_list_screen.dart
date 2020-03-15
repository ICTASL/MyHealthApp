import 'package:flutter/material.dart';
import 'package:selftrackingapp/page/routes.dart';
import 'package:selftrackingapp/page/screen/case_details_screen.dart';

class CaseListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Case List Screen"),
          FlatButton(
            color: Colors.green,
            child: Text("Select Case"),
            onPressed: () {
              Navigator.push(context, createRoute(CaseDetailScreen()));
            },
          ),
        ],
      )),
    );
  }
}
