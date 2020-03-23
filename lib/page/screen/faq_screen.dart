import 'dart:convert';

import 'package:flutter/material.dart';

import '../../app_localizations.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final jsonStr = AppLocalizations.of(context).translate("faq");
    Map faq = JsonCodec().decode(jsonStr);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context).translate("popmenu_faq"),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            final key = faq.keys.elementAt(index);
            String value = faq.values.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Card(
                elevation: 3,
                child: ListTile(
                  title: Container(
                    margin: EdgeInsets.only(top: 12, bottom: 0),
                    child: Text(
                      key,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      value,
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: faq.length,
        ),
      ),
    );
  }
}
