import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_localizations.dart';

class IOSFAQScreen extends StatefulWidget {
  @override
  _IOSFAQScreenState createState() => _IOSFAQScreenState();
}

class _IOSFAQScreenState extends State<IOSFAQScreen> {
  @override
  Widget build(BuildContext context) {
    final jsonStr = AppLocalizations.of(context).translate("faq");
    List<dynamic> faqs = JsonCodec().decode(jsonStr);
    Map faq = new Map();
    for (var obj in faqs) {
      faq.addAll(obj);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "FAQ",
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
            if (key.toString().contains("section")) {
              return Container(
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Card(
                elevation: 3,
                child: ListTile(
                  title: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
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
