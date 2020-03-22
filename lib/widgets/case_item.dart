import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/notifiers/registered_cases_model.dart';
import 'package:selftrackingapp/page/screen/case_details_screen.dart';
import 'package:selftrackingapp/page/screen/user_register_screen.dart';
import 'package:selftrackingapp/page/screen/selected_case_detail_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';

class CaseItem extends StatelessWidget {
  final ReportedCase _case;

  CaseItem(this._case);

  @override
  Widget build(BuildContext context) {
    var source = _case.isLocal ? 'Local' : 'Imported';
    source += ', from: ' +
        (_case.isFromFacility ? 'Quarantine Facility' : 'Community');
    return GestureDetector(
      child: Container(
        width: 100.0,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.trip_origin,
              size: 18.0,
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Container(
                child: Column(
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
                      source,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      _case.message,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "Reported locations",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 6.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _case.locations
                          .map((location) => Container(
                              width: MediaQuery.of(context).size.width / 2,
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
                                        " to " +
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
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: !Provider.of<RegisteredCasesModel>(context)
                                .reportedCases
                                .contains(_case)
                            ? RaisedButton(
                                color: TrackerColors.primaryColor,
                                child: Text(
                                  "REGISTER ME, I WAS THERE",
                                  style: TextStyle(color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                onPressed: () {
                                  Provider.of<RegisteredCasesModel>(context,
                                          listen: false)
                                      .add(
                                    _case,
                                  );
                                  RegisteredCasesModel model =
                                      Provider.of<RegisteredCasesModel>(context,
                                          listen: false);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider.value(
                                      value: model,
                                      child: UserRegisterScreen(),
                                    ),
                                  ));
                                },
                              )
                            : Text(
                                "Already Added for Registration",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => _showCasDetails(context, _case.id),
    );
  }

  void _showCasDetails(BuildContext context, int id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectedCaseDetailScreen(
                  reportedCase: _case,
                )));
  }
}
