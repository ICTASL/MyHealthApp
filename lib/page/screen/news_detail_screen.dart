import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selftrackingapp/models/message_type.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

DateFormat dateFormat = DateFormat("dd-MM-yy HH:mm");

class NewsDetailScreen extends StatefulWidget {
  final NewsArticle article;

  const NewsDetailScreen({Key key, this.article}) : super(key: key);

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  String _initialUrl;

  @override
  void initState() {
    super.initState();

    // Adding meta so that it displays the correct size in iOS
    // setting sans-serif font to the content
    var content = """<!DOCTYPE html>
    <html>
      <head><meta name='viewport' content='width=device-width, initial-scale=1.0'></head>
      <body style='margin: 0; padding: 0; font-family:Verdana, Geneva, sans-serif;'>
          ${widget.article.message}
      </body>
    </html>""";
    _initialUrl = Uri.dataFromString(content,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
  }

  void _shareArticle(NewsArticle article) {
    Share.share("${article.title}\n"
        "${article.subtitle}\n"
        "by ${article.originator}\n"
        "${dateFormat.format(article.created)}\n");
  }

  Widget _buildTitle() {
    return Column(
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
                    widget.article.title,
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
                  "By ${widget.article.originator}",
                  textAlign: TextAlign.start,
                  style:
                      Theme.of(context).textTheme.body1.copyWith(fontSize: 12),
                ),
                Spacer(),
                Text(
                  "${dateFormat.format(widget.article.created)}",
                  //published data needs to facilitated into the messages from the API
                  style:
                      Theme.of(context).textTheme.body1.copyWith(fontSize: 12),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Icon _icon = Icon(
      Icons.info,
      color: Colors.blue,
    );

    switch (widget.article.messageType) {
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

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            widget.article.title,
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _shareArticle(widget.article);
              },
              icon: Icon(
                Icons.share,
                color: Colors.blue,
              ),
            )
          ],
        ),
        body: Container(
            child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        _buildTitle(),
                        SizedBox(
                          height: 30.0,
                        ),
                        Divider(),
                        Expanded(
                          child: WebView(
                            initialUrl: _initialUrl,
                            navigationDelegate:
                                (NavigationRequest request) async {
                              if (await canLaunch(request.url)) {
                                await launch(request.url);
                              } else {
                                print("Cannot launch url");
                              }

                              // Workaround for content not showing in iOS
                              // as described here
                              // [https://github.com/flutter/flutter/issues/30256]
                              return request.url == _initialUrl
                                  ? NavigationDecision.navigate
                                  : NavigationDecision.prevent;
                            },
                            javascriptMode: JavascriptMode.unrestricted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }

// var testhtml =
//     "<div style=\"text-align: justify;\">\n  <h2 style=\"line-height: 40.8%;\">What is Lorem Ipsum?</h2><p></p><p><strong>Lorem Ipsum</strong>&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p><h2 style=\"line-height: 40.8%;\">Why do we use it?</h2><p>It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here',</p><ol><li>one</li><li>two</li><li>three</li></ol><p></p>\n</div>";

}
