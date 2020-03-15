import 'package:selftrackingapp/exceptions/data_fetch_exception.dart';
import 'package:selftrackingapp/models/case.dart';
import 'package:selftrackingapp/models/news_article.dart';
import 'package:selftrackingapp/networking/db.dart';

abstract class DataRepository {
  Future<List<ReportedCase>> fetchCases();
  Future<List<NewsArticle>> fetchNewsArticles();
  Future<int> fetchCaseTotal();
}

class AppDataRepository implements DataRepository {
  AppDataRepository(this._db);
  final String TAG = "AppDataRepository: ";
  final DB _db;

  @override
  Future<List<ReportedCase>> fetchCases() {
    try {
      return _db.fetchCases();
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
}
