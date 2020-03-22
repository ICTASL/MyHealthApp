import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:selftrackingapp/exceptions/data_write_exception.dart';
import 'package:selftrackingapp/models/contact_us_contact.dart';
import 'package:logger/logger.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/models/registration.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

abstract class DB {
  Future<List<ReportedCase>> fetchCases(String lang);
  Future<List<NewsArticle>> fetchNewsArticles();

  Future<int> fetchCaseTotal();
  Future<String> fetchPrivacyPolicy();
  Future<List<ContactUsContact>> fetchContactUsContacts();
  Future<void> registerUser(Registration _cases);
  Future<List<String>> fetchCountries();
}

class AppDatabase implements DB {
  List<NewsArticle> articles = List();

  final String _baseUrl;

  AppDatabase()
      : _baseUrl =
            debugRelease ? testingServer : 'https://api.covid-19.health.gov.lk';

  @override
  Future<List<ReportedCase>> fetchCases(String lang) async {
    List<ReportedCase> _cases = [];

    http.Response response =
        await http.get('$testingServer/application/case/latest');

    int casesLength = json.decode(response.body);

    for (int i = 1; i < casesLength + 1; i++) {
      http.Response res = await http.get(
          '$testingServer/application/case/$i/$lang',
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

  @override
  Future<void> registerUser(
    Registration registration,
  ) async {
    final url = '$_baseUrl/dhis/patients';
    print("Registering the user....");
    print(registration.toJson());
    Response response = await http.post(url,
        body: registration.toJson(),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      print("Registered User Successfully");
      return;
    } else {
      print(response.body);
      throw DataWriteException(
          "Could not register user: ${response.statusCode}");
    }
  }

  @override
  Future<List<String>> fetchCountries() async {
    String jsonString =
        await rootBundle.loadString('assets/data/countries.json');
    List<dynamic> jsonMap = jsonDecode(jsonString);
    List<String> _countries = List();
    jsonMap.forEach((listing) {
      _countries.add(listing["OptionCode"]);
    });
    return _countries;
  }
}
