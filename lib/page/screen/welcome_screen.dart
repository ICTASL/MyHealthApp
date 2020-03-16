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
import 'package:selftrackingapp/theme.dart';
import 'package:selftrackingapp/widgets/language_select.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String welcomeScreenTitle = "";

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      welcomeScreenTitle =
          AppLocalizations.of(context).translate('welcome_screen_title');
    });
  }

  changeLanguage(String language) {
    setState(() {
      if (language == "Sinhala")
        AppLocalizations.of(context).load(Locale("si", "LK"));
      else if (language == "English")
        AppLocalizations.of(context).load(Locale("en", "US"));
      else if (language == "Tamil")
        AppLocalizations.of(context).load(Locale("ta", "TA"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("assets/images/welcome_screen_bg.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 200.0),
                              child: Container(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('welcome_screen_title'),
                                  style: h1TextStyle.copyWith(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w600,
                                      color: mainButtonTextColor),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: Center(
                              child: Container(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('welcome_screen_subtitle'),
                                  style: h4TextStyle.copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: mainButtonTextColor),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: FlatButton(
                                      color: Color(0XFF8DC63F),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(
                                                  'welcome_screen_button_text'),
                                          style: h2TextStyle.copyWith(
                                              color: textColor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DashboardScreen()));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        child: LanguageSelectWidget(
                                      notifyLanguageChange: changeLanguage,
                                    )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ])))));
  }
}
