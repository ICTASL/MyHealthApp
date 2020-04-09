import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/models/message_type.dart';
import 'package:selftrackingapp/notifiers/stories_model.dart';
import 'package:selftrackingapp/page/screen/contact_us_screen.dart';
import 'package:selftrackingapp/page/screen/faq_screen.dart';
import 'package:selftrackingapp/page/screen/news_detail_screen.dart';
import 'package:selftrackingapp/page/screen/pharamacy_list_screen.dart';
import 'package:selftrackingapp/utils/tracker_colors.dart';
import 'package:selftrackingapp/widgets/custom_text.dart';
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

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
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
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _tabController = TabController(length: 3, vsync: this);
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

    int id = await ApiClient().getLastMessageId();
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
    Share.share("${article.title}\n"
        "${article.subtitle}\n"
        "by ${article.originator}\n"
        "${dateFormat.format(article.created)}\n");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              snap: true,
              floating: true,
              backgroundColor: Colors.white,
              flexibleSpace: _buildAppBar(),
              expandedHeight:
                  AppLocalizations.of(context).locale == Locale("ta", "TA")
                      ? 100
                      : 60,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _buildNewsScreen(),
            _buildFaqScreen(),
            _buildPharamcyScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        indicatorColor: TrackerColors.primaryColor,
        tabs: [
          Container(
            constraints: BoxConstraints.expand(),
            child: Center(
              child: Text(AppLocalizations.of(context)
                  .translate("dashboard_news_text")),
            ),
          ),
//          Container(
//            constraints: BoxConstraints.expand(),
//            child: Center(
//              child: Text(AppLocalizations.of(context)
//                  .translate("dashboard_latest_figures_title")),
//            ),
//          ),
          Container(
            constraints: BoxConstraints.expand(),
            child: Center(
              child: Text(AppLocalizations.of(context)
                  .translate("dashboard_contact_tab_text")),
            ),
          ),
          Container(
            constraints: BoxConstraints.expand(),
            child: Center(
              child:
                  Text(AppLocalizations.of(context).translate("pharmacy_tab")),
            ),
          )
        ],
      ),
    );
  }

  Widget _createNewsArticle(NewsArticle article) {
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
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          article.title != null ? article.title : "",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "By ${article.originator}",
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: 12),
                      ),
                      Spacer(),
                      Text(
                        "${dateFormat.format(article.created)}",
                        //published data needs to facilitated into the messages from the API
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[400].withOpacity(0.1),
              ),
              Html(
                data: article.message.length > 350
                    ? article.message.substring(0, 300)
                    : article.message,
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
                      color: Colors.blue,
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate("news_list_read_more_text")
                          .toUpperCase(),
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(
                          article: article,
                        ),
                      ));
//                      _showNewsArticle(article);
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

  Widget _createCountCard(String title, String figure, Color colorCode,
      {width = 100}) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
            color: colorCode.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: colorCode),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                figure,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                    color: colorCode),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
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
                      List<NewsArticle> stories = model.articles;
                      return ListView.builder(
                          itemCount: stories.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return _buildTopStats();
                            } else
                              return _createNewsArticle(stories[index - 1]);
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
          ),
        ),
      ],
    );
  }

  Widget _buildTopStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.only(left: 15, top: 20.0),
        //   child: Text("ONGOING:",
        //       textAlign: TextAlign.start,
        //       style: TextStyle(
        //           color: Colors.black,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 15.0)),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 15),
        //   child: Text("COVID-19 Statistics",
        //       textAlign: TextAlign.start,
        //       style: TextStyle(
        //           color: Colors.black,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 30.0)),
        // ),
        Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height /
              (AppLocalizations.of(context).locale.languageCode == "ta"
                  ? 3
                  : 4),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height / 2,
                          child: _createCountCard(
                            AppLocalizations.of(context)
                                .translate("dashboard_confirmed_card_text"),
                            "$confirmed",
                            Color(0XFFc53030),
                            width: MediaQuery.of(context).size.width / 4,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height / 2,
                          child: _createCountCard(
                              AppLocalizations.of(context)
                                  .translate("dashboard_suspected_card_text"),
                              "$suspected",
                              Color(0XFFed8936),
                              width: MediaQuery.of(context).size.width / 4),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: _createCountCard(
                              AppLocalizations.of(context)
                                  .translate("dashboard_recovered_card_text"),
                              "$recovered",
                              Color(0XFF3ea46d),
                              width: MediaQuery.of(context).size.width),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height / 2,
                          child: _createCountCard(
                              AppLocalizations.of(context)
                                  .translate("dashboard_deaths_card_text"),
                              "$deaths",
                              Color(0XFF303b4b),
                              width: MediaQuery.of(context).size.width),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(top: 2, bottom: 2),
          child: Container(
            width: double.maxFinite,
            child: Text(
              "${AppLocalizations.of(context).translate('dashboard_last_updated_text')} ${dateFormat.format(lastUpdated)}",
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
            ),
          ),
        ),
      ],
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
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                mainAxisSpacing: 10.0,
                childAspectRatio:
                    AppLocalizations.of(context).locale == Locale("ta", "TA")
                        ? 3 / 4
                        : 3 / 3,
                children: [
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_confirmed_card_text"),
                      "$confirmed",
                      Color(0XFFc53030)),
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_suspected_card_text"),
                      "$suspected",
                      Color(0XFFed8936)),
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_recovered_card_text"),
                      "$recovered",
                      Color(0XFF3ea46d)),
                  _createCountCard(
                      AppLocalizations.of(context)
                          .translate("dashboard_deaths_card_text"),
                      "$deaths",
                      Color(0XFF303b4b)),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "${AppLocalizations.of(context).translate('dashboard_last_updated_text')} ${dateFormat.format(lastUpdated)}",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqScreen() {
    return ContactUsScreen();
  }

  Widget _buildPharamcyScreen() {
    return PharmacyScreen();
  }
}
