import 'package:flutter/material.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/page/screen/user_register_screen.dart';

class CaseDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        AppLocalizations.of(context).translate('case_details_screen_title'),
      )),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(AppLocalizations.of(context)
              .translate('case_details_screen_title')),
          FlatButton(
            color: Colors.blue,
            child: Text("User register"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserRegisterScreen()));
            },
          )
        ],
      )),
    );
  }
}
