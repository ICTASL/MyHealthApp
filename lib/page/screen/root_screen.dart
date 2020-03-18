import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/networking/api_client.dart';
import 'package:selftrackingapp/notifiers/stories_model.dart';
import 'package:selftrackingapp/page/screen/case_list_screen.dart';
import 'package:selftrackingapp/page/screen/contact_us_screen.dart';
import 'package:selftrackingapp/page/screen/dashboard_screen.dart';
import 'package:selftrackingapp/page/screen/user_register_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

enum RootTab { HomeTab, CaseTab, ContactTab, RegisterTab }

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  final StoriesModel _storiesModel = StoriesModel();

  int _currentIndex = 0;
  final _homeTabs = {
    DashboardScreen(),
    CaseListScreen(),
    ContactUsScreen(),
    UserRegisterScreen()
  };

  final _homeTabItems = [
    TitledNavigationBarItem(title: 'Home', icon: Icons.home),
    TitledNavigationBarItem(title: 'Cases', icon: Icons.search),
    TitledNavigationBarItem(title: 'Contact Us', icon: Icons.phone),
    TitledNavigationBarItem(title: 'Register', icon: Icons.person_add),
  ];

  @override
  void initState() {
    super.initState();
    _configureFCM();
    _messaging.subscribeToTopic("mobile_message");
  }

  void _handleFCM(Map<String, dynamic> message) async {
    print(message);
    if (message["data"] != null && message["data"]["type"] == "alert") {
      var id = message["data"]["id"];
      print("FETCHING ARTICLE: $id");
      NewsArticle article = await ApiClient().getMessage(int.parse(id));
      if (article != null) {
        _storiesModel.add(article);
        print("added article to stories model");
      } else {
        print("Failed adding article");
      }
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
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          )),
      body: ChangeNotifierProvider<StoriesModel>(
          create: (context) {
            return _storiesModel;
          },
          child: _homeTabs.elementAt(_currentIndex)),
      bottomNavigationBar: TitledBottomNavigationBar(
          currentIndex:
              _currentIndex, // Use this to update the Bar giving a position
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          activeColor: TrackerColors.primaryColor,
          items: _homeTabItems),
    );
  }
}
