import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/networking/api_client.dart';
import 'package:selftrackingapp/theme.dart';
import 'package:share/share.dart';

class NewsDetailScreen extends StatefulWidget {
  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  List<NewsArticle> stories = [];

  @override
  void initState() {
    super.initState();
    // Get latest message ID
    ApiClient().getLastMessageId().then((id) {
      if (id == -1) {
        return;
      }
      // Get all messages up to latest
      // TODO: Add saving fetched messages and also a better way to fetch messages instead of one by one after API endpoint is fixed
      for (var i = id; i > 0; i--) {
        ApiClient().getMessage(i).then((article) {
          // Save article for display
          print(article.title);
          setState(() {
            stories.add(article);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
            sliver: SliverAppBar(
              backgroundColor: Color(0xff16a33e),
              floating: true,
              automaticallyImplyLeading: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(30.0),
                child: Container(
                  margin: const EdgeInsets.only(
                      bottom: 10.0, left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
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
                        ],
                      ),
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
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Container(
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            // CachedNetworkImage(
                            //   placeholder: (context, val) {
                            //     return Center(
                            //         child: CircularProgressIndicator());
                            //   },
                            //   errorWidget: (context, val, error) {
                            //     return Text("Failed to get image");
                            //   },
                            //   imageUrl: story.photoUrl,
                            //   imageBuilder: (context, imageProvider) {
                            //     return Container(
                            //       height: 50.0,
                            //       width: 50.0,
                            //       decoration: BoxDecoration(
                            //         color: Colors.black,
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(10.0)),
                            //         image: DecorationImage(
                            //           image: imageProvider,
                            //           fit: BoxFit.cover,
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  stories[index].originator,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  "8th March 12:45", //published data needs to facilitated into the messages from the API
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.black45),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          child: Divider(
                            color: Colors.grey[300],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            stories[index].message,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: Divider(
                            color: Colors.grey[300],
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
            }, childCount: stories.length),
          )
        ],
      ),
    );
  }
}
