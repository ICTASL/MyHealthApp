import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/notifiers/stories_model.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:share/share.dart';

import '../../models/news_article.dart';
import '../../models/news_article.dart';
import '../../networking/api_client.dart';
import '../../utils/tracker_colors.dart';

enum CounterType { confirmed, recovered, suspected, deaths }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

    updateRemoteConfig();
    _timer = Timer.periodic(Duration(minutes: 15), (timer) {
      updateRemoteConfig();
    });

    fetchArticles();
  }

  Future<void> fetchArticles() async {
    print("Fetching the articles");
    int id = await ApiClient().getLastMessageId();
    int lowerID = 1;
    if (id >= 10) {
      lowerID = id - 9;
    }
    List<NewsArticle> articles = await ApiClient().getArticleList(
      lowerID,
      id,
    );
    articles.forEach((e) {
      Provider.of<StoriesModel>(context, listen: false).add(e);
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
    print(Provider.of<StoriesModel>(context).articles.length);
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
              child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("ui_general_welcome"),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold))),
                Container(
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("dashboard_screen_figures"),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal))),
              ],
            ),
          )),
          SliverPadding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                children: [
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_screen_confirmed"),
                      "$confirmed"),
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_screen_suspected"),
                      "$recovered"),
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_screen_recovered"),
                      "$suspected"),
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_screen_deaths"),
                      "$deaths"),
                ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                "${AppLocalizations.of(context).translate('dashboard_screen_last_updated')} ${lastUpdated.toString()}",
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
                        text:
                            " ${AppLocalizations.of(context).translate('dashboard_screen_news')}",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))
                  ]),
                ))),
          ),
          SliverToBoxAdapter(
            child: Divider(),
          ),
          FutureBuilder(
            future: fetchArticles(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text("An error has occured, try again"),
                    ),
                  );
                  break;
                case ConnectionState.waiting:
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                  break;
                case ConnectionState.active:
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text("An error has occured, try again"),
                    ),
                  );
                  break;
                case ConnectionState.done:
                  return Consumer<StoriesModel>(
                    builder: (context, model, child) {
                      print("CHANGED: ${model.articles.length}");
                      List<NewsArticle> stories = model.articles;
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return _createNewsArticle(stories[index]);
                        }, childCount: stories.length),
                      );
                    },
                  );
                  break;
                default:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
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
            color: TrackerColors.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              figure,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                  color: Colors.white),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
