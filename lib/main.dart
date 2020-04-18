import 'dart:async';

import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_banner/dropdown_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/networking/db.dart';
import 'package:selftrackingapp/page/screen/dashboard_screen.dart';
import 'package:selftrackingapp/page/screen/root_screen.dart';
import 'package:selftrackingapp/page/screen/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/tracker_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    GetIt.instance
        .registerSingleton<DataRepository>(AppDataRepository(AppDatabase()));
  }

  @override
  Widget build(BuildContext context) {
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
  static const int SPLASH_DURATION = 3;
  AsyncMemoizer<bool> _asyncMemoizer;
  bool _hasSplashFinished = false;
  bool _requiresLanguage = false;

  @override
  void initState() {
    super.initState();
    _asyncMemoizer = AsyncMemoizer();
    print("Showing Splash");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _asyncMemoizer.runOnce(() {
      loadLang();
    });
    checkReachability();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadLang() async {
    await Future.delayed(Duration(seconds: SPLASH_DURATION), () {});
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String language = pref.getString("language");
    if (language != null) {
      if (language == "en") {
        await AppLocalizations.of(context).load(Locale("en", "US"));
      } else if (language == "ta") {
        await AppLocalizations.of(context).load(Locale("ta", "TA"));
      } else {
        await AppLocalizations.of(context).load(Locale("si", "LK"));
      }
      setState(() {
        _hasSplashFinished = true;
        _requiresLanguage = false;
      });
    } else {
      setState(() {
        _hasSplashFinished = true;
        _requiresLanguage = true;
      });
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
        duration: Duration(seconds: 10));
  }

  void checkReachability() async {
    Connectivity connectivity = Connectivity();
    Stream<ConnectivityResult> connectivityResult =
        connectivity.onConnectivityChanged;
    connectivityResult.listen((ConnectivityResult data) {
      if (data == ConnectivityResult.mobile) {
      } else if (data == ConnectivityResult.wifi) {
        print("Connected");
      } else {
        print("Disconnected");
        reachabilityFailedFail();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _hasSplashFinished
          ? _requiresLanguage ? WelcomeScreen() : RootScreen()
          : _createSplashScreen(),
    );
  }
}
