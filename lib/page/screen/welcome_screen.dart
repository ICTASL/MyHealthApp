import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/page/screen/root_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:selftrackingapp/widgets/animated_tracker_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_localizations.dart';
import '../../utils/tracker_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String welcomeScreenTitle = "";
  double height = 800.0;
  double _nextBtnHeight = 20.0;
  double _nextBtnWidth = 400.0;
  final Widget _registerCircleProgress = CircularProgressIndicator(
    backgroundColor: Colors.white,
  );
  Widget _nextBtnChild = Text(
    "Next",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  );
  String _appName = "Sri Lanka COVID-19";
  String _version = "1.0.0";

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _appName = packageInfo.appName;
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(AppLocalizations.of(context).locale);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(_appName,
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          _version,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/logo.png",
                          height: 124.0,
                          fit: BoxFit.cover,
                          color: TrackerColors.primaryColor[900],
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          AppLocalizations.of(context)
                              .translate("language_screen_choose"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate("language_screen_choose_sub"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Divider(),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  AppLocalizations.of(context)
                                      .load(Locale("si", "LK"));
                                  _nextBtnChild = Text("ඊළඟ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold));
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 20.0,
                                    right: 20.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("සිංහල",
                                        style: TextStyle(
                                            color: AppLocalizations.of(context)
                                                        .locale ==
                                                    Locale("si", "LK")
                                                ? TrackerColors.primaryColor
                                                : Colors.black,
                                            fontWeight:
                                                AppLocalizations.of(context)
                                                            .locale ==
                                                        Locale("si", "LK")
                                                    ? FontWeight.bold
                                                    : FontWeight.normal)),
                                    AppLocalizations.of(context).locale ==
                                            Locale("si", "LK")
                                        ? Icon(Icons.check,
                                            color: TrackerColors.primaryColor)
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  AppLocalizations.of(context)
                                      .load(Locale("ta", "TA"));

                                  _nextBtnChild = Text("அடுத்தது",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold));
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 20.0,
                                    right: 20.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("தமிழ்",
                                        style: TextStyle(
                                            color: AppLocalizations.of(context)
                                                        .locale ==
                                                    Locale("ta", "TA")
                                                ? TrackerColors.primaryColor
                                                : Colors.black,
                                            fontWeight:
                                                AppLocalizations.of(context)
                                                            .locale ==
                                                        Locale("ta", "TA")
                                                    ? FontWeight.bold
                                                    : FontWeight.normal)),
                                    AppLocalizations.of(context).locale ==
                                            Locale("ta", "TA")
                                        ? Icon(Icons.check,
                                            color: TrackerColors.primaryColor)
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  height = 500.0;
                                  AppLocalizations.of(context)
                                      .load(Locale("en", "US"));
                                  _nextBtnChild = Text("Next",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold));
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 20.0,
                                    right: 20.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("English",
                                        style: TextStyle(
                                            color: AppLocalizations.of(context)
                                                        .locale ==
                                                    Locale("en", "US")
                                                ? TrackerColors.primaryColor
                                                : Colors.black,
                                            fontWeight:
                                                AppLocalizations.of(context)
                                                            .locale ==
                                                        Locale("en", "US")
                                                    ? FontWeight.bold
                                                    : FontWeight.normal)),
                                    AppLocalizations.of(context).locale ==
                                            Locale("en", "US")
                                        ? Icon(Icons.check,
                                            color: TrackerColors.primaryColor)
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    AnimatedTrackerButton(
                      width: _nextBtnWidth,
                      height: _nextBtnHeight,
                      child: _nextBtnChild,
                      onPressed: () {
                        setState(() {
                          _nextBtnWidth = 100.0;
                          _nextBtnHeight = 60.0;
                          _nextBtnChild = _registerCircleProgress;

                          SharedPreferences.getInstance().then((pref) {
                            String language = AppLocalizations.of(context)
                                .locale
                                .languageCode;
                            pref.setString("language", language);
                            print("Languge $language");
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RootScreen()));
                            });
                          });
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
