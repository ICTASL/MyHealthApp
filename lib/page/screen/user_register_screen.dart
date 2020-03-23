import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/exceptions/data_write_exception.dart';
import 'package:selftrackingapp/models/registration.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/notifiers/registered_cases_model.dart';
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
  final Widget _registerFailed = Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Error registering, try again later.",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ],
  );

  bool _registerBtnStatus = true;
  double _registerBtnWidth = 400.0;
  double _registerBtnHeight = 30.0;
  Widget _currentBtnChild;

  String _name;
  String _age;
  String _email = "";
  String _mobileNumber;
  String _address;
  String _citizenStatus = "Yes";
  String _nic = "";
  String _country = "Afghanistan";
  String _passport = "";
  String _gender = "Female";

  final AsyncMemoizer<List<String>> _memorizier = AsyncMemoizer<List<String>>();

  @override
  void initState() {
    super.initState();
    _currentBtnChild = _registerTextChild;
    print("Getting countries");
  }

  Future<List<String>> _fetchCountries() {
    return _memorizier.runOnce(() {
      return GetIt.instance<DataRepository>().fetchCountryList();
    });
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
          title: Text(
              AppLocalizations.of(context)
                  .translate('user_register_bar_title_text'),
              style: TextStyle(color: Colors.black))),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
              child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("user_register_screen_title"),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold))),
                Container(
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("user_register_screen_subtitle"),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal))),
              ],
            ),
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                AppLocalizations.of(context)
                    .translate("user_register_screen_selected_text"),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              ),
            ),
          ),
          Consumer<RegisteredCasesModel>(
            builder: (context, model, child) {
              if (model.reportedCases.length > 0) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == model.reportedCases.length) {
                      return Align(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(AppLocalizations.of(context)
                                .translate("user_register_screen_add_text")),
                          ),
                        ),
                        alignment: Alignment.bottomRight,
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10.0, bottom: 10.0),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Provider.of<RegisteredCasesModel>(context,
                                          listen: false)
                                      .reportedCases
                                      .remove(model.reportedCases[index]);
                                });
                                if (Provider.of<RegisteredCasesModel>(context,
                                            listen: false)
                                        .reportedCases
                                        .length ==
                                    0) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Icon(Icons.remove_circle),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              model.reportedCases[index].caseNumber,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ],
                        ),
                      );
                    }
                  }, childCount: model.reportedCases.length + 1),
                );
              } else {
                return SliverToBoxAdapter(
                    child: Padding(
                        child: Text(AppLocalizations.of(context)
                            .translate("user_registration_screen_no_text")),
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0)));
              }
            },
          ),
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
                        onSaved: (val) {
                          setState(() {
                            _name = val;
                          });
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
                          if (val.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate("user_register_screen_invalid_age");
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            _age = val;
                          });
                        },
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate("user_register_screen_age"),
                            icon: Icon(
                              Icons.date_range,
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
                    // TextFormField(
                    //     validator: (val) {
                    //       if (val.isEmpty || !val.contains("@")) {
                    //         return AppLocalizations.of(context).translate(
                    //             "user_register_screen_invalid_email");
                    //       }
                    //     },
                    //     onSaved: (val) {
                    //       setState(() {
                    //         _email = val;
                    //       });
                    //     },
                    //     keyboardType: TextInputType.emailAddress,
                    //     decoration: InputDecoration(
                    //         labelText: AppLocalizations.of(context)
                    //             .translate("user_register_screen_email"),
                    //         icon: Icon(
                    //           Icons.email,
                    //           color: TrackerColors.primaryColor,
                    //         ),
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(15.0),
                    //           borderSide: BorderSide(
                    //             color: TrackerColors.primaryColor,
                    //           ),
                    //         ))),
                    // SizedBox(
                    //   height: 15.0,
                    // ),
                    TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter a valid home address";
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            _address = val;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate("home_address"),
                            icon: Icon(
                              Icons.home,
                              color: TrackerColors.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: TrackerColors.primaryColor,
                              ),
                            ))),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(AppLocalizations.of(context)
                        .translate("sri_lankan_citizan")),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                                AppLocalizations.of(context)
                                    .translate("radio_yes"),
                                style: TextStyle(color: Colors.black)),
                            Radio(
                              value: "Yes",
                              groupValue: _citizenStatus,
                              onChanged: (value) {
                                setState(() {
                                  _citizenStatus = value;
                                  _passport = "";
                                  _country = "Sri Lanka";
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                                AppLocalizations.of(context)
                                    .translate("radio_no"),
                                style: TextStyle(color: Colors.black)),
                            Radio(
                              value: "No",
                              groupValue: _citizenStatus,
                              onChanged: (value) {
                                setState(() {
                                  _citizenStatus = value;
                                  _nic = "";
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    _citizenStatus == "Yes"
                        ? TextFormField(
                            validator: (val) {
                              if (!val.isEmpty) {
                                RegExp regExp = new RegExp(
                                  r"^([0-9]{9}[x|X|v|V]|[0-9]{12})$",
                                  caseSensitive: false,
                                  multiLine: false,
                                );
                                if (!regExp.hasMatch(val)) {
                                  return "Number is invalid";
                                }
                              } else {
                                return "Number is invalid";
                              }
                            },
                            onSaved: (val) {
                              setState(() {
                                _nic = val;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate("nic_no"),
                                icon: Icon(
                                  Icons.account_box,
                                  color: TrackerColors.primaryColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: TrackerColors.primaryColor,
                                  ),
                                )))
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FutureBuilder<List<String>>(
                                future: _fetchCountries(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Center(
                                        child: Text(
                                            "Whoops, something has gone wrong, try again."),
                                      );
                                      break;
                                    case ConnectionState.waiting:
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                      break;
                                    case ConnectionState.active:
                                      return Center(
                                        child: Text(
                                            "Whoops, something has gone wrong, try again."),
                                      );
                                      break;
                                    case ConnectionState.done:
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Icon(Icons.flag),
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 15.0),
                                              height: 60.0,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          String>(
                                                hint: Padding(
                                                  child: Text(
                                                      "Select your country"),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                ),
                                                items: snapshot.data
                                                    .map((value) =>
                                                        DropdownMenuItem(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child:
                                                                  Text(value),
                                                            ),
                                                            value: value))
                                                    .toList(),
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _country = value;
                                                  });
                                                },
                                                value: _country,
                                              )),
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 1.0,
                                                      style: BorderStyle.solid,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    default:
                                      return Center(
                                          child: CircularProgressIndicator());
                                  }
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Passport number is invalid";
                                    }
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      _passport = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)
                                          .translate("passport_number"),
                                      icon: Icon(
                                        Icons.card_travel,
                                        color: TrackerColors.primaryColor,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                          color: TrackerColors.primaryColor,
                                        ),
                                      ))),
                            ],
                          ),
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
                        onSaved: (val) {
                          setState(() {
                            _mobileNumber = val;
                          });
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.person),
                        Expanded(
                          child: Container(
                            height: 60.0,
                            margin: const EdgeInsets.only(left: 15.0),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(AppLocalizations.of(context)
                                    .translate("select_a_gender")),
                              ),
                              items: [
                                AppLocalizations.of(context)
                                    .translate("menu_item_male"),
                                AppLocalizations.of(context)
                                    .translate("menu_item_female"),
                                AppLocalizations.of(context)
                                    .translate("menu_item_other")
                              ]
                                  .map((value) => DropdownMenuItem(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(value),
                                      ),
                                      value: value))
                                  .toList(),
                              onChanged: (String value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                              value: _gender,
                            )),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),

                    AnimatedTrackerButton(
                      child: _currentBtnChild,
                      active: _registerBtnStatus,
                      width: _registerBtnWidth,
                      height: _registerBtnHeight,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _saveRegistration();
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

  void _saveRegistration() async {
    print("Working...");
    setState(() {
      _currentBtnChild = _registerCircleProgress;
      _registerBtnWidth = 100.0;
      _registerBtnHeight = 50.0;
      _registerBtnStatus = false;
    });
    if (_citizenStatus == "Yes") {
      _country = "Sri Lanka";
    }
    List<ReportedCase> _cases =
        Provider.of<RegisteredCasesModel>(context, listen: false).reportedCases;
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    Registration registration = Registration(
        name: _name,
        email: _email,
        address: _address,
        longitude: 0,
        lattitude: 0,
        age: _age,
        nic: _nic,
        mobileImei: "1234",
        caseList: _cases.map((rCase) => rCase.caseNumber).toList(),
        passport: _passport,
        country: _country,
        gender: _gender);

    print(registration);

    try {
      await GetIt.instance<DataRepository>().registerUser(registration);

      setState(() {
        _currentBtnChild = _registerSuccess;
        _registerBtnHeight = 30.0;
        _registerBtnWidth = 400.0;
        _registerBtnStatus = false;
      });

      await Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
        Provider.of<RegisteredCasesModel>(context, listen: false)
            .reportedCases
            .clear();
      });
    } on DataWriteException catch (e) {
      setState(() {
        _currentBtnChild = _registerFailed;
        _registerBtnHeight = 30.0;
        _registerBtnWidth = 400.0;
        _registerBtnStatus = false;
      });

      await Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _currentBtnChild = _registerTextChild;
          _registerBtnHeight = 30.0;
          _registerBtnWidth = 400.0;
          _registerBtnStatus = true;
        });
      });
    }
  }
}
