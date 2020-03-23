import 'package:flutter/material.dart';
import '../app_localizations.dart';

class IOSFAQScreen extends StatefulWidget {
  @override
  _IOSFAQScreenState createState() => _IOSFAQScreenState();
}

class _IOSFAQScreenState extends State<IOSFAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context)
                              .translate("popmenu_ios_faq"),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Center(
        child: Text("iOS FAQ"),
      ),
    );
  }
}
