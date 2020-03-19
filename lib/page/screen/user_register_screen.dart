import 'package:flutter/material.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:selftrackingapp/widgets/animated_tracker_button.dart';

import '../../app_localizations.dart';
import '../../utils/tracker_colors.dart';

class UserRegisterScreen extends StatefulWidget {
  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Widget _registerTextChild = Text(
    "Register",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  );
  final Widget _registerCircleProgress = CircularProgressIndicator(
    backgroundColor: Colors.white,
  );
  final Widget _registerSuccess = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Registered",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 10.0,
      ),
      Icon(
        Icons.check,
        color: Colors.white,
      ),
    ],
  );
  bool _registerBtnStatus = true;
  double _registerBtnWidth = 400.0;
  double _registerBtnHeight = 30.0;
  Widget _currentBtnChild;

  @override
  void initState() {
    super.initState();
    _currentBtnChild = _registerTextChild;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Register", style: TextStyle(color: Colors.black))),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
              child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text("Register For a Case",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold))),
                Container(
                    child: Text("Were you near a confirmed case?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal))),
              ],
            ),
          )),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate("user_register_screen_invalid_name");
                          }
                        },
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate("user_register_screen_name"),
                            icon: Icon(
                              Icons.account_circle,
                              color: TrackerColors.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: TrackerColors.primaryColor,
                              ),
                            ))),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                        validator: (val) {
                          if (val.isEmpty || !val.contains("@")) {
                            return AppLocalizations.of(context).translate(
                                "user_register_screen_invalid_email");
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate("user_register_screen_email"),
                            icon: Icon(
                              Icons.email,
                              color: TrackerColors.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: TrackerColors.primaryColor,
                              ),
                            ))),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return AppLocalizations.of(context).translate(
                                "user_register_screen_invalid_number");
                          }
                        },
                        maxLength: 12,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate("user_register_screen_phone"),
                            icon: Icon(
                              Icons.phone,
                              color: TrackerColors.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: TrackerColors.primaryColor,
                              ),
                            ))),
                    SizedBox(
                      height: 15.0,
                    ),
                    AnimatedTrackerButton(
                      child: _currentBtnChild,
                      active: _registerBtnStatus,
                      width: _registerBtnWidth,
                      height: _registerBtnHeight,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          //HANDLE the DB call to save here
                          //init a loading state
                          setState(() {
                            _currentBtnChild = _registerCircleProgress;
                            _registerBtnWidth = 100.0;
                            _registerBtnHeight = 50.0;
                            _registerBtnStatus = false;
                          });

                          //init a success state
                          await Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _currentBtnChild = _registerSuccess;
                              _registerBtnHeight = 30.0;
                              _registerBtnWidth = 400.0;
                              _registerBtnStatus = false;
                            });
                          });

                          //init the starting state
                          await Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _currentBtnChild = _registerTextChild;
                              _registerBtnStatus = true;

                              _registerBtnHeight = 30.0;
                              _registerBtnWidth = 400.0;
                            });
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
