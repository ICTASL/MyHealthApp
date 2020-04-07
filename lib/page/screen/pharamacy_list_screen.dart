import 'package:flutter/material.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:selftrackingapp/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_localizations.dart';

class PharmacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
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
                    AppLocalizations.of(context).translate("pharmacy_list"),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
            Container(
              child: GestureDetector(
                  onTap: () async {
                    var link = "https://pharmacy.health.gov.lk/";
                    if (await canLaunch(link)) {
                      await launch(link);
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: TrackerColors.primaryColor,
                      ),
                      padding: EdgeInsets.all(15.0),
                      child: Icon(Icons.web, color: Colors.white))),
            ),
          ],
        ),
      ),
    ));
  }
}

//Container(
//          child: FutureBuilder(
//            future: GetIt.instance<DataRepository>().fetchPrivacyPolicy(),
//            builder: (context, snapshot) {
//              switch (snapshot.connectionState) {
//                case ConnectionState.none:
//                  return Center(
//                    child:
//                        Text("Failed getting privacy policy, try again later"),
//                  );
//                  break;
//                case ConnectionState.waiting:
//                  return Center(
//                    child: CircularProgressIndicator(),
//                  );
//                  break;
//                case ConnectionState.active:
//                  return Center(
//                    child:
//                        Text("Failed getting privacy policy, try again later"),
//                  );
//                  break;
//                case ConnectionState.done:
//                  return Container(
//                    padding: const EdgeInsets.all(20.0),
//                    child: Text(snapshot.data),
//                  );
//                  break;
//              }
//            },
//          ),
//        )
