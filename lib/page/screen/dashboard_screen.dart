import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/message_type.dart';
import 'package:selftrackingapp/notifiers/stories_model.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:share/share.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/news_article.dart';
import '../../networking/api_client.dart';
import '../../utils/tracker_colors.dart';

enum CounterType { confirmed, recovered, suspected, deaths }

DateFormat dateFormat = DateFormat("dd-MM-yy HH:mm");

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const MethodChannel _channel = MethodChannel('location');
  RemoteConfig config;
  PageController _pageController;

  // Remotely configured values
  DateTime lastUpdated = DateTime.now();
  int confirmed = 0;
  int recovered = 0;
  int suspected = 0;
  int deaths = 0;
  int resetIndexServer = 0;
  Future<void> _articleFetch;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    updateDashboard();
    _articleFetch = fetchArticles();

    _timer = Timer.periodic(Duration(minutes: 15), (timer) {
      if (this.mounted) {
        updateDashboard();
      }
    });

    _channel.invokeMethod('requestLocationPermission').then((res) {
      _channel.invokeMethod('openLocationService').then((res) {});
    });
  }

  Future<void> fetchArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool forceUpdate = true;

    print("Fetching the articles");
    int id = await ApiClient().getLastMessageId();
    print("last fetched $id");
    int lowerID = 1;
    if (id >= 10) {
      lowerID = id - 9;
    }
    List<NewsArticle> articles =
        await ApiClient().getArticleList(lowerID, id, forceUpdate: forceUpdate);
    articles.forEach((e) {
      Provider.of<StoriesModel>(context, listen: false).add(e);
    });
  }

  Future<void> updateDashboard() async {
    var map = await ApiClient().getDashboardStatus();
    setState(() {
      confirmed = map['lk_total_case'] ?? 57;
      recovered = map['lk_recovered_case'] ?? 2;
      suspected = map['lk_total_suspect'] ?? 243;
      deaths = map['lk_total_deaths'] ?? 0;
      String dt = map['last_update_time'] ?? '2020-03-20 09:39';
      lastUpdated = DateTime.parse(dt);
    });
    // Keep updating reset index via Remote Config
    config = await RemoteConfig.instance;
    final defaults = <String, dynamic>{"reset_index": 0};
    await config.setDefaults(defaults);
    await config.fetch(expiration: Duration(minutes: 15 - 1));
    await config.activateFetched();
    setState(() {
      resetIndexServer = config.getInt('reset_index');
    });
  }

  void _shareArticle(NewsArticle article) {
    Share.share("${article.title}\n\n"
        "${article.subtitle}\n\n"
        "by ${article.originator}\n"
        "${dateFormat.format(article.created)}\n\n"
        "${article.message}");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(
                text: AppLocalizations.of(context)
                    .translate("dashboard_news_text"),
              ),
              Tab(
                text: AppLocalizations.of(context)
                    .translate("dashboard_latest_figures_title"),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                _buildNewsScreen(),
                _buildStatScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createNewsArticle(NewsArticle article) {
    print(
        "${article.id} ${article.title},${article.message} ${article.created}");

    Icon _icon = Icon(
      Icons.info,
      color: Colors.blue,
    );

    switch (article.messageType) {
      case MessageType.Critical:
        _icon = Icon(
          Icons.report,
          color: Colors.red,
          size: 30.0,
        );
        break;
      case MessageType.Warning:
        _icon = Icon(
          Icons.warning,
          color: Colors.amber,
          size: 30.0,
        );
        break;
      case MessageType.Info:
        _icon = Icon(
          Icons.info,
          color: Colors.blue,
          size: 30.0,
        );
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: TrackerColors.primaryColor[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _icon,
                      SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: Text(
                          article.title,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.title.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    article.subtitle,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "by ${article.originator}",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${dateFormat.format(article.created)}",
                      //published data needs to facilitated into the messages from the API
                      style: Theme.of(context).textTheme.body1,
                    ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      _shareArticle(article);
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.grey,
                    ),
                  ),
                  FlatButton(
                    child: Text(AppLocalizations.of(context)
                        .translate("news_list_read_more_text")),
                    onPressed: () {
                      _showNewsArticle(article);
                    },
                  )
                ],
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewsArticle(NewsArticle article) {
    Icon _icon = Icon(
      Icons.info,
      color: Colors.blue,
    );

    switch (article.messageType) {
      case MessageType.Critical:
        _icon = Icon(
          Icons.report,
          color: Colors.red,
          size: 30.0,
        );
        break;
      case MessageType.Warning:
        _icon = Icon(
          Icons.warning,
          color: Colors.amber,
          size: 30.0,
        );
        break;
      case MessageType.Info:
        _icon = Icon(
          Icons.info,
          color: Colors.blue,
          size: 30.0,
        );
        break;
    }

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Color(TrackerColors.secondaryColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _icon,
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Text(
                        article.title,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.title.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  article.subtitle,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "by ${article.originator}",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.body1,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${dateFormat.format(article.created)}",
                    //published data needs to facilitated into the messages from the API
                    style: Theme.of(context).textTheme.body1,
                  ),
                )
              ],
            ),
            content: Text(
              article.message,
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  _shareArticle(article);
                },
                icon: Icon(
                  Icons.share,
                  color: Colors.black,
                ),
              ),
            ],
          );
        });
  }

  Widget _buildNewsScreen() {
    return FutureBuilder(
      future: _articleFetch,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text("An error has occured, try again"),
            );
            break;
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
            return Center(
              child: Text("An error has occured, try again"),
            );
            break;
          case ConnectionState.done:
            return Consumer<StoriesModel>(
              builder: (context, model, child) {
                print("CHANGED: ${model.articles.length}");
                List<NewsArticle> stories = model.articles;
                return ListView.builder(
                    itemCount: stories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _createNewsArticle(stories[index]);
                    });
              },
            );
            break;
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Widget _buildStatScreen() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: GridView.count(
                padding: const EdgeInsets.all(10.0),
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                childAspectRatio: 7 / 6,
                children: [
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_confirmed_card_text"),
                      "$confirmed"),
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_suspected_card_text"),
                      "$suspected"),
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_recovered_card_text"),
                      "$recovered"),
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_deaths_card_text"),
                      "$deaths"),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "${AppLocalizations.of(context).translate('dashboard_last_updated_text')} ${dateFormat.format(lastUpdated)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
