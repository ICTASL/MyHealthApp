import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:selftrackingapp/models/reported_case.dart';

class CaseItem extends StatelessWidget {
  final ReportedCase _case;

  CaseItem(this._case);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.trip_origin,
              size: 18.0,
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "CASE " + _case.id.toString(),
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 6.0),
                Text(
                  formatDate(_case.createdAt,
                      [yy, '-', M, '-', d, ' ', h, ':', nn, ' ', am]),
                  style: TextStyle(fontSize: 12.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  _case.message,
                ),
                SizedBox(height: 16.0),
                Text(
                  "Reported locations",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 6.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _case.locations
                      .map((location) => Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(location.address),
                              Text(
                                formatDate(location.from, [
                                      yy,
                                      '-',
                                      M,
                                      '-',
                                      d,
                                      ' ',
                                      h,
                                      ':',
                                      nn,
                                      ' ',
                                      am
                                    ]) +
                                    " - " +
                                    formatDate(location.to, [
                                      yy,
                                      '-',
                                      M,
                                      '-',
                                      d,
                                      ' ',
                                      h,
                                      ':',
                                      nn,
                                      ' ',
                                      am
                                    ]),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(
                                height: 6.0,
                              )
                            ],
                          )))
                      .toList(),
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
