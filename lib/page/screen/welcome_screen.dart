import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/page/screen/root_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:selftrackingapp/widgets/animated_tracker_button.dart';

import '../../app_localizations.dart';
import '../../utils/tracker_colors.dart';

class WelcomeScreen extends StatefulWidget {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Text("சிங்களம்",
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
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RootScreen()));
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
