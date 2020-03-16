import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/fcm_message.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/networking/api_client.dart';
import 'package:selftrackingapp/page/screen/case_details_screen.dart';
import 'package:selftrackingapp/page/screen/case_list_screen.dart';
import 'package:selftrackingapp/page/screen/contact_us_screen.dart';
import 'package:selftrackingapp/page/screen/news_details_screen.dart';
import 'package:selftrackingapp/page/screen/privacy_policy_screen.dart';
import 'package:selftrackingapp/theme.dart';
import 'package:share/share.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  List<NewsArticle> stories = [];

  @override
  void initState() {
    super.initState();
    _configureFCM();
    _messaging.subscribeToTopic("mobile_message");

    ApiClient().getLastMessageId().then((id) {
      print(id);
      if (id == -1) {
        return;
      }
      for (var i = id; i > 0; i--) {
        ApiClient().getMessage(i).then((article) {
          // Save article for display
          setState(() {
            stories.add(article);
          });
        });
      }
    });
  }

  Widget buildComponent(String title, int number, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(8.0)),
            color: colorAccentBackground),
        width: 160.0,
        height: 160.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Spacer(),
            Text(
              "$number",
              style: h1TextStyle.copyWith(
                  fontWeight: FontWeight.w800,
                  color: textColor.withOpacity(0.7)),
            ),
            Spacer(),
            Text(
              "$title".toUpperCase(),
              style: h3TextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor.withOpacity(0.9)),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget horizontalList1 = new Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 160.0,
        child: new ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            buildComponent("CONFIRMED", 99999, Colors.green),
            buildComponent("RECOVERED", 99999, Colors.blue),
            buildComponent("SUSPECTED", 99999, Colors.yellow),
            buildComponent("DEATHS", 99999, Colors.red),
          ],
        ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
            AppLocalizations.of(context).translate('dashboard_screen_title')),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Color(0xff7c94b6),
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.white.withOpacity(0.8), BlendMode.dstATop),
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              horizontalList1,
              Flexible(
                child: ListView.builder(
                    itemCount: stories.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(index);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(8.0)),
                              color: colorAccentBackground,
                              boxShadow: [backgroundBoxShadow]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  stories[index].originator,
                                  textAlign: TextAlign.start,
                                  style: h2TextStyle.copyWith(
                                      color: primaryColorText),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    "8th March 12:45",
                                    //published data needs to facilitated into the messages from the API
                                    textAlign: TextAlign.start,
                                    style: h6TextStyle.copyWith(
                                        color:
                                            primaryColorText.withOpacity(0.5)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    stories[index].message,
                                    style: h5TextStyle.copyWith(
                                        color:
                                            primaryColorText.withOpacity(0.7)),
                                  ),
                                ),
                                Container(
                                  child: Divider(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      Share.share(
                                          "Shared button not implemented yet");
                                    },
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Colors.green,
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "More Detail",
                        style: h1TextStyle.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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

class DashboardScreenOld extends StatefulWidget {
  @override
  _DashboardScreenOldState createState() => _DashboardScreenOldState();

  static const locationChannel = const MethodChannel("location");
}

class _DashboardScreenOldState extends State<DashboardScreenOld> {
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
                // print("----aaa---");
                // print(entries);
                // print("----aaa----");
                if (entries != null && entries.length > 0) {
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
          await DashboardScreenOld.locationChannel.invokeMethod('getLocation');
      // print("--------");
      // print(locations);
      // print("--------");
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
    _messaging.subscribeToTopic("topic1");
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
