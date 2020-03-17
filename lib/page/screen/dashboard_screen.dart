import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:share/share.dart';

enum CounterType { confirmed, recovered, suspected, deaths }

class DashboardScreen extends StatefulWidget {
  final Stream<NewsArticle> articleStream;

  const DashboardScreen({Key key, this.articleStream}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<NewsArticle> stories = [];

  // Remotely configured values
  DateTime lastUpdated = DateTime.now();
  int confirmed = 0;
  int recovered = 0;
  int suspected = 0;
  int deaths = 0;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.articleStream.listen((NewsArticle article) async {
      print("Article Updte ${article}");
      setState(() {
        stories.add(article);
      });
    });

    updateRemoteConfig();
    _timer = Timer.periodic(Duration(minutes: 15), (timer) {
      updateRemoteConfig();
    });
  }

  void updateRemoteConfig() async {
    final RemoteConfig config = await RemoteConfig.instance;
    final defaults = <String, dynamic>{
      'last_updated': '2020-03-17 10:15',
      'confirmed': 28,
      'recovered': 1,
      'suspected': 212,
      'deaths': 0
    };
    await config.setDefaults(defaults);
    await config.fetch(expiration: Duration(minutes: 15 - 1));
    await config.activateFetched();
    setState(() {
      confirmed = config.getInt('confirmed');
      recovered = config.getInt('recovered');
      suspected = config.getInt('suspected');
      deaths = config.getInt('deaths');
      String dt = config.getString('last_updated');
      lastUpdated = DateTime.parse(dt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
              child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text("Welcome.",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold)))),
                Container(
                    child: Text("Here are the Latest Figures.",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal)))),
              ],
            ),
          )),
          SliverPadding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                childAspectRatio: 6 / 4,
                children: [
                  _createCountCard("Confirmed", "$confirmed"),
                  _createCountCard("Suspected", "$recovered"),
                  _createCountCard("Recovered", "$suspected"),
                  _createCountCard("Deaths", "$deaths"),
                ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Last Updated: ${lastUpdated.toString()}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            sliver: SliverToBoxAdapter(
              child: Container(),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            backgroundColor: Theme.of(context).backgroundColor,
            title: PreferredSize(
                preferredSize: Size.fromHeight(30.0),
                child: Container(
                    child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: " News",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)))
                  ]),
                ))),
          ),
          SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _createNewsArticle(stories[index]);
            }, childCount: stories.length),
          )
        ],
      ),
    );
  }

  Widget _createNewsArticle(NewsArticle article) {
    print(
        "${article.id} ${article.title},${article.message} ${article.created}");
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Color(TrackerColors.secondaryColor),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        article.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      ),
                      Text(
                        "${article.created}",
                        //published data needs to facilitated into the messages from the API
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.grey[400],
              ),
              Text(
                article.message,
                style: TextStyle(color: Colors.black),
              ),
              Container(
                child: Divider(
                  color: Colors.grey[400],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Share.share("Shared button not implemented yet");
                  },
                  child: Icon(
                    Icons.share,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createCountCard(String title, String figure) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.1,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Color(TrackerColors.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
            Text(
              figure,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
