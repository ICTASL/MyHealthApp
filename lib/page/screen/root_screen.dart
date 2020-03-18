import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/networking/api_client.dart';
import 'package:selftrackingapp/page/screen/case_list_screen.dart';
import 'package:selftrackingapp/page/screen/contact_us_screen.dart';
import 'package:selftrackingapp/page/screen/case_details_screen.dart';
import 'package:selftrackingapp/page/screen/dashboard_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

enum RootTab { HomeTab, CaseTab, ContactTab, RegisterTab }

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  static final StreamController<NewsArticle> newsStreamController =
      StreamController.broadcast();

  int _currentIndex = 0;
  final _homeTabs = {
    DashboardScreen(
      articleStream: newsStreamController.stream,
    ),

    CaseListScreen(),
    CaseDetailScreen(),
    ContactUsScreen()
//    UserRegisterScreen()
  };

  final _homeTabItems = [
    TitledNavigationBarItem(title: 'Home', icon: Icons.home),
    TitledNavigationBarItem(title: 'Cases', icon: Icons.view_list),
    TitledNavigationBarItem(title: 'My Location', icon: Icons.map),
    TitledNavigationBarItem(title: 'Contact Us', icon: Icons.call),
    // TitledNavigationBarItem(title: 'Register', icon: Icons.person_add),
  ];

  @override
  void initState() {
    super.initState();
    _configureFCM();
    _messaging.subscribeToTopic("mobile_message");
    updateArticles();
  }

  @override
  void dispose() {
    newsStreamController.close();
    super.dispose();
  }

  void _handleFCM(Map<String, dynamic> message) {
    print(message);
    print(message["data"] != null && message["data"]["type"] == "alert");
    print(message["data"] != null);
    print(message["data"]["type"] == "alert");
    if (message["data"] != null && message["data"]["type"] == "alert") {
      var id = message["data"]["id"];
      print("Message $id");
      ApiClient().getMessage(id as int).then((article) {
//        print(article);
        if (article != null) {
          newsStreamController.add(article);
        }
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            _homeTabItems[_currentIndex].title,
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
            updateArticles();
            setState(() {
              _currentIndex = index;
            });
          },
          activeColor: Color(TrackerColors.primaryColor),
          items: _homeTabItems),
    );
  }

  void updateArticles() {
    ApiClient().getLastMessageId().then((id) {
      int lowerID = 1;
      if (id >= 10) {
        lowerID = id - 9;
      }
      print("$lowerID m $id");
      ApiClient().getArticleList(lowerID, id, newsStreamController.sink);
    });
  }
}
