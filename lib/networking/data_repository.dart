import 'package:selftrackingapp/exceptions/data_fetch_exception.dart';
import 'package:selftrackingapp/models/contact_us_contact.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/models/registration.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/networking/db.dart';

abstract class DataRepository {
  Future<List<ReportedCase>> fetchCases(String lang);
  Future<List<NewsArticle>> fetchNewsArticles();
  Future<int> fetchCaseTotal();
  Future<List<ContactUsContact>> fetchContactUsContacts();
  Future<String> fetchPrivacyPolicy();
  Future<void> registerUser(Registration _cases);
  Future<List<String>> fetchCountryList();
}

class AppDataRepository implements DataRepository {
  final String TAG = "AppDataRepository: ";
  final DB _db;
  List<String> _countries;

  AppDataRepository(this._db);

  @override
  Future<List<ReportedCase>> fetchCases(String lang) {
    try {
      return _db.fetchCases(lang);
    } catch (e) {
      throw DataFetchException(e);
    }
  }

  @override
  Future<List<NewsArticle>> fetchNewsArticles() {
    try {
      return _db
          .fetchNewsArticles(); //caching for news articles must also be implemented
    } catch (e) {
      throw DataFetchException(e);
    }
  }

  @override
  Future<int> fetchCaseTotal() {
    try {
      return _db
          .fetchCaseTotal(); //caching for news articles must also be implemented
    } catch (e) {
      throw DataFetchException(e);
    }
  }

  @override
  Future<List<ContactUsContact>> fetchContactUsContacts() {
    try {
      return _db
          .fetchContactUsContacts(); //caching for news articles must also be implemented
    } catch (e) {
      throw DataFetchException(e);
    }
  }

  @override
  Future<String> fetchPrivacyPolicy() {
    try {
      return _db
          .fetchPrivacyPolicy(); //caching for news articles must also be implemented
    } catch (e) {
      throw DataFetchException(e);
    }
  }

  @override
  Future<void> registerUser(Registration _cases) {
    try {
      return _db.registerUser(
          _cases); //caching for news articles must also be implemented
    } catch (e) {
      throw e; //passing exception to the UI
    }
  }

  @override
  Future<List<String>> fetchCountryList() async {
    try {
      if (_countries == null) {
        _countries = await _db.fetchCountries();
        return _countries;
      }
      return _countries;
    } catch (e) {
      throw e; //passing exception to the UI
    }
  }
}
