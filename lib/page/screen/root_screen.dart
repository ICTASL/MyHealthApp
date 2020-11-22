import 'dart:io';

import 'package:async/async.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:selftrackingapp/constants.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/networking/api_client.dart';
import 'package:selftrackingapp/notifiers/registered_cases_model.dart';
import 'package:selftrackingapp/notifiers/stories_model.dart';
import 'package:selftrackingapp/page/screen/dashboard_screen.dart';
import 'package:selftrackingapp/page/screen/faq_screen.dart';
import 'package:selftrackingapp/page/screen/privacy_policy_screen.dart';
import 'package:selftrackingapp/page/screen/qr_scan_screen.dart';
import 'package:selftrackingapp/page/screen/welcome_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_localizations.dart';
import 'case_details_map_screen.dart';
import 'case_details_screen.dart';

enum RootTab { HomeTab, CaseTab, ContactTab, RegisterTab }

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  final StoriesModel _storiesModel = StoriesModel();
  final List<String> values = List();
  String _appName = "MyHealth Sri Lanka";

  int _currentIndex = 0;
  AsyncMemoizer<int> _memoizer = AsyncMemoizer();

  bool _isCasesLoaded = false;
  bool _hasCaseThrownError = false;
  final List<Widget> _homeTabsTotal = [
    DashboardScreen(),
    // CaseListMapDetailScreen(),
    QrScanScreen(),
    // CaseDetailScreen(),
    FAQScreen()
  ];
  // final List<Widget> _homeTabsWithoutCaseList = [
  //   DashboardScreen(),
  //   CaseDetailScreen(),
  //   FAQScreen()
  // ];

  bool _useCaseList = false;
  @override
  void initState() {
    super.initState();
    _configureFCM();
    _messaging.subscribeToTopic(
        debugRelease ? "mobile_message_test" : "mobile_message");
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      var name = packageInfo.appName;
      if (name != null) {
        _appName = name;
      }
    });
    _fetchCaseLatest();
    _appVersionCheck();
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
        await setState(() {
          _currentIndex = 0;
        });
        _handleFCM(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume");
        await setState(() {
          _currentIndex = 0;
        });
        _handleFCM(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch");
        await setState(() {
          _currentIndex = 0;
        });
        _handleFCM(message);
      },
    );
    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  void _fetchCaseLatest() async {
    try {
      int val = await _memoizer.runOnce(() async {
        print("Fetching Cases...");
        return await ApiClient().getLastCaseId();
      });
      setState(() {
        _isCasesLoaded = true;
        if (val > 0) {
          _useCaseList = true;
        }
      });
    } catch (e) {
      setState(() {
        _hasCaseThrownError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (val) {
                switch (val) {
                  case "change_lan":
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => WelcomeScreen()));
                    break;
                  case "see_priv":
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PrivacyPolicyScreen()));
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                      child: Text(AppLocalizations.of(context)
                          .translate("popmenu_language")),
                      value: 'change_lan'),
                  PopupMenuItem<String>(
                      child: Text(AppLocalizations.of(context)
                          .translate("popmenu_privpolicy")),
                      value: 'see_priv'),
                ];
              },
            ),
          ],
          title: Text(
            _appName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider<RegisteredCasesModel>(
                create: (context) => RegisteredCasesModel()),
            ChangeNotifierProvider<StoriesModel>(
                create: (context) => _storiesModel),
          ],
          child: !_hasCaseThrownError
              ? _isCasesLoaded
                  ? _homeTabsTotal[_currentIndex]
                  // _useCaseList
                  //     ? _homeTabsTotal[_currentIndex]
                  //     : _homeTabsWithoutCaseList[_currentIndex]
                  : Center(
                      child: CircularProgressIndicator(),
                    )
              : Center(
                  child: Text("An error has occured, try again later. "),
                ),
        ),
        bottomNavigationBar: TitledBottomNavigationBar(
            currentIndex:
                _currentIndex, // Use this to update the Bar giving a position
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            activeColor: TrackerColors.primaryColor,
            // items: _getBottomNavList(_useCaseList)));
            items: _getBottomNavList()));
  }

  List<TitledNavigationBarItem> _getBottomNavList() {
    return [
      TitledNavigationBarItem(
          title:
              AppLocalizations.of(context).translate('dashboard_home_tab_text'),
          icon: Icons.home),
      TitledNavigationBarItem(
          title: AppLocalizations.of(context).translate('scan_qr'),
          icon: Icons.center_focus_strong),
      TitledNavigationBarItem(
          title: AppLocalizations.of(context).translate('popmenu_faq'),
          icon: Icons.question_answer),
    ];
    // if (!_useCaseList) {
    //   return [
    //     TitledNavigationBarItem(
    //         title: AppLocalizations.of(context)
    //             .translate('dashboard_home_tab_text'),
    //         icon: Icons.home),
    //     TitledNavigationBarItem(
    //         title: AppLocalizations.of(context)
    //             .translate('dashboard_safe_track_tab_text'),
    //         icon: Icons.map),
    //     TitledNavigationBarItem(
    //         title: AppLocalizations.of(context).translate('popmenu_faq'),
    //         icon: Icons.question_answer),
    //   ];
    // } else {
    //   return [
    //     TitledNavigationBarItem(
    //         title: AppLocalizations.of(context)
    //             .translate('dashboard_home_tab_text'),
    //         icon: Icons.home),
    //     TitledNavigationBarItem(
    //         title: AppLocalizations.of(context)
    //             .translate('dashboard_case_list_tab_text'),
    //         icon: Icons.location_searching),
    //     TitledNavigationBarItem(
    //         title: AppLocalizations.of(context)
    //             .translate('dashboard_safe_track_tab_text'),
    //         icon: Icons.map),
    //     TitledNavigationBarItem(
    //         title: AppLocalizations.of(context).translate('popmenu_faq'),
    //         icon: Icons.question_answer),
    //   ];
    // }
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
