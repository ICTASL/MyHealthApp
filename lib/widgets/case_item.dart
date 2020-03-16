import 'package:flutter/material.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/page/screen/case_details_screen.dart';

class CaseItem extends StatelessWidget {
  final ReportedCase _case;

  CaseItem(this._case);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Will update container body to relevant attributes after spring setup
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 12.0, offset: Offset(0, 4.0))
          ],
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.trip_origin,
              size: 18.0,
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_case.locations[0].address),
                SizedBox(height: 10.0),
                Text(
                  "CASE " + _case.id.toString(),
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ],
        ),
      ),
      onTap: () => _showCasDetails(context, _case.id),
    );
  }

  void _showCasDetails(BuildContext context, int id) {
    //Uncomment this after implementing case details screen

    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => CaseDetailScreen(id)));
  }
}
