import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/fcm_message.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/networking/api_client.dart';
import 'package:selftrackingapp/page/screen/case_details_screen.dart';
import 'package:selftrackingapp/page/screen/contact_us_screen.dart';
import 'package:selftrackingapp/page/screen/news_detail_screen.dart';
import 'package:selftrackingapp/theme.dart';
import 'package:share/share.dart';

enum CounterType { confirmed, recovered, suspected, deaths }

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  List<NewsArticle> stories = [];
  int confirmed = 0;
  int recovered = 0;
  int suspected = 0;
  int deaths = 0;

  @override
  void initState() {
    super.initState();
    // Messaging
    _configureFCM();
    _messaging.subscribeToTopic("mobile_message");
    // Remote config
    updateRemoteConfig();
    // Get messages
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

  Widget buildCounter(CounterType type) {
    String title = "";
    int number = 0;
    Color textColor;
    switch (type) {
      case CounterType.confirmed:
        title = 'CONFIRMED';
        textColor = Colors.green;
        number = confirmed;
        break;

      case CounterType.suspected:
        title = 'SUSPECTED';
        textColor = Colors.yellow;
        number = suspected;
        break;

      case CounterType.recovered:
        title = 'RECOVERED';
        textColor = Colors.blue;
        number = recovered;
        break;

      case CounterType.deaths:
        title = 'DEATHS';
        textColor = Colors.red;
        number = deaths;
        break;
    }
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
            buildCounter(CounterType.confirmed),
            buildCounter(CounterType.recovered),
            buildCounter(CounterType.suspected),
            buildCounter(CounterType.deaths),
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
                      NewsArticle article = stories[index];
                      if (article == null) return Text("updating...");
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewsDetailScreen(article: article)));
                          },
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
                                    article.originator,
                                    textAlign: TextAlign.start,
                                    style: h2TextStyle.copyWith(
                                        color: primaryColorText),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "${article.created}",
                                      //published data needs to facilitated into the messages from the API
                                      textAlign: TextAlign.start,
                                      style: h6TextStyle.copyWith(
                                          color: primaryColorText
                                              .withOpacity(0.5)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      article.message,
                                      style: h5TextStyle.copyWith(
                                          color: primaryColorText
                                              .withOpacity(0.7)),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactUsScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('dashboard_screen_contact_us_button'),
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

    print("Message type ${message}");
    print("Message type ${fcmMessage.type}");
    print("Message body ${fcmMessage.body}");

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

  void updateRemoteConfig() async {
    final RemoteConfig config = await RemoteConfig.instance;
    final defaults = <String, dynamic>{
      'confirmed': 28,
      'recovered': 1,
      'suspected': 212,
      'deaths': 0
    };
    await config.setDefaults(defaults);
    await config.fetch(expiration: const Duration(minutes: 15));
    await config.activateFetched();
    setState(() {
      confirmed = config.getInt('confirmed');
      recovered = config.getInt('recovered');
      suspected = config.getInt('suspected');
      deaths = config.getInt('deaths');
    });
  }

  void _showMessageAsDialog(FCMMessage fcmMessage) {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text(fcmMessage.title),
//          content: Text(fcmMessage.body),
//          actions: <Widget>[
//            FlatButton(
//              child: Text(AppLocalizations.of(context)
//                  .translate('dashboard_screen_ok_button')),
//              onPressed: () => Navigator.pop(context),
//            )
//          ],
//        );
//      },
//    );
  }
}
