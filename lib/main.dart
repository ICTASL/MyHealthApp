import 'dart:async';

import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/networking/db.dart';
import 'package:selftrackingapp/page/screen/root_screen.dart';
import 'package:selftrackingapp/page/screen/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';
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
  static const Duration SPLASH_DURATION = Duration(seconds: 3);
  Widget _nextScreen;
  bool _isTimeoutCompleted;

  @override
  void initState() {
    super.initState();

    _isTimeoutCompleted = false;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Timer(SPLASH_DURATION, () {
      if (_nextScreen != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => _nextScreen));
      } else {
        _isTimeoutCompleted = true;
      }
    });

    loadLang();
    _appVersionCheck();
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

//check for the latest build number set in the firebase remote config
//and show update dialog if necessary
  void _appVersionCheck() async {
    String key = Platform.isIOS
        ? IOS_APP_BUILD_NUMBER_KEY
        : ANDROID_APP_BUILD_NUMBER_KEY;

    //Get Current buildNumber of the app
    final PackageInfo info = await PackageInfo.fromPlatform();

    //In Android this refers to [versionCode]. In iOS [CFBundleVersion]
    int currentBuildNumber = int.parse(info.buildNumber);

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      await remoteConfig
          .setDefaults(<String, dynamic>{key: currentBuildNumber});

      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();

      int remoteBuildNumber = remoteConfig.getInt(key);

      print("remoteBuildNumber $remoteBuildNumber");
      if (remoteBuildNumber > currentBuildNumber) {
        _showUpdateDialog();
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Default value will be used');
    }
  }

  void _showUpdateDialog() async {
    bool isIOS = Platform.isIOS;
    String title = "New Update Available";
    String message =
        "There is a newer version of the app available. Please update now.";
    String affirmativeLabel = "Update Now";
    String negativeLabel = "Later";

    isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(affirmativeLabel),
                    onPressed: () => launchAppStore(IOS_APP_URL),
                  ),
                  CupertinoDialogAction(
                    child: Text(negativeLabel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      affirmativeLabel.toUpperCase(),
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () => launchAppStore(ANDROID_APP_URL),
                  ),
                  FlatButton(
                    child: Text(negativeLabel.toUpperCase()),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          );
  }

  void launchAppStore(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    }
  }
}
