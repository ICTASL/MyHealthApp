import 'package:flutter/material.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';

class UserRegisterScreen extends StatelessWidget {
  final List<String> items = <String>[
    'user_register_screen_name',
    'user_register_screen_email',
    'user_register_screen_phone'
  ];
  final List<TextEditingController> edit = <TextEditingController>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 10.0
      ),
      child: ListView.separated(
          padding: EdgeInsets.all(8),
          itemBuilder: (BuildContext context, int index) {
            if (index == items.length) {
              return RaisedButton(
                child: Text(
                  AppLocalizations.of(context)
                      .translate('user_register_screen_register'),
                ),
                color: Color(TrackerColors.primaryColor),
                textColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: 12.0
                ),
                onPressed: () {
                  // Submit to DHIS API
                  for (var i = 0; i < edit.length; i++) {
                    // Get field value
                    String value = edit[i].text;
                    print(value);
                  }
                },
              );
            }
            TextEditingController ec = TextEditingController();
            edit.add(ec);
            return TextField(
              controller: ec,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Color(TrackerColors.primaryColor)),
                labelStyle: TextStyle(color: Color(TrackerColors.primaryColor)),
                border: OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                labelText: AppLocalizations.of(context).translate(items[index]),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              height: 16,
            );
          },
          itemCount: items.length + 1),
    );
  }
}
