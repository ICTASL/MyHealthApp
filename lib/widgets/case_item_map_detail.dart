import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/notifiers/registered_cases_model.dart';
import 'package:selftrackingapp/page/screen/selected_case_detail_screen.dart';
import 'package:selftrackingapp/page/screen/user_register_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';

class CaseItemMapInfo extends StatelessWidget {
  final ReportedCase _case;
  final GestureTapCallback onTapCard;

  CaseItemMapInfo(this._case, this.onTapCard);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 100.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "#${_case.caseNumber}",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w800),
                        ),
                        Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: _case.isLocal
                                      ? Colors.green
                                      : Colors.amber,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  _case.isLocal
                                      ? AppLocalizations.of(context)
                                          .translate("case_item_local")
                                      : AppLocalizations.of(context)
                                          .translate("case_item_foreign"),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: _case.isLocal
                                      ? Colors.purple
                                      : Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  _case.isFromFacility
                                      ? AppLocalizations.of(context)
                                          .translate("case_item_community")
                                      : AppLocalizations.of(context)
                                          .translate("case_item_quarantine"),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      formatDate(_case.createdAt,
                          [yy, '-', M, '-', d, ' ', h, ':', nn, ' ', am]),
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      _case.message,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      AppLocalizations.of(context)
                          .translate("case_item_reported_locations"),
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 4.0),
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
                                  AppLocalizations.of(context)
                                      .translate("case_item_register"),
                                  style: TextStyle(color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
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
                                AppLocalizations.of(context)
                                    .translate("case_item_already_register"),
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
      onTap: onTapCard,
    );
  }
}
