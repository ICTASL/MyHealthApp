import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:selftrackingapp/models/contact_us_contact.dart';
import 'package:logger/logger.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:http/http.dart' as http;

abstract class DB {
  Future<List<ReportedCase>> fetchCases(String lang);
  Future<List<NewsArticle>> fetchNewsArticles();

  Future<int> fetchCaseTotal() {}
  Future<String> fetchPrivacyPolicy();
  Future<List<ContactUsContact>> fetchContactUsContacts() {}
}

class AppDatabase implements DB {
  List<NewsArticle> articles = List();

  // DummyDatabase() {
//    for (int i = 0; i < 10; i++) {
//      String json =
//          "{\"Message_id\":$i, \"Data\":{\"Title\":\"Article Title are Bad\",\"Subtitle\":\"subtitles are ok\",\"Originator\":\"News Dept\",\"Message\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\",\"Feature_image\":\"https://i.ytimg.com/vi/ZCmSRqhgyps/maxresdefault.jpg\"},\"Message_type\":\"Critical\",\"Data_type\":\"Case\"}";
////      articles.add(NewsArticle.fromJSON(jsonDecode(json)));
//    }
  // }

  @override
  Future<List<ReportedCase>> fetchCases(String lang) async {
    List<ReportedCase> _cases = [];

    http.Response response =
        await http.get('http://covid19.egreen.io:8000/application/case/latest');

    int casesLength = json.decode(response.body);

    for (int i = 1; i < casesLength + 1; i++) {
      http.Response res = await http.get(
          'http://covid19.egreen.io:8000/application/case/$i/$lang',
          headers: {'Content-Type': 'application/json'});

      _cases.add(ReportedCase.fromJson(json.decode(res.body)));
    }

    return _cases;
  }

  @override
  Future<List<NewsArticle>> fetchNewsArticles() async {
    return await Future.delayed(
        const Duration(milliseconds: 2), () => articles);
  }

  @override
  Future<int> fetchCaseTotal() async {
    return await Future.delayed(const Duration(milliseconds: 2), () => 125);
  }

  @override
  Future<List<ContactUsContact>> fetchContactUsContacts() async {
    String jsonString =
        await rootBundle.loadString('assets/data/constant_data.json');
    Map<String, dynamic> map = jsonDecode(jsonString);
    List<ContactUsContact> contacts = List();
    (map['contact_us_contacts'] as List).forEach((va) {
      contacts.add(ContactUsContact.fromJSON(va));
    });
    return contacts;
  }

  @override
  Future<String> fetchPrivacyPolicy() async {
    String jsonString =
        await rootBundle.loadString('assets/data/constant_data.json');
    Map<String, dynamic> map = jsonDecode(jsonString);

    return map['privacy_policy'];
  }
}
