import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/page/screen/case_list_screen.dart';
import 'package:selftrackingapp/page/screen/news_details_screen.dart';
import 'package:selftrackingapp/page/screen/user_register_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate('dashboard_screen_title')),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<String>(
            future: getLocationUpdate(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Text("DAta ${snapshot.data}");
            },
          ),
          Text(
            AppLocalizations.of(context)
                .translate('dashboard_screen_welcome_message'),
          ),
          FlatButton(
            color: Colors.green,
            child: Text("Select News"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewsDetailScreen()));
            },
          ),
          FlatButton(
            color: Colors.blue,
            child: Text("Case List Screen"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CaseListScreen()));
            },
          ),
          // FlatButton(
          //   color: Colors.blue,
          //   child: Text("User Registration"),
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => UserRegisterScreen()));
          //   },
          // )
        ],
      )),
    );
  }

  static const locationChannel = const MethodChannel("location");

  Future<String> getLocationUpdate() async {
    String location;
    try {
      var result = await locationChannel.invokeMethod('getLocation');
      location = '$result%';
    } on PlatformException catch (e) {
      location = "0.0,0.0";
    }

    print(location);
    return location;
  }
}
