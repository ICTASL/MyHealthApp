import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selftrackingapp/networking/data_repository.dart';

import '../../app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            AppLocalizations.of(context)
                              .translate("popmenu_privpolicy"),
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          child: FutureBuilder(
            future: GetIt.instance<DataRepository>().fetchPrivacyPolicy(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child:
                        Text("Failed getting privacy policy, try again later"),
                  );
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                  return Center(
                    child:
                        Text("Failed getting privacy policy, try again later"),
                  );
                  break;
                case ConnectionState.done:
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(snapshot.data),
                  );
                  break;
              }
            },
          ),
        ));
  }
}
