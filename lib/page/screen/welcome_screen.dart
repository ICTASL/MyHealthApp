import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/networking/db.dart';
import 'package:selftrackingapp/page/screen/dashboard_screen.dart';
import 'package:selftrackingapp/page/screen/privacy_policy_screen.dart';
import 'package:selftrackingapp/page/screen/root_screen.dart';
import 'package:selftrackingapp/theme.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:selftrackingapp/widgets/language_select.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String welcomeScreenTitle = "";
  double height = 800.0;

  @override
  Widget build(BuildContext context) {
    print("WEWE");
    print(AppLocalizations.of(context).locale);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
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
                      color: Color(TrackerColors.primaryColor),
                    ),
                    SizedBox(height: 30.0),
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
                      height: 15.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              height = 500.0;
                              AppLocalizations.of(context)
                                  .load(Locale("en", "US"));
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("English",
                                    style: TextStyle(
                                        color: AppLocalizations.of(context)
                                                    .locale ==
                                                Locale("en", "US")
                                            ? Color(TrackerColors.primaryColor)
                                            : Colors.black,
                                        fontWeight: AppLocalizations.of(context)
                                                    .locale ==
                                                Locale("en", "US")
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                                AppLocalizations.of(context).locale ==
                                        Locale("en", "US")
                                    ? Icon(Icons.check,
                                        color:
                                            Color(TrackerColors.primaryColor))
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
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("சிங்களம்",
                                    style: TextStyle(
                                        color: AppLocalizations.of(context)
                                                    .locale ==
                                                Locale("ta", "TA")
                                            ? Color(TrackerColors.primaryColor)
                                            : Colors.black,
                                        fontWeight: AppLocalizations.of(context)
                                                    .locale ==
                                                Locale("ta", "TA")
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                                AppLocalizations.of(context).locale ==
                                        Locale("ta", "TA")
                                    ? Icon(Icons.check,
                                        color:
                                            Color(TrackerColors.primaryColor))
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
                                  .load(Locale("si", "LK"));
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("සිංහල",
                                    style: TextStyle(
                                        color: AppLocalizations.of(context)
                                                    .locale ==
                                                Locale("si", "LK")
                                            ? Color(TrackerColors.primaryColor)
                                            : Colors.black,
                                        fontWeight: AppLocalizations.of(context)
                                                    .locale ==
                                                Locale("si", "LK")
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                                AppLocalizations.of(context).locale ==
                                        Locale("si", "LK")
                                    ? Icon(Icons.check,
                                        color:
                                            Color(TrackerColors.primaryColor))
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
                  height: 30.0,
                ),
                RaisedButton(
                  color: Color(TrackerColors.primaryColor),
                  padding: const EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                          AppLocalizations.of(context).translate(
                            "ui_general_next",
                          ),
                          style:
                              TextStyle(color: Colors.white, fontSize: 17.0)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => RootScreen()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
