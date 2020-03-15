import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/fcm_message.dart';
import 'package:selftrackingapp/page/screen/case_details_screen.dart';
import 'package:selftrackingapp/page/screen/case_list_screen.dart';
import 'package:selftrackingapp/page/screen/news_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();

  static const locationChannel = const MethodChannel("location");
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _configureFCM();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
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
          )
        ],
      )),
    );
  }

  Future<String> getLocationUpdate() async {
    String location;
    try {
      var result =
          await DashboardScreen.locationChannel.invokeMethod('getLocation');
      location = '$result%';
    } on PlatformException catch (e) {
      location = "0.0,0.0";
    }

    print(location);
    return location;
  }

  void _configureFCM() {
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _handleFCM(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _handleFCM(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _handleFCM(message);
      },
    );

    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  void _handleFCM(Map<String, dynamic> message) {
    FCMMessage fcmMessage = FCMMessage.decode(message);

    switch (fcmMessage.type) {
      case "message":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewsDetailScreen()));
        break;

      case "data":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CaseDetailScreen()));
        break;

      default:
        _showMessageAsDialog(fcmMessage);
    }
  }

  void _showMessageAsDialog(FCMMessage fcmMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(fcmMessage.title),
            content: Text(fcmMessage.body),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
