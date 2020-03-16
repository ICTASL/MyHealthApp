import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/networking/api_client.dart';
import 'package:selftrackingapp/theme.dart';
import 'package:share/share.dart';

import '../../app_localizations.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsArticle article;

  const NewsDetailScreen({Key key, this.article}) : super(key: key);

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(widget.article.title),
        ),
        body: Container(
            decoration: BoxDecoration(
                color: Color(0xff7c94b6),
                image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.white.withOpacity(0.8), BlendMode.dstATop),
                    image: AssetImage("assets/images/bg.png"),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(8.0)),
                        color: colorAccentBackground,
                        boxShadow: [backgroundBoxShadow]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.article.originator,
                            textAlign: TextAlign.start,
                            style:
                                h2TextStyle.copyWith(color: primaryColorText),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "8th March 12:45",
                              //published data needs to facilitated into the messages from the API
                              textAlign: TextAlign.start,
                              style: h6TextStyle.copyWith(
                                  color: primaryColorText.withOpacity(0.5)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              widget.article.message,
                              style: h5TextStyle.copyWith(
                                  color: primaryColorText.withOpacity(0.7)),
                            ),
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
                ),
              ],
            )));
  }
}
