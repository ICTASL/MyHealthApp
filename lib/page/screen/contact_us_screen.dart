import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/contact_us_contact.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:selftrackingapp/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../theme.dart';
import '../../utils/tracker_colors.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  RemoteConfig remoteConfig;
  bool medicalConsultationAccess = false;

  final defaultConfigs = <String, dynamic>{
    'medical_consultation_access': false
  };

  @override
  void initState() {
    RemoteConfig.instance.then((config) {
      setState(() {
        remoteConfig = config;
        remoteConfig.setDefaults(defaultConfigs).then((val) {
          remoteConfig
              .fetch(expiration: const Duration(seconds: 0))
              .then((val) {
            remoteConfig.activateFetched().then((val) {
              setState(() {
                print(remoteConfig
                    .getValue("medical_consultation_access")
                    .asBool());
                medicalConsultationAccess =
                    remoteConfig.getBool("medical_consultation_access");
                print("Got update $medicalConsultationAccess");
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    BuildContext contextOriginal = context;
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: GetIt.instance<DataRepository>().fetchContactUsContacts(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text(
                      "An error has occured fetching contacts, try again later"),
                );
                break;
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
                break;
              case ConnectionState.active:
                return Center(
                  child: Text(
                      "An error has occured fetching contacts, try again later"),
                );
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  List<ContactUsContact> contacts = snapshot.data;
                  List<ContactUsContact> _contacts = List();

                  for (var concat in contacts) {
                    if (concat.subContacts == null ||
                        medicalConsultationAccess) {
                      _contacts.add(concat);
                    }
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      print(_contacts[index]);
                      return _contactCard(
                          contextOriginal,
                          _contacts[index].title,
                          _contacts[index].phoneNumber,
                          _contacts[index].address,
                          _contacts[index].subContacts);
                    },
                    itemCount: _contacts.length,
                  );
                } else {
                  return Center(
                    child: Text("An error has occured, try again later. "),
                  );
                }
                break;
              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ));
  }

  Widget _contactCard(BuildContext contextParent, String title,
      String phoneNumber, String address, List<ContactUsContact> subContacts) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    subContacts == null
                        ? phoneNumber
                        : AppLocalizations.of(context).translate(phoneNumber),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    AppLocalizations.of(context).translate(title),
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5.0),
                  address.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              address,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () async {
                  if (subContacts == null &&
                      await canLaunch("tel:$phoneNumber")) {
                    await launch("tel:$phoneNumber");
                  } else if (subContacts != null) {
                    await showDialog(
                      barrierDismissible: true,
                      context: contextParent,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        title: Container(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).translate(
                                      "medical_consultation_service_title"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  AppLocalizations.of(context).translate(
                                      "medical_consultation_service_foc"),
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(0.0),
                        content: Container(
                          width: 500,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  color: TrackerColors.primaryColor,
                                  onPressed: () async {
                                    await launch(subContacts[index]
                                        .phoneNumber
                                        .split(",")[Platform.isIOS ? 1 : 0]);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      subContacts[index].title,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: subContacts.length,
                          ),
                        ),
                        actions: [
                          FlatButton(
                              child: Text("Close"),
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop()),
                        ],
                      ),
                    );
                  } else {
                    await showDialog(
                      barrierDismissible: true,
                      context: contextParent,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        title: Text("Oops, something went wrong"),
                        content:
                            Text("Failed to make phone call, try again later."),
                        actions: [
                          FlatButton(
                              child: Text("Ok"),
                              onPressed: () => Navigator.of(context).pop()),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TrackerColors.primaryColor,
                    ),
                    padding: EdgeInsets.all(15.0),
                    child: subContacts == null
                        ? Icon(Icons.phone, color: Colors.white)
                        : Image.asset(
                            "assets/images/medical_consultion.png",
                            height: 24,
                            width: 24,
                          )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
