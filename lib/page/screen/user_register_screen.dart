import 'package:flutter/material.dart';

class UserRegisterScreen extends StatelessWidget {
  final List<String> items = <String>['Name', 'E-mail', 'Mobile Number'];
  final List<TextEditingController> edit = <TextEditingController>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Registration"),
      ),
      body: ListView.separated(
          padding: EdgeInsets.all(8),
          itemBuilder: (BuildContext context, int index) {
            if (index == items.length) {
              return RaisedButton(
                child: Text("Register"),
                color: Colors.blue,
                textColor: Colors.white,
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
                border: OutlineInputBorder(),
                labelText: items[index],
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
