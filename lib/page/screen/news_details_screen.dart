import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:share/share.dart';

class NewsDetailScreen extends StatefulWidget {
  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  DataRepository _dataRepository;

  @override
  void initState() {
    super.initState();
    _dataRepository = GetIt.instance.get<DataRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: _dataRepository.fetchNewsArticles(),
        builder: (context, AsyncSnapshot<List<NewsArticle>> snapshot) {
          List<NewsArticle> articles = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
              return Center(
                child: Text("An error has occured fetching the articles"),
              );
              break;
            case ConnectionState.none:
              return Center(
                child: Text("An error has occured fetching the articles"),
              );
              break;
            case ConnectionState.done:
              return CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.only(
                        top: 50.0, left: 10.0, right: 10.0),
                    sliver: SliverAppBar(
                      backgroundColor: Color(0xff16a33e),
                      automaticallyImplyLeading: false,
                      stretch: true,
                      floating: true,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(30.0),
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 10.0, left: 20.0, right: 20.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "11",
                                    style: TextStyle(
                                        fontSize: 40.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Total Cases",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              GestureDetector(
                                child: Icon(Icons.keyboard_arrow_right,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Text(
                        "News",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Container(
                            padding: const EdgeInsets.all(30.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                        placeholder: (context, val) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                        errorWidget: (context, val, error) {
                                          return Text("Failed to get image");
                                        },
                                        imageUrl: articles[index].photoUrl,
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            height: 50.0,
                                            width: 50.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        }),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          articles[index].originator,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                        Text(
                                          "8th March 12:45", //published data needs to facilitated into the messages from the API
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  articles[index].message,
                                  style: Theme.of(context).textTheme.body1,
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
                                      Share.share(
                                          "Shared button not implemented yet");
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
                    }, childCount: articles.length),
                  )
                ],
              );
              break;
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
          }
        },
      ),
    );
  }
}
