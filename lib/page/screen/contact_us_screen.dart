import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selftrackingapp/models/contact_us_contact.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_localizations.dart';
import '../../theme.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
            AppLocalizations.of(context).translate('dashboard_screen_title')),
      ),
      body: Container(
          decoration: BoxDecoration(
              color: Color(0xff7c94b6),
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.white.withOpacity(0.8), BlendMode.dstATop),
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover)),
          child: Container(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder(
                future:
                    GetIt.instance<DataRepository>().fetchContactUsContacts(),
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
                      List<ContactUsContact> contacts = snapshot.data;
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          print(contacts[index]);
                          return _contactCard(
                              contacts[index].title,
                              contacts[index].phoneNumber,
                              contacts[index].address);
                        },
                        itemCount: contacts.length,
                      );
                      break;
                    default:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                },
              ))),
    );
  }

  Widget _contactCard(String title, String phoneNumber, String address) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              phoneNumber,
              style: h1TextStyle.copyWith(
                  color: primaryColor, fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            Text(
              title,
              style: h3TextStyle.copyWith(
                  color: primaryColor.withOpacity(0.5),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            Container(height: 5.0),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: RaisedButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  onPressed: () async {
                    if (await canLaunch("tel:$phoneNumber")) {
                      await launch("tel:$phoneNumber");
                    } else {
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          title: const Text("Oops, something went wrong"),
                          content: Text(
                              "Failed to make phone call, try again later."),
                          actions: [
                            FlatButton(
                              child: const Text("Ok"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Icon(Icons.phone, color: Colors.white)),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      address,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
