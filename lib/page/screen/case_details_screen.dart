import 'package:flutter/material.dart';
import 'package:selftrackingapp/page/routes.dart';
import 'package:selftrackingapp/page/screen/user_register_screen.dart';

class CaseDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Case Details",
      )),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Case Detail Screen"),
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
