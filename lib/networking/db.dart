import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:selftrackingapp/exceptions/data_fetch_exception.dart';
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
  Future<ReportedCase> fetchCase(String id);
}

class AppDatabase implements DB {
  List<NewsArticle> articles = List();

  @override
  Future<List<ReportedCase>> fetchCases(String lang) async {
    List<ReportedCase> cases = [];
    var response =
        await http.get('http://covid19.egreen.io:8000/application/case/latest');

    if (response.statusCode == 200) {
      print("FETCHING CASE: " + response.body);
      for (int i = 1; i <= int.parse(response.body); i++) {
        print("FETCHING CASE: $i");
        var casesRaw = await http
            .get("http://covid19.egreen.io:8000/application/case/$i/$lang");
        print(casesRaw.statusCode);

        if (casesRaw.statusCode == 200) {
          print(cases.length);
          cases.add(ReportedCase.fromJson(json.decode(casesRaw.body)));
        } else {
          throw DataFetchException(
              "Failed to fetch data: ${casesRaw.statusCode}");
        }
      }
      return cases;
    } else {
      throw DataFetchException("Failed to fetch data: ${response.statusCode}");
    }
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

  @override
  Future<ReportedCase> fetchCase(String id) {
    // TODO: implement fetchCase
    return null;
  }
}
