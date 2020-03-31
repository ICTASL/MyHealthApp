import 'dart:async';

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/networking/db.dart';
import 'package:selftrackingapp/page/screen/root_screen.dart';
import 'package:selftrackingapp/page/screen/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'utils/tracker_colors.dart';
import 'package:dropdown_banner/dropdown_banner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    GetIt.instance
        .registerSingleton<DataRepository>(AppDataRepository(AppDatabase()));
  }

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID-19 Tracker',
      theme: ThemeData(
          primarySwatch: TrackerColors.primaryColor,
          backgroundColor: Color(0xfff6f6f9),
          textTheme: TextTheme(
            display1: TextStyle(color: Colors.black, fontSize: 15.0),
            display2: TextStyle(color: Colors.black54, fontSize: 12.0),
            body1: TextStyle(color: Colors.black54, fontSize: 15.0),
          )),
      supportedLocales: [Locale('en', "US"), Locale('si', "LK")],
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      home: DropdownBanner(
        child: HomeScreen(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Duration SPLASH_DURATION = Duration(seconds: 20);
  Widget _nextScreen;
  bool _isTimeoutCompleted;

  @override
  void initState() {
    super.initState();
    _isTimeoutCompleted = false;

    Timer(SPLASH_DURATION, () {
      if (_nextScreen != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => _nextScreen));
      } else {
        _isTimeoutCompleted = true;
      }
    });

    loadLang();
  }

  Future<void> loadLang() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    String language = pref.getString("language");
    if (language != null) {
      if (language == "en") {
        AppLocalizations.of(context).load(Locale("en", "US"));
      } else if (language == "ta") {
        AppLocalizations.of(context).load(Locale("ta", "TA"));
      } else {
        AppLocalizations.of(context).load(Locale("si", "LK"));
      }
      _nextScreen = RootScreen();
      if (_isTimeoutCompleted) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => _nextScreen));
      }
    } else {
      _nextScreen = WelcomeScreen();
      if (_isTimeoutCompleted) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => _nextScreen));
      }
    }
  }

  Widget _createSplashScreen() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/welcome_screen_bg.png"),
              fit: BoxFit.fill)),
    ); // or some other widget
  }

  void reachabilityFailedFail() {
    DropdownBanner.showBanner(
        text: 'Please check your WiFi or mobile data connection',
        color: Colors.redAccent,
        textStyle: TextStyle(color: Colors.white),
        duration: Duration(seconds: 3));
  }

  void checkReachability() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else {
      reachabilityFailedFail();
    }
  }

  @override
  Widget build(BuildContext context) {
    checkReachability();
    return _createSplashScreen();
  }
}
