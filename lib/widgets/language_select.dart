import 'package:flutter/material.dart';
import 'package:selftrackingapp/theme.dart';

class LanguageSelectWidget extends StatefulWidget {
  final Function(String language) notifyLanguageChange;

  const LanguageSelectWidget({Key key, this.notifyLanguageChange})
      : super(key: key);

  @override
  _LanguageSelectWidgetState createState() => _LanguageSelectWidgetState();
}

class _LanguageSelectWidgetState extends State<LanguageSelectWidget> {
  String dropdownValue = "English";

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(
        Icons.language,
        color: Colors.white,
      ),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.white, fontSize: 18)
          .copyWith(fontWeight: FontWeight.w500),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          widget.notifyLanguageChange(newValue);
        });
      },
      focusColor: Colors.red,
      items: <String>['Sinhala', 'Tamil', 'English']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: h4TextStyle.copyWith(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
