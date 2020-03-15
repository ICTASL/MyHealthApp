import 'dart:convert';

import 'data_type.dart';
import 'message_type.dart';

class NewsArticle {
  NewsArticle._();

  factory NewsArticle.fromJSON(Map data) {
    NewsArticle article = new NewsArticle._();
    article.id = data['Message_id'];
    article.title = data["Data"]['Title'];
    article.subtitle = data["Data"]["Subtitle"];
    article.originator = data["Data"]["Originator"];
    article.message = data["Data"]["Message"];
    article.photoUrl = data["Data"]["Feature_image"];
    switch (data["Message_type"]) {
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

  int _id;
  String _photoUrl;
  String _title;
  String _subtitle;
  String _originator;
  String _message;
  MessageType _messageType;
  DataType _dataType;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  MessageType get messageType => _messageType;

  set messageType(MessageType messageType) {
    _messageType = messageType;
  }

  DataType get dataType => _dataType;

  set dataType(DataType dataType) {
    _dataType = dataType;
  }

  String get message => _message;

  set message(String message) {
    _message = message;
  }

  String get originator => _originator;

  set originator(String originator) {
    _originator = originator;
  }

  String get subtitle => _subtitle;

  set subtitle(String subtitle) {
    _subtitle = subtitle;
  }

  String get title => _title;

  set title(String title) {
    _title = title;
  }

  String get photoUrl => _photoUrl;

  set photoUrl(String photoUrl) {
    _photoUrl = photoUrl;
  }
}
