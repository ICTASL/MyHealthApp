import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:selftrackingapp/page/routes.dart';
import 'package:selftrackingapp/page/screen/dashboard_screen.dart';
import 'package:selftrackingapp/page/screen/privacy_policy_screen.dart';
import 'package:selftrackingapp/theme.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.4, 0.7, 0.9],
                    colors: [
                      Color(0xFF181C30),
                      Color(0xFF181C30),
                      Color(0xFF181C30),
                      Color(0xFF181C30),
                    ],
                  ),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            decoration:
                                BoxDecoration(color: colorAccentBackground),
                            child: Image.asset(
                              "assets/images/welcome_screen_bg.png",
                              width: 300,
                              height: 300,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Container(
                                  child: Text(
                                    "Welcome",
                                    style: h1TextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: mainButtonTextColor),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: Container(
                                  child: Text(
                                    "Together we can defeat COVID-19",
                                    style: h4TextStyle.copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: mainButtonTextColor),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Container(
                                  child: FlatButton(
                                    color: Color(0XFF8DC63F),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        "Next",
                                        style: h2TextStyle.copyWith(
                                            color: textColor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(context,
                                          createRoute(DashboardScreen()));
                                    },
                                  ),
                                ),
                              )
                            ],
                          )
                        ])))));
  }
}
