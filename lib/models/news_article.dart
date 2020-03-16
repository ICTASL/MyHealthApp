import 'dart:convert';

import 'data_type.dart';
import 'message_type.dart';

class NewsArticle {
  int id = -1;
  String photoUrl;
  String title = "";
  String subtitle = "";
  String originator = "";
  String message = "";
  DateTime created = DateTime.now();
  MessageType messageType;
  DataType dataType;

  NewsArticle();

  factory NewsArticle.fromJSON(Map data) {
    NewsArticle article = new NewsArticle();
    String sid = data['id'];
    if (sid != null) {
      article.id = int.parse(sid);
    }
    article.title = data['title'];
    article.subtitle = data['subtitle'];
    article.originator = data['source'];
    article.message = data['message'];
    String dt = data['createdTime'] as String;
    if (dt != null) {
      article.created = DateTime.parse(dt);
    }
    article.photoUrl = data['feature_image'];
    switch (data['message_type']) {
      case "Critical":
        article.messageType = MessageType.Critical;
        break;
      case "Warning":
        article.messageType = MessageType.Warning;
        break;
      case "Info":
        article.messageType = MessageType.Info;
        break;
    }
    article.dataType =
        data["Data_type"] == "News" ? DataType.News : DataType.Case;
    return article;
  }
}
