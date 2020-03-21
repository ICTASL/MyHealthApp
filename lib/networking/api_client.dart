import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:selftrackingapp/constants.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../models/news_article.dart';

class ApiClient {
//  final String _baseUrl = 'https://api.covid-19.health.gov.lk';
  final String _baseUrl;

  ApiClient()
      : _baseUrl = debugRelease
            ? 'http://covid19.egreen.io:8000'
            : 'https://api.covid-19.health.gov.lk';

  Future<bool> registerUser(u) async {
    final url = '$_baseUrl/user/register';
    final response = await http.post(url);
    // Was this not a success?
    if (response.statusCode != 200) {
      print(
          'Error registering user. Status: ' + response.statusCode.toString());
      return false;
    }
    return true;
  }

  Future<int> getLastMessageId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastMessageId = prefs.getInt("last_message_id");
    if (lastMessageId == null) {
      lastMessageId = 0;
    }

    final url = '$_baseUrl/application/alert/latest';
    print('Get last message ID: $url');
    final response = await http.get(url);
    // Was this not a success?
    if (response.statusCode != 200) {
      print('Error getting latest message ID. Status: ' +
          response.statusCode.toString());
      return -1;
    }
    int lastMessageServerId = jsonDecode(response.body) as int;
    if (lastMessageId < lastMessageServerId) {
      prefs.setInt("last_message_id", lastMessageServerId);
      lastMessageId = lastMessageServerId;
    }

    return lastMessageId;
  }

  Future<List<NewsArticle>> getArticleList(startId, endId,
      {forceUpdate = false}) async {
    //this will run everytime th user switchs tabs.
    List<NewsArticle> articles = [];
//
    for (var i = startId; i <= endId; i++) {
      NewsArticle article = await getMessage(i, forceUpdate: forceUpdate);
      print("FETCHED ARTICLE: ${article.id}");
      if (article != null) articles.add(article);
    }

    return articles;
  }

  Future<NewsArticle> getMessage(int id, {forceUpdate = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('preferred_language');
    final sharedPrefId = "alert_$lang--$id";

    String alertData = prefs.getString(sharedPrefId);

    if (alertData == null || forceUpdate) {
      final url = '$_baseUrl/application/alert/$id/$lang';
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        print('Error getting message: $id. Status: ' +
            response.statusCode.toString());
        return null;
      }
      alertData = utf8.decode(response.bodyBytes);
      prefs.setString(sharedPrefId, alertData);
    }

    // Create message
    var body = jsonDecode(alertData) as Map<String, dynamic>;

    NewsArticle article = NewsArticle.fromJSON(body);
    return article;
  }

  Future<List<ReportedCase>> getCaseList(startId, endId,
      {forceUpdate = false}) async {
    //this will run everytime th user switchs tabs.
    List<ReportedCase> articles = [];
//
    for (var i = startId; i <= endId; i++) {
      ReportedCase article = await getCase(i, forceUpdate: forceUpdate);
      if (article != null) articles.add(article);
    }

    return articles;
  }

  Future<ReportedCase> getCase(int id, {forceUpdate = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('preferred_language');
    final sharedPrefId = "alert_$lang--$id";

    String alertData = prefs.getString(sharedPrefId);

    if (alertData == null || forceUpdate) {
      final url = '$_baseUrl/application/case/$id/$lang';
      print("Requesting data from $url");
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        print('Error getting message: $id. Status: ' +
            response.statusCode.toString());
        return null;
      }
      alertData = utf8.decode(response.bodyBytes);
      prefs.setString(sharedPrefId, alertData);
    }

    // Create message
    var body = jsonDecode(alertData) as Map<String, dynamic>;
    ReportedCase article = ReportedCase.fromJson(body);

    return article;
  }

  Future<int> getLastCaseId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastMessageId = prefs.getInt("last_case_id");
    if (lastMessageId == null) {
      lastMessageId = 0;
    }

    final url = '$_baseUrl/application/case/latest';
    print('Get last message ID: $url');
    final response = await http.get(url);
    // Was this not a success?
    if (response.statusCode != 200) {
      print('Error getting latest message ID. Status: ' +
          response.statusCode.toString());
      return -1;
    }
    int lastMessageServerId = jsonDecode(response.body) as int;
    if (lastMessageId < lastMessageServerId) {
      prefs.setInt("last_case_id", lastMessageServerId);
      lastMessageId = lastMessageServerId;
    }

    return lastMessageId;
  }

  Future<Map<String, dynamic>> getDashboardStatus() async {
    var result = Map<String, dynamic>();
    final url = '$_baseUrl/application/dashboard/status';
    // print('Get Dashboard status: $url');
    final response = await http.get(url);
    // Was this not a success?
    if (response.statusCode != 200) {
      print('Error getting Dashboard status. Status: ' +
          response.statusCode.toString());
      return result;
    }
    result = jsonDecode(response.body) as Map<String, dynamic>;
    // print('Dashboard info: $result');
    return result;
  }
}
