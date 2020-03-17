import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selftrackingapp/models/fcm_message.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/networking/api_client.dart';
import 'package:selftrackingapp/page/screen/case_list_screen.dart';
import 'package:selftrackingapp/page/screen/contact_us_screen.dart';
import 'package:selftrackingapp/page/screen/dashboard_screen.dart';
import 'package:selftrackingapp/page/screen/user_register_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import 'case_details_screen.dart';
import 'news_detail_screen.dart';

enum RootTab { HomeTab, CaseTab, ContactTab, RegisterTab }

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  List<NewsArticle> stories = [];

  int _currentIndex = 0;
  final _homeTabs = {
    DashboardScreen(),
    CaseListScreen(),
    ContactUsScreen(),
    UserRegisterScreen()
  };

  @override
  void initState() {
    super.initState();
    _configureFCM();
    _messaging.subscribeToTopic("mobile_message");
  }

  void _handleFCM(Map<String, dynamic> message) {
    print("Handle FCM has not yet been implemented.");
    // FCMMessage fcmMessage = FCMMessage.decode(message);
    // if (message["data"] != null && message["data"]["type"] == "news") {
    //   var id = message["data"]["id"];
    //   ApiClient().getMessage(id).then((article) {
    //     print(article);
    //     if (article != null) {
    //       setState(() {
    //         stories.add(article);
    //       });
    //     }
    //   });
    // }
    // switch (fcmMessage.type) {
    //   case "message":
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => NewsDetailScreen()));
    //     break;

    //   case "data":
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => CaseDetailScreen()));
    //     break;
    //   default:
    //     _showMessageAsDialog(fcmMessage);
    // }
  }

  void _configureFCM() {
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage");
        _handleFCM(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume");
        _handleFCM(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _handleFCM(message);
      },
    );
    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Home",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0)),
          )),
      body: _homeTabs.elementAt(_currentIndex),
      bottomNavigationBar: TitledBottomNavigationBar(
          currentIndex:
              _currentIndex, // Use this to update the Bar giving a position
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          activeColor: Color(TrackerColors.primaryColor),
          items: [
            TitledNavigationBarItem(title: 'Home', icon: Icons.home),
            TitledNavigationBarItem(title: 'Cases', icon: Icons.search),
            TitledNavigationBarItem(title: 'Register', icon: Icons.card_travel),
            TitledNavigationBarItem(
                title: 'Privacy', icon: Icons.shopping_cart),
          ]),
    );
  }
}
