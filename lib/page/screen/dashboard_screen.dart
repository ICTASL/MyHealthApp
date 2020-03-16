import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/fcm_message.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/page/screen/case_details_screen.dart';
import 'package:selftrackingapp/page/screen/case_list_screen.dart';
import 'package:selftrackingapp/page/screen/contact_us_screen.dart';
import 'package:selftrackingapp/page/screen/news_details_screen.dart';
import 'package:selftrackingapp/page/screen/privacy_policy_screen.dart';
import 'package:selftrackingapp/page/screen/user_register_screen.dart';

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
        backgroundColor: Color(0xff16a33e),
        title: Text(
            AppLocalizations.of(context).translate('dashboard_screen_title')),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 600,
            height: 100,
            child: FutureBuilder<List<Location>>(
              future: getLocationUpdate(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Location>> snapshot) {
                print(snapshot.error);
                if (snapshot.hasError) return Text("${snapshot.error}");
                List<Location> entries = snapshot.data;
                print("----aaa---");
                print(entries);
                print("----aaa----");
                if (entries != null && entries.length > 0) {
                  print(entries);
                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: entries.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(
                            'Entry ${entries[index].longitude},${entries[index].latitude},${entries[index].date.toIso8601String()}');
                      });
                } else {
                  return Text("No data");
                }
              },
            ),
          ),
          Text(
            AppLocalizations.of(context)
                .translate('dashboard_screen_welcome_message'),
          ),
          FlatButton(
            color: Colors.green,
            child: Text(AppLocalizations.of(context)
                .translate('dashboard_screen_news_button')),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewsDetailScreen()));
            },
          ),
          FlatButton(
            color: Colors.blue,
            child: Text(AppLocalizations.of(context)
                .translate('dashboard_screen_case_list_button')),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CaseListScreen()));
            },
          ),
          FlatButton(
            color: Colors.blue,
            child: Text(AppLocalizations.of(context)
                .translate('dashboard_screen_case_details_button')),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CaseDetailScreen(),
                ),
              );
            },
          ),
          FlatButton(
            color: Colors.blue,
            child: Text(AppLocalizations.of(context)
                .translate('dashboard_screen_privacy_policy_button')),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrivacyPolicyScreen()));
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

          FlatButton(
            color: Colors.blue,
            child: Text(AppLocalizations.of(context)
                .translate('dashboard_screen_contact_us_button')),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactUsScreen(),
                ),
              );
            },
          )
        ],
      )),
    );
  }

  Future<List<Location>> getLocationUpdate() async {
    try {
      final List<dynamic> locations =
          await DashboardScreen.locationChannel.invokeMethod('getLocation');
      print("--------");
      print(locations);
      print("--------");
      return locations.map((v) => Location.fromJson(v)).toList();
    } on Exception catch (e) {
      print(e);
    }
    return null;
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
              child: Text(AppLocalizations.of(context)
                  .translate('dashboard_screen_ok_button')),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}
