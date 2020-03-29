import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/page/screen/root_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:selftrackingapp/widgets/animated_tracker_button.dart';
import 'package:selftrackingapp/widgets/custom_text.dart';
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
  Widget _nextBtnChild = CustomText(
    "Next",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  );

  Widget _btnChild;
  String _appName = "MyHealth Sri Lanka";
  String _version = "1.0.0";

  @override
  void initState() {
    super.initState();
    _btnChild = _nextBtnChild;
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _appName = packageInfo.appName;
        _version = packageInfo.version;
      });
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
                        CustomText(_appName,
                            isChangeFontSize: false,
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10.0,
                        ),
                        CustomText(
                          _version,
                          isChangeFontSize: false,
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
                        CustomText(
                          AppLocalizations.of(context)
                              .translate("language_screen_choose"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        CustomText(
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
                                  _nextBtnChild = CustomText("ඊළඟ",
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
                                    CustomText("සිංහල",
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

                                  _nextBtnChild = CustomText("அடுத்தது",
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
                                    CustomText("தமிழ்",
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
                                  _nextBtnChild = CustomText("Next",
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
                                    CustomText("English",
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
                      child: _btnChild,
                      onPressed: () {
                        setState(() {
                          _nextBtnWidth = 100.0;
                          _nextBtnHeight = 60.0;
                          _btnChild = _registerCircleProgress;
                          SharedPreferences.getInstance().then((pref) {
                            String language = AppLocalizations.of(context)
                                .locale
                                .languageCode;
                            pref.setString("language", language);
                            print("Languge $language");
                          });
                        });
                        _showDialog();
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

  void _showDialog() {
    Future.delayed(Duration(seconds: 1), () {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _nextBtnWidth = 400.0;
                      _nextBtnHeight = 20.0;
                      _btnChild = _nextBtnChild;
                    });
                  },
                  child: CustomText(
                      AppLocalizations.of(context)
                          .translate("tos_decline_button"),
                      style: TextStyle(color: Colors.black45)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RootScreen()));
                      },
                      color: TrackerColors.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          AppLocalizations.of(context)
                              .translate("tos_accept_button"),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
              contentPadding: const EdgeInsets.all(0),
              content: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.black12,
                            style: BorderStyle.solid,
                            width: 3.0))),
                height: 400,
                child: SingleChildScrollView(
                  child: Scrollbar(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            AppLocalizations.of(context)
                                .translate("tos_dialog_title"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          CustomText(
                            AppLocalizations.of(context).translate("tos_title"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          CustomText(
                            AppLocalizations.of(context)
                                .translate("tos_line_one"),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          CustomText(
                            AppLocalizations.of(context)
                                .translate("tos_line_two"),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }
}
