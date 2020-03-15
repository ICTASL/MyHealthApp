import 'package:flutter/material.dart';
import 'package:selftrackingapp/models/case.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/widgets/case_item.dart';

class CaseListScreen extends StatefulWidget {
  @override
  _CaseListScreenState createState() => _CaseListScreenState();
}

class _CaseListScreenState extends State<CaseListScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Case List"),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.filter_list,
              ),
              onPressed: () {},
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              child: Text(
                "CASES",
                style: TextStyle(fontSize: 48),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.black26,
              height: 1.0,
            ),
            Material(
              elevation: 12.0,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: Column(
                            children: <Widget>[
                              Text("NEWEST"),
                              SizedBox(height: 16.0),
                              _selectedTab == 0
                                  ? Container(
                                      height: 4.0,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                        Color(0xff4a00e0),
                                        Color(0xff0cebeb)
                                      ])),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        onTap: () => _changeTab(0),
                      ),
                    ),
                    Container(
                      color: Colors.black26,
                      height: 52,
                      width: 1.0,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: Column(
                            children: <Widget>[
                              Text("TESTED"),
                              SizedBox(height: 16.0),
                              _selectedTab == 1
                                  ? Container(
                                      height: 4.0,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                        Color(0xff4a00e0),
                                        Color(0xff0cebeb)
                                      ])),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        onTap: () => _changeTab(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Color(0xffeceff1),
                  ),
                  // _selectedTab == 0 ? NewestList() : TestedList(),
                ],
              ),
            )
          ],
        ));
  }

  _changeTab(int tab) {
    setState(() {
      _selectedTab = tab;
    });
  }
}

class NewestList extends StatelessWidget {
  final List<Case> _cases;

  NewestList(this._cases);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _cases.length,
      itemBuilder: (BuildContext context, int index) {
        return CaseItem(_cases[index]);
      },
    );
  }
}

class TestedList extends StatelessWidget {
  final List<Case> _cases;

  TestedList(this._cases);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _cases.length,
      itemBuilder: (BuildContext context, int index) {
        return CaseItem(_cases[index]);
      },
    );
  }
}
