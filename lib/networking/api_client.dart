import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:selftrackingapp/models/news_article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final _baseUrl = 'http://covid19.egreen.io:8000';

  Future<bool> registerUser() async {
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
    final url = '$_baseUrl/application/alert/latest';
    print('Get last message ID: $url');
    final response = await http.get(url);
    // Was this not a success?
    if (response.statusCode != 200) {
      print('Error getting latest message ID. Status: ' +
          response.statusCode.toString());
      return -1;
    }
    // Decode message ID
    return jsonDecode(response.body) as int;
  }

  Future<NewsArticle> getMessage(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('preferred_language');
    final url = '$_baseUrl/application/alert/$id/$lang';
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    // Was this not a success?
    if (response.statusCode != 200) {
      print('Error getting message: $id. Status: ' +
          response.statusCode.toString());
      return null;
    }
    print("JSON DATA");
    print(response.body);
    var body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    // Create message
    NewsArticle article = NewsArticle.fromJSON(body);
    return article;
  }
}
