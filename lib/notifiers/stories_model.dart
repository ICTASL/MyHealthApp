import 'package:flutter/cupertino.dart';

import '../models/news_article.dart';
import '../models/news_article.dart';

class StoriesModel extends ChangeNotifier {
  final List<NewsArticle> _articles = [];

  /// An unmodifiable view of the items in the cart.
  List<NewsArticle> get articles => _articles;

  void add(NewsArticle article) {
    if (!_articles.contains(article)) {
      _articles.insert(0, article);
      notifyListeners();
    }
  }
}
